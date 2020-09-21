{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestHeadersImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyHeadersIntf,
    EnvironmentIntf,
    CloneableIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * read HTTP request headers
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TRequestHeaders = class(TInjectableObject, IReadonlyHeaders, ICloneable)
    private
        fEnv : ICGIEnvironment;

        function headerToEnvVar(const key : string) : string;
    public
        constructor create(const env : ICGIEnvironment);
        destructor destroy(); override;

        (*!------------------------------------
         * get http header
         *-------------------------------------
         * @param key name  of http header to get
         * @return header value
         * @throws EHeaderNotSet
         *-------------------------------------*)
        function getHeader(const key : shortstring) : string;

        (*!------------------------------------
         * test if http header already been set
         *-------------------------------------
         * @param key name  of http header to test
         * @return boolean true if header is set
         *-------------------------------------*)
        function has(const key : shortstring) : boolean;

        function clone() : ICloneable;
    end;

implementation

uses

    SysUtils,
    HeaderConsts,
    EHeaderNotSetImpl;

    constructor TRequestHeaders.create(const env : ICGIEnvironment);
    begin
        inherited create();
        fEnv := env;
    end;

    destructor TRequestHeaders.destroy();
    begin
        fEnv := nil;
        inherited destroy();
    end;

    (*!------------------------------------
     * convert http header into environment variable
     *-------------------------------------
     * @param key name  of http header to get
     * @return header value
     *--------------------------------------
     * for example
     * input: X-Requested-With
     * output: HTTP_X_REQUESTED_WITH
     *-------------------------------------*)
    function TRequestHeaders.headerToEnvVar(const key : string) : string;
    begin
        result := stringReplace(UpperCase(key), '-', '_', [rfReplaceAll]);
        if not ((key = 'Content-Length') or (key = 'Content-Type')) then
        begin
            result := 'HTTP_' + result;
        end;
    end;

    (*!------------------------------------
     * get http header
     *-------------------------------------
     * @param key name  of http header to get
     * @return header value
     * @throws EHeaderNotSet
     *-------------------------------------*)
    function TRequestHeaders.getHeader(const key : shortstring) : string;
    var envStr : string;
    begin
        envStr := headerToEnvVar(key);
        if (not has(key)) then
        begin
            raise EHeaderNotSet.createFmt(sErrHeaderNotSet, [envStr]);
        end;
        result := fEnv.env(envStr);
    end;

    (*!------------------------------------
     * test if http header already been set
     *-------------------------------------
     * @param key name  of http header to test
     * @return boolean true if header is set
     *-------------------------------------*)
    function TRequestHeaders.has(const key : shortstring) : boolean;
    var envStr : string;
        i, len : integer;
    begin
        envStr := headerToEnvVar(key);
        result := false;
        len := fEnv.enumerator.count();
        for i := 0 to len - 1 do
        begin
            if (fEnv.enumerator.getKey(i) = envStr) then
            begin
                result := true;
                exit;
            end;
        end
    end;

    function TRequestHeaders.clone() : ICloneable;
    begin
        result := TRequestHeaders.create(fEnv);
    end;

end.
