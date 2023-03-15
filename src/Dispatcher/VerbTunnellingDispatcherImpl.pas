{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerbTunnellingDispatcherImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    StdInIntf,
    ResponseIntf,
    DispatcherIntf,
    InjectableObjectImpl;

type

    (*!---------------------------------------------------
     * decorator dispatcher that wrap environment to allow
     * HTTP verb to be override (verb tunneling).
     *
     * This class is provided so web application running behind
     * strict policy firewall which only allows GET and POST can
     * override its HTTP method using header X-Http-Method-Override
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TVerbTunnellingDispatcher = class(TInjectableObject, IDispatcher)
    private
        fActualDispatcher : IDispatcher;
    public
        constructor create(const actualDispatcher : IDispatcher);
        destructor destroy(); override;

        (*!-------------------------------------------
         * dispatch request
         *--------------------------------------------
         * @param env CGI environment
         * @param stdIn STDIN reader
         * @return response
         *--------------------------------------------*)
        function dispatchRequest(
            const env: ICGIEnvironment;
            const stdIn : IStdIn
        ) : IResponse;
    end;

implementation

uses

    EnvironmentEnumeratorIntf,
    VerbTunnellingEnvironmentImpl;

    constructor TVerbTunnellingDispatcher.create(const actualDispatcher : IDispatcher);
    begin
        fActualDispatcher := actualDispatcher;
    end;

    destructor TVerbTunnellingDispatcher.destroy();
    begin
        fActualDispatcher := nil;
        inherited destroy();
    end;

    (*!-------------------------------------------
     * dispatch request
     *--------------------------------------------
     * @param env CGI environment
     * @param stdIn STDIN reader
     * @return response
     *--------------------------------------------*)
    function TVerbTunnellingDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    var verbEnv : ICGIEnvironment;
    begin
        verbEnv := TVerbTunnellingEnvironment.create(env);
        try
            result := fActualDispatcher.dispatchRequest(verbEnv, stdIn);
        finally
            //make sure we remove reference to avoid memory leak
            verbEnv := nil;
        end;
    end;
end.
