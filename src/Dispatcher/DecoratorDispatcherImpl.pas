{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorDispatcherImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    StdInIntf,
    ResponseIntf,
    DispatcherIntf;

type

    (*!---------------------------------------------------
     * Decorator dispatcher class having capability dispatch
     * request using external dispatcher
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TDecoratorDispatcher = class (TInterfacedObject, IDispatcher)
    protected
        fActualDispatcher : IDispatcher;
    public
        constructor create(const actualDispatcher : IDispatcher);

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
        ) : IResponse; virtual;
    end;

implementation

    constructor TDecoratorDispatcher.create(const actualDispatcher : IDispatcher);
    begin
        fActualDispatcher := actualDispatcher;
    end;

    (*!-------------------------------------------
     * dispatch request
     *--------------------------------------------
     * @param env CGI environment
     * @param stdIn STDIN reader
     * @return response
     *--------------------------------------------*)
    function TDecoratorDispatcher.dispatchRequest(
        const env: ICGIEnvironment;
        const stdIn : IStdIn
    ) : IResponse;
    begin
        result := fActualDispatcher.dispatchRequest(env, stdIn);
    end;
end.
