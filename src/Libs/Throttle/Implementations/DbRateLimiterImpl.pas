{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DbRateLimiterImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RdbmsIntf,
    RateLimiterIntf,
    RateTypes,
    AbstractRateLimiterImpl;

type

    (*!------------------------------------------------
     * rate limiter implementation that stores data in
     * RDBMS table
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDbRateLimiter = class (TAbstractRateLimiter)
    private
        fRdbms : IRdbms;

        (*!---------------------------
         * table name
         *-----------------------------*)
        fTableName : string;

        (*!---------------------------
         * name of column to store id
         * it is assumed varchar
         *-----------------------------*)
        fIdColumnName : string;

        (*!---------------------------
         * name of column to store maximum
         * number of operation allowed
         * It is assumed int
         *-----------------------------*)
        fOperationColumnName : string;

        (*!---------------------------
         * name of column to store timestamp
         * time to reset operation
         * It is assumed int
         *-----------------------------*)
        fResetTimestampColumnName : string;

        fRateLimitRec : TRateLimitRec;
    protected
        (*!------------------------------------------------
         * read rate limit info from storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        function readRateLimit(
            const identifier : shortstring
        ) : PRateLimitRec; override;

        (*!------------------------------------------------
         * insert new rate limit info to storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        procedure createRateLimit(
            const identifier : shortstring;
            rateLimit: PRateLimitRec
        ); override;

        (*!------------------------------------------------
         * update rate limit info to storage
         *
         * @param identifier id to locate info from storage
         *-----------------------------------------------*)
        procedure updateRateLimit(
            const identifier : shortstring;
            rateLimit: PRateLimitRec
        ); override;
    public

        constructor create(
            const db : IRdbms;
            const tableName : string;
            const idColumnName : string;
            const operationColumnName : string;
            const resetTimestampColumnName : string
        );

    end;

implementation

uses

    RdbmsResultSetIntf,
    RdbmsFieldsIntf;

    constructor TDbRateLimiter.create(
        const db : IRdbms;
        const tableName : string;
        const idColumnName : string;
        const operationColumnName : string;
        const resetTimestampColumnName : string
    );
    begin
        fRdbms := db;
        fTableName := tableName;
        fIdColumnName := idColumnName;
        fOperationColumnName := operationColumnName;
        fResetTimestampColumnName := resetTimestampColumnName;
        fRateLimitRec := default(TRateLimitRec);
    end;

    function TDbRateLimiter.readRateLimit(
        const identifier : shortstring
    ) : PRateLimitRec;
    var res : IRdbmsResultSet;
        afields : IRdbmsFields;
    begin
        res := fRdbms.prepare(
            'SELECT ' +
                fOperationColumnName + ', ' +
                fResetTimestampColumnName +
            ' FROM ' + fTableName +
            ' WHERE ' + fIdColumnName + ' = :' + fIdColumnName
        ).paramStr(fIdColumnName, identifier)
        .execute();

        if (res.resultCount() = 0) then
        begin
            result := nil;
        end else
        begin
            afields := res.fields();

            fRateLimitRec.currentOperations := afields.fieldByName(
                fOperationColumnName
            ).asInteger;

            fRateLimitRec.resetTimestamp := afields.fieldByName(
                fResetTimestampColumnName
            ).asInteger;

            result := @fRateLimitRec;

        end;
    end;

    (*!------------------------------------------------
     * insert new rate limit info to storage
     *
     * @param identifier id to locate info from storage
     *-----------------------------------------------*)
    procedure TDbRateLimiter.createRateLimit(
        const identifier : shortstring;
        rateLimit: PRateLimitRec
    );
    begin
        fRdbms.prepare(
            'INSERT INTO ' + fTableName +
                '(' +
                    fIdColumnName + ', ' +
                    fOperationColumnName + ', ' +
                    fResetTimestampColumnName +
            ') VALUES (' +
                ':' + fIdColumnName + ', ' +
                ':' + fOperationColumnName + ', ' +
                ':' + fResetTimestampColumnName +
            ')'
        ).paramStr(fIdColumnName, identifier)
        .paramInt(fOperationColumnName, rateLimit^.currentOperations)
        .paramInt(fResetTimestampColumnName, rateLimit^.resetTimestamp)
        .execute();

        //SqlDb ALWAYS implicitly start transaction so commmit() is required
        fRdbms.commit();
    end;

    (*!------------------------------------------------
     * update rate limit info to storage
     *
     * @param identifier id to locate info from storage
     *-----------------------------------------------*)
    procedure TDbRateLimiter.updateRateLimit(
        const identifier : shortstring;
        rateLimit: PRateLimitRec
    );
    begin
        fRdbms.prepare(
            'UPDATE ' + fTableName +
                ' SET ' +
                    fOperationColumnName + ' = :' + fOperationColumnName + ', ' +
                    fResetTimestampColumnName + ' = :' + fResetTimestampColumnName +
            ' WHERE ' + fIdColumnName + ' = :' + fIdColumnName
        ).paramStr(fIdColumnName, identifier)
        .paramInt(fOperationColumnName, rateLimit^.currentOperations)
        .paramInt(fResetTimestampColumnName, rateLimit^.resetTimestamp)
        .execute();

        //SqlDb ALWAYS implicitly start transaction so commmit() is required
        fRdbms.commit();
    end;

end.
