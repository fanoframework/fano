{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DbPasswHashAuthImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    PasswordHashIntf,
    CredentialTypes,
    RdbmsIntf,
    AbstractPasswHashAuthImpl;

type

    (*!------------------------------------------------
     * class having capability to authenticate user
     * using password hash stored in RDBMS
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TDbPasswHashAuth = class (TAbstractPasswHashAuth)
    private
        fRdbms : IRdbms;
        fCredentialTable : shortstring;
        fCredentialColumn : shortstring;
        fPasswHashColumn : shortstring;
        fPasswSaltColumn : shortstring;
    protected
        (*!------------------------------------------------
         * retrieve password hash and salt from storage using
         * credential
         *-------------------------------------------------
         * @param credential username/user id to get password hash/salt
         * @return credentialFound credential found in storage or not
         * @return passwHash hash password
         * @return passwSalt salt password
         *-------------------------------------------------*)
        procedure retrieveHashSaltFromStorage(
            const credential : string;
            out credentialFound : boolean;
            out passwHash : string;
            out passwSalt : string
        ); override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param passwHash password hash verifier
         * @param rdbmsInst RDMBS instance
         * @param credentialTable name of table
         * @param credentialColumn name of column for credential
         * @param passwHashColumn name of column for password hash
         * @param passwSaltColumn name of column for password salt
         *-------------------------------------------------*)
        constructor create(
            const passwHash : IPasswordHash;
            const rdbmsInst : IRdbms;
            const credentialTable : shortstring;
            const credentialColumn : shortstring;
            const passwHashColumn : shortstring;
            const passwSaltColumn : shortstring = ''
        );

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;

    end;

implementation

uses

    RdbmsStatementIntf,
    RdbmsResultSetIntf,
    EAuthImpl;

resourcestring

    rsDbAuthRdbmsNil = 'Rdbms can not be nil';
    rsDbAuthEmptyTable = 'Table name can not be empty';
    rsDbAuthEmptyCredentialCol = 'Credential column name can not be empty';
    rsDbAuthEmptyPasswHashCol = 'Password hash column name can not be empty';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param passwHash password hash verifier
     * @param rdbmsInst RDMBS instance
     * @param credentialTable name of table
     * @param credentialColumn name of column for credential
     * @param passwHashColumn name of column for password hash
     * @param passwSaltColumn name of column for password salt
     *-------------------------------------------------*)
    constructor TDbPasswHashAuth.create(
        const passwHash : IPasswordHash;
        const rdbmsInst : IRdbms;
        const credentialTable : shortstring;
        const credentialColumn : shortstring;
        const passwHashColumn : shortstring;
        const passwSaltColumn : shortstring = ''
    );
    begin
        inherited create(passwHash);

        fRdbms := rdbmsInst;

        if fRdbms = nil then
        begin
            raise EAuth.create(rsDbAuthRdbmsNil);
        end;

        fCredentialTable := credentialTable;

        if fCredentialTable = '' then
        begin
            raise EAuth.create(rsDbAuthEmptyTable);
        end;

        fCredentialColumn := credentialColumn;

        if fCredentialColumn = '' then
        begin
            raise EAuth.create(rsDbAuthEmptyCredentialCol);
        end;

        fPasswHashColumn := passwHashColumn;

        if fPasswHashColumn = '' then
        begin
            raise EAuth.create(rsDbAuthEmptyPasswHashCol);
        end;

        //salt column can be empty,
        //which means password is not salted or password hash algorithm already
        //provides salt such as BCrypt
        fPasswSaltColumn := passwSaltColumn;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TDbPasswHashAuth.destroy();
    begin
        fRdbms := nil;
        inherited destroy();
    end;


    (*!------------------------------------------------
     * retrieve password hash and salt from storage using
     * credential
     *-------------------------------------------------
     * @param credential username/user id to get password hash/salt
     * @return credentialFound credential found in storage or not
     * @return passwHash hash password
     * @return passwSalt salt password
     *-------------------------------------------------*)
    procedure TDbPasswHashAuth.retrieveHashSaltFromStorage(
        const credential : string;
        out credentialFound : boolean;
        out passwHash : string;
        out passwSalt : string
    );
    var statement : IRdbmsStatement;
        resultSet : IRdbmsResultSet;
        columns : string;
    begin
        passwHash := '';
        passwSalt := '';

        if fPasswSaltColumn = '' then
        begin
            //not using salt column or password hash algorithm already
            //provider built-in salt generation such as Bcrypt
            columns:= '`' + fPasswHashColumn + '`';
        end else
        begin
            columns := '`' + fPasswHashColumn + '`' + ',' +
                '`' + fPasswSaltColumn + '`';
        end;

        statement := fRdbms.prepare(
            'SELECT ' + columns + ' FROM ' +
            '`' + fCredentialTable + '`' +
            ' WHERE `' +fCredentialColumn + '` = :credential'
        );
        statement.paramStr('credential', credential);
        resultSet := statement.execute();
        credentialFound := resultSet.resultCount() <> 0;
        if credentialFound then
        begin
            passwHash := resultSet.fields().fieldByName(fPasswHashColumn).asString();
            if fPasswSaltColumn <> '' then
            begin
                passwSalt := resultSet.fields().fieldByName(fPasswSaltColumn).asString();
            end;
        end;
    end;

end.
