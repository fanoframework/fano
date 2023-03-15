{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ExistsValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    RdbmsIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data must be exists in RDBMS database
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TExistsValidator = class(TBaseValidator)
    private
        fRdbms : IRdbms;
        fTableName : shortstring;
        fPrimaryKey : shortstring;
    protected
        (*!------------------------------------------------
         * actual data validation
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValidData(
            const dataToValidate : string;
            const dataCollection : IReadOnlyList;
            const request : IRequest
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create(
            const rdbms : IRdbms;
            const tableName : shortstring;
            const primaryKey : shortstring
        );

        (*!------------------------------------------------
         * destructor
         *-------------------------------------------------*)
        destructor destroy(); override;
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeInteger = 'Field %s must be exists in database';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TExistsValidator.create(
        const rdbms : IRdbms;
        const tableName : shortstring;
        const primaryKey : shortstring
    );
    begin
        inherited create(sErrFieldMustBeInteger);
        fRdbms := rdbms;
        fTableName := tableName;
        fPrimaryKey := primaryKey;
    end;

    (*!------------------------------------------------
     * destructor
     *-------------------------------------------------*)
    destructor TExistsValidator.destroy();
    begin
        fRdbms := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     *-------------------------------------------------*)
    function TExistsValidator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var sql : string;
    begin
        sql := 'SELECT `' + fPrimaryKey + '` FROM `' + fTableName + '`' +
            'WHERE `' + fPrimaryKey + '` = :primaryId LIMIT 1';
        result := (fRdbms
            .prepare(sql)
            .paramStr('primaryId', dataToValidate)
            .execute()
            .resultCount() > 0);
    end;end.
