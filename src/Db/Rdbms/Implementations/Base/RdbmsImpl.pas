{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
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
    ProxySQLConnectorImpl,
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
        fQuery : TSQLQuery;
        fCurrentField : TField;
        fConnectionType : string;

        //true if current sql is if data retrival command (SELECT)
        //false for everything else
        fIsSelect : boolean;

        procedure raiseExceptionIfInvalidConnection();
        procedure raiseExceptionIfInvalidQuery();
        procedure raiseExceptionIfInvalidField();
    protected
        fDbInstance : TProxySQLConnector;
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
        ) : IRdbms; virtual;

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
        fDbInstance := nil;
        fQuery := nil;
        fCurrentField := nil;
        fConnectionType := connType;
    end;

    destructor TRdbms.destroy();
    begin
        fQuery.free();
        fDbInstance.free();
        fCurrentField := nil;
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
        if (fDbInstance = nil) then
        begin
            fDbInstance := TProxySQLConnector.create(nil);
            fDbInstance.transaction := TSQLTransaction.create(fDbInstance);

            //by default SqlDb TSQLConnection will start transaction as needed
            //we do not want that. let developer decide for themselves
            //but somehow SqlDb always want to use transaction so following
            //line will cause EDatabaseError
            //"Error: attempt to implicitly start a transaction on Connection..."
            //fDbInstance.Transaction.Options := [stoExplicitStart];

            fQuery := TSQLQuery.create(nil);
            fQuery.database := fDbInstance;
        end;
        fDbInstance.ConnectorType := fConnectionType;
        fDbInstance.HostName := host;
        fDbInstance.DatabaseName := dbname;
        fDbInstance.UserName := username;
        fDbInstance.Password := password;
        result := self;
    end;

    (*!------------------------------------------------
     * get current database name
     *-------------------------------------------------
     * @return database name
     *-------------------------------------------------*)
    function TRdbms.getDbName() : string;
    begin
        result := fDbInstance.DatabaseName;
    end;

    procedure TRdbms.raiseExceptionIfInvalidConnection();
    begin
        if (fDbInstance = nil) then
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
        fDbInstance.startTransaction();
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
        fDbInstance.transaction.rollback();
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
        fDbInstance.transaction.commit();
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
        fCurrentField := fQuery.fields.fieldByName(name);
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
        fCurrentField := fQuery.fields.fieldByNumber(indx);
        result := self;
    end;

    (*!------------------------------------------------
     * test fCurrentField for validity and raise exception
     *-------------------------------------------------*)
    procedure TRdbms.raiseExceptionIfInvalidField();
    begin
        if (fCurrentField = nil) then
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
        result := fCurrentField.asBoolean;
    end;

    (*!------------------------------------------------
     * return field data as integer value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asInteger() : integer;
    begin
        raiseExceptionIfInvalidField();
        result := fCurrentField.asInteger;
    end;

    (*!------------------------------------------------
     * return field data as string value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asString() : string;
    begin
        raiseExceptionIfInvalidField();
        result := fCurrentField.asString;
    end;

    (*!------------------------------------------------
     * return field data as double value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asFloat() : double;
    begin
        raiseExceptionIfInvalidField();
        result := fCurrentField.asFloat;
    end;

    (*!------------------------------------------------
     * return field data as datetime value
     *-------------------------------------------------
     * @return value of field
     *-------------------------------------------------*)
    function TRdbms.asDateTime() : TDateTime;
    begin
        raiseExceptionIfInvalidField();
        result := fCurrentField.asDateTime;
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
        fIsSelect := (pos('select', trimLeft(lowerCase(sql))) = 1);
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
        if (fIsSelect) then
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
