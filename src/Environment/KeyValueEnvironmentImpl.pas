{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyValueEnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    KeyValuePairIntf,
    AbstractEnvironmentImpl;

type

    (*!------------------------------------------------
     * basic having capability to retrieve
     * CGI environment variable from key value pair
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TKeyValueEnvironment = class(TAbstractCGIEnvironment)
    private
        envVars : IKeyValuePair;
    public
        constructor create(const aEnvVars : IKeyValuePair);
        destructor destroy(); override;

        {-----------------------------------------
         Retrieve an environment variable
        ------------------------------------------}
        function env(const keyName : string) : string; override;

        (*!------------------------------------------------
         * get number of variables
         *-----------------------------------------------
         * @return number of variables
         *-----------------------------------------------*)
        function count() : integer; override;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring; override;
    end;

implementation

    constructor TKeyValueEnvironment.create(const aEnvVars : IKeyValuePair);
    begin
        envVars := aEnvVars;
    end;

    destructor TKeyValueEnvironment.destroy();
    begin
        inherited destroy();
        envVars := nil;
    end;

    {-----------------------------------------
     Retrieve an environment variable
    ------------------------------------------}
    function TKeyValueEnvironment.env(const keyName : string) : string;
    begin
        if (envVars.has(keyName)) then
        begin
            result := envVars.getValue(keyName);
        end else
        begin
            result := '';
        end;
    end;

    (*!------------------------------------------------
     * get number of variables
     *-----------------------------------------------
     * @return number of variables
     *-----------------------------------------------*)
    function TKeyValueEnvironment.count() : integer;
    begin
        result := envVars.count();
    end;

    (*!------------------------------------------------
     * get key by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TKeyValueEnvironment.getKey(const indx : integer) : shortstring;
    begin
        result := envVars.getKey(indx);
    end;
end.
