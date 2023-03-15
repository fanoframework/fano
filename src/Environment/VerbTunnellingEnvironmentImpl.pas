{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerbTunnellingEnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    EnvironmentIntf,
    EnvironmentEnumeratorIntf,
    DecoratorEnvironmentImpl;

type

    (*!------------------------------------------------
     * class having capability to retrieve
     * CGI environment variable and override HTTP method
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TVerbTunnellingEnvironment = class(TDecoratorEnvironment)
    private

        function overrideMethod(
            const originalMethod : string;
            const methodOverrideHeader : string
        ) : string;
    public

        (*!-----------------------------------------
         * Retrieve an environment variable
         *------------------------------------------
         * @param key name of variable
         * @return variable value
         *------------------------------------------*)
        function env(const keyName : string) : string; override;


        {-----------------------------------------
         Retrieve REQUEST_METHOD environment variable
        ------------------------------------------}
        function requestMethod() : string; override;

    end;

implementation

uses

    sysutils,
    EInvalidMethodImpl;

    function TVerbTunnellingEnvironment.overrideMethod(
        const originalMethod : string;
        const methodOverrideHeader : string
    ) : string;
    var allowed : boolean;
    begin
        result := originalMethod;
        if (originalMethod = 'POST') then
        begin
            if (methodOverrideHeader <> '') then
            begin
                //if we get here, header X-HTTP-Method-Override is set
                result := methodOverrideHeader;
            end;
        end;

        allowed := (result = 'GET') or
            (result = 'POST') or
            (result = 'PUT') or
            (result = 'DELETE') or
            (result = 'OPTIONS') or
            (result = 'PATCH') or
            (result = 'HEAD');

        if not allowed then
        begin
            //something is not right
            raise EInvalidMethod.createFmt(
                sErrInvalidMethod,
                [ methodOverrideHeader ]
            );
        end;
    end;

    (*!-----------------------------------------
     * Retrieve an environment variable
     *------------------------------------------
     * @param key name of variable
     * @return variable value
     *------------------------------------------*)
    function TVerbTunnellingEnvironment.env(const keyName : string) : string;
    begin
        if (keyName = 'REQUEST_METHOD') then
        begin
            result := overrideMethod(
                fDecoratedEnv.requestMethod(),
                uppercase(fDecoratedEnv['HTTP_X_HTTP_METHOD_OVERRIDE'])
            );
        end else
        begin
            result := fDecoratedEnv[keyName];
        end;
    end;

    {-----------------------------------------
     Retrieve REQUEST_METHOD environment variable
    ------------------------------------------}
    function TVerbTunnellingEnvironment.requestMethod() : string;
    begin
        result := env('REQUEST_METHOD');
    end;

end.
