{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RdbmsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsIntf,
    RdbmsResultSetIntf,
    RdbmsStatementIntf,
    RdbmsFieldsIntf,
    RdbmsFieldIntf,
    db,
    sqldb,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * handle relational database operation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TRdbms = class(TInjectableObject, IRdbms, IRdbmsResultSet, IRdbmsFields, IRdbmsField, IRdbmsStatement)
    private
        dbInstance : TSQLConnector;
        fQuery : TSQLQuery;
        currentField : TField;
        connectionType : string;

        //true if current sql is if data retrival command (SELECT)
        //false for everything else
        isSelect : boolean;

        procedure raiseExceptionIfInvalidConnection();
        procedure raiseExceptionIfInvalidQuery();
        procedure raiseExceptionIfInvalidField();
    public
        constructor create(const connType : string);
        destructor destroy(); override;

        (*!------------------------------------------------
         * create connection to database server
         *-------------------------------------------------
         * @param host hostname/ip where MySQl server run
         * @param dbname database name to use
         * @param username user name credential to login
         * @param password password credential to login
         * @param port TCP port where MySQL listen
         * @return current instance
         *-------------------------------------------------*)
        function connect(
            const host : string;
            const dbname : string;
            const username : string;
            const password : string;
            const port : word
        ) : IRdbms;

        (*!------------------------------------------------
        * get current database name
        *-------------------------------------------------
        * @return database name
        *-------------------------------------------------*)
        function getDbName() : string;

        (*!------------------------------------------------
         * initiate a transaction
         *-------------------------------------------------
         * @param connectionString
         * @return database connection instance
         *-------------------------------------------------*)
        function beginTransaction() : IRdbms;

        (*!------------------------------------------------
         * rollback a transaction
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function rollback() : IRdbms;

        (*!------------------------------------------------
         * commit a transaction
         *-------------------------------------------------
         * @return database connection instance
         *-------------------------------------------------*)
        function commit() : IRdbms;

        (*!------------------------------------------------
         * total data in result set
         *-------------------------------------------------
         * @return total data in current result set
         *-------------------------------------------------*)
        function resultCount() : largeInt;

        (*!------------------------------------------------
         * test if we in end of result set
         *-------------------------------------------------
         * @return true if at end of file and no more record
         *-------------------------------------------------*)
        function eof() : boolean;

        (*!------------------------------------------------
         * advanced cursor position to next record
         *-------------------------------------------------
         * @return true if at end of file and no more record
         *-------------------------------------------------*)
        function next() : IRdbmsResultSet;

        (*!------------------------------------------------
         * get list of fields
         *-------------------------------------------------
         * @return current fields
         *-------------------------------------------------*)
        function fields() : IRdbmsFields;

        (*!------------------------------------------------
         * number of fields
         *-------------------------------------------------
         * @return integer number of fields
         *-------------------------------------------------*)
        function fieldCount() : integer;

        (*!------------------------------------------------
         * get field by name
         *-------------------------------------------------
         * @return field
         *-------------------------------------------------*)
        function fieldByName(const name : shortstring) : IRdbmsField;

        (*!------------------------------------------------
         * get field by name
         *-------------------------------------------------
         * @return field
         *-------------------------------------------------*)
        function fieldByIndex(const indx : integer) : IRdbmsField;

        (*!------------------------------------------------
         * return field data as boolean
         *-------------------------------------------------
         * @return boolean value of field
         *-------------------------------------------------*)
        function asBoolean() : boolean;

        (*!------------------------------------------------
         * return field data as integer value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asInteger() : integer;

        (*!------------------------------------------------
         * return field data as string value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asString() : string;

        (*!------------------------------------------------
         * return field data as double value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asFloat() : double;

        (*!------------------------------------------------
         * return field data as datetime value
         *-------------------------------------------------
         * @return value of field
         *-------------------------------------------------*)
        function asDateTime() : TDateTime;

        (*!------------------------------------------------
         * prepare sql statement
         *-------------------------------------------------
         * @param sql sql command
         * @return result set
         *-------------------------------------------------*)
        function prepare(const sql : string) : IRdbmsStatement;

        (*!------------------------------------------------
         * execute prepared statement
         *-------------------------------------------------
         * @return result set
         *-------------------------------------------------*)
        function execute() : IRdbmsResultSet;

        (*!------------------------------------------------
         * set parameter string value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramStr(const strName : string; const strValue : string) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter integer value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramInt(const strName : string; const strValue : integer) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter float value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramFloat(const strName : string; const strValue : double) : IRdbmsStatement;

        (*!------------------------------------------------
         * set parameter datetime value
         *-------------------------------------------------
         * @return current statement
         *-------------------------------------------------*)
        function paramDateTime(const strName : string; const strValue : TDateTime) : IRdbmsStatement;
    end;

implementation

uses

    SysUtils,
    EInvalidDbConnectionImpl,
    EInvalidDbQueryImpl,
    EInvalidDbFieldImpl;

resourcestring

    sErrInvalidConnection = 'Invalid connection';
    sErrInvalidQuery = 'Invalid fQuery';
    sErrInvalidField = 'Invalid field.';

    constructor TRdbms.create(const connType : string);
    begin
        dbInstance := nil;
        fQuery := nil;
        currentField := nil;
        connectionType := connType;
    end;

    destructor TRdbms.destroy();
    begin
        fQuery.free();
        dbInstance.free();
        currentField := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * create connection to database server
     *-------------------------------------------------
     * @param host hostname/ip where MySQl server run
     * @param dbname database name to use
     * @param username user name credential to login
     * @param password password credential to login
     * @param port TCP port where MySQL listen
     * @return current instance
     *-------------------------------------------------*)
    function TRdbms.connect(
        const host : string;
        const dbname : string;
        const username : string;
        const password : string;
        const port : word
    ) : IRdbms;
    begin
        if (dbInstance = nil) then
        begin
            dbInstance := TSQLConnector.create(nil);
            dbInstance.transaction := TSQLTransaction.create(dbInstance);

            //by default SqlDb TSQLConnection will start transaction as needed
            //we do not want that. let developer decide for themselves
            //but somehow SqlDb always want to use transaction so following
            //line will cause EDatabaseError
            //"Error: attempt to implicitly start a transaction on Connection..."
            //dbInstance.Transaction.Options := [stoExplicitStart];

            fQuery := TSQLQuery.create(nil);
            fQuery.database := dbInstance;
        end;
        dbInstance.ConnectorType := connectionType;
        dbInstance.HostName := host;
        dbInstance.DatabaseName := dbname;
        dbInstance.UserName := username;
        dbInstance.Password := password;
        result := self;
    end;

    (*!------------------------------------------------
     * get current database name
     *-------------------------------------------------
     * @return database name
     *-------------------------------------------------*)
    function TRdbms.getDbName() : string;
    begin
        result := dbInstance.DatabaseName;
    end;

    procedure TRdbms.raiseExceptionIfInvalidConnection();
    begin
        if (dbInstance = nil) then
        begin
            raise EInvalidDbConnection.create(sErrInvalidConnection);
        end;
    end;

    procedure TRdbms.raiseExceptionIfInvalidQuery();
    begin
        if (fQuery = nil) then
        begin
            raise EInvalidDbQuery.create(sErrInvalidQuery);
        end;
    end;

    (*!------------------------------------------------
     * initiate a transaction
     *-------------------------------------------------
     * @param connectionString
     * @return database connection instance
     *-------------------------------------------------*)
    function TRdbms.beginTransaction() : IRdbms;
    begin
        raiseExceptionIfInvalidConnection();
        dbInstance.startTransaction();
        result := self;
    end;

    (*!------------------------------------------------
     * rollback a transaction
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    function TRdbms.rollback() : IRdbms;
    begin
        raiseExceptionIfInvalidConnection();
        dbInstance.transaction.rollback();
        result := self;
    end;

    (*!------------------------------------------------
     * commit a transaction
     *-------------------------------------------------
     * @return database connection instance
     *-------------------------------------------------*)
    function TRdbms.commit() : IRdbms;
    begin
        raiseExceptionIfInvalidConnection();
        dbInstance.transaction.commit();
        result := self;
    end;

    (*!------------------------------------------------
     * number of record in result set
     *-------------------------------------------------
     * @return largeInt number of records
     *-------------------------------------------------*)
    function TRdbms.resultCount() : largeInt;
    begin
        raiseExceptionIfInvalidQuery();
        result := fQuery.RecordCount;
    end;

    (*!------------------------------------------------
     * test if we in end of result set
     *-------------------------------------------------
     * @return true if at end of file and no more record
     *-------------------------------------------------*)
    function TRdbms.eof() : boolean;
    begin
        raiseExceptionIfInvalidQuery();
        result := fQuery.eof;
    end;

    (*!------------------------------------------------
     * advanced cursor position to next record
     *-------------------------------------------------
     * @return true if at end of file and no more record
     *-------------------------------------------------*)
    function TRdbms.next() : IRdbmsResultSet;
    begin
        raiseExceptionIfInvalidQuery();
        fQuery.next();
        result := self;
    end;

    (*!------------------------------------------------
     * advanced cursor position to next record
     *-------------------------------------------------
     * @return true if at end of file and no more record
     *-------------------------------------------------*)
    function TRdbms.fields() : IRdbmsFields;
    begin
        raiseExceptionIfInvalidQuery();
        result := self;
    end;

    (*!------------------------------------------------
     * number of fields
     *-------------------------------------------------
     * @return integer number of fields
     *-------------------------------------------------*)
    function TRdbms.fieldCount() : integer;
    begin
        raiseExceptionIfInvalidQuery();
        result := fQuery.fields.count;
    end;

    (*!------------------------------------------------
     * get field by name
     *-------------------------------------------------
     * @return field
     *-------------------------------------------------*)
    function TRdbms.fieldByName(const name : shortstring) : IRdbmsField;
    begin
        raiseExceptionIfInvalidQuery();
        currentField := fQuery.fields.fieldByName(name);
        result := self;
    end;

    (*!------------------------------------------------
     * get field by name
     *-------------------------------------------------
     * @return field
     *-------------------------------------------------*)
    function TRdbms.fieldByIndex(const indx : integer) : IRdbmsField;
    begin
        raiseExceptionIfInvalidConnection();
        currentField := fQuery.fields.fieldByNumber(indx);
        result := self;
    end;

    (*!------------------------------------------------
     * test currentField for validity and raise exception
     *-------------------------------------------------*)
    procedure TRdbms.raiseExceptionIfInvalidField();
    begin
        if (currentField = nil) then
        begin
            raise EInvalidDbField.create(sErrInvalidField);
        end;
    end;

    (*!------------------------------------------------
     * return field data as boolean
     *-------------------------------------------------
     * @return boolean value of field
     *-------------------------------------------------*)
    function TRdbms.asBoolean() : boolean;
    begin
        raiseExceptionIfInvalidField();
        result := currentField.asBoolean;
    end;

    (*!------------------------------------------------
     * return field data as integer value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asInteger() : integer;
    begin
        raiseExceptionIfInvalidField();
        result := currentField.asInteger;
    end;

    (*!------------------------------------------------
     * return field data as string value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asString() : string;
    begin
        raiseExceptionIfInvalidField();
        result := currentField.asString;
    end;

    (*!------------------------------------------------
     * return field data as double value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asFloat() : double;
    begin
        raiseExceptionIfInvalidField();
        result := currentField.asFloat;
    end;

    (*!------------------------------------------------
     * return field data as datetime value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asDateTime() : TDateTime;
    begin
        raiseExceptionIfInvalidField();
        result := currentField.asDateTime;
    end;

    (*!------------------------------------------------
     * prepare sql statement
     *-------------------------------------------------
     * @param sql sql command
     * @return result set
     *-------------------------------------------------*)
    function TRdbms.prepare(const sql : string) : IRdbmsStatement;
    begin
        raiseExceptionIfInvalidQuery();
        //make sure to close first.
        fQuery.close();
        isSelect := (pos('select', trimLeft(lowerCase(sql))) = 1);
        fQuery.sql.text := sql;
        result := self;
    end;

    (*!------------------------------------------------
     * execute statement
     *-------------------------------------------------
     * @return result set
     *-------------------------------------------------*)
    function TRdbms.execute() : IRdbmsResultSet;
    begin
        raiseExceptionIfInvalidConnection();
        if (isSelect) then
        begin
            fQuery.open();
        end else
        begin
            fQuery.execSql();
        end;
        result:= self;
    end;

    (*!------------------------------------------------
     * set parameter string value
     *-------------------------------------------------
     * @return current statement
     *-------------------------------------------------*)
    function TRdbms.paramStr(const strName : string; const strValue : string) : IRdbmsStatement;
    begin
        raiseExceptionIfInvalidConnection();
        fQuery.params.paramByName(strName).asString := strValue;
        result := self;
    end;

    (*!------------------------------------------------
     * set parameter integer value
     *-------------------------------------------------
     * @return current statement
     *-------------------------------------------------*)
    function TRdbms.paramInt(const strName : string; const strValue : integer) : IRdbmsStatement;
    begin
        raiseExceptionIfInvalidConnection();
        fQuery.params.paramByName(strName).asInteger := strValue;
        result := self;
    end;

    (*!------------------------------------------------
     * set parameter float value
     *-------------------------------------------------
     * @return current statement
     *-------------------------------------------------*)
    function TRdbms.paramFloat(const strName : string; const strValue : double) : IRdbmsStatement;
    begin
        raiseExceptionIfInvalidConnection();
        fQuery.params.paramByName(strName).asFloat := strValue;
        result := self;
    end;

    (*!------------------------------------------------
     * set parameter datetime value
     *-------------------------------------------------
     * @return current statement
     *-------------------------------------------------*)
    function TRdbms.paramDateTime(const strName : string; const strValue : TDateTime) : IRdbmsStatement;
    begin
        raiseExceptionIfInvalidConnection();
        fQuery.params.paramByName(strName).asDateTime := strValue;
        result := self;
    end;
end.
