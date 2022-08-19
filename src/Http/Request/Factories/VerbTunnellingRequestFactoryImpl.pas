{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerbTunnellingRequestFactoryImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    StdInIntf,
    RequestIntf,
    RequestFactoryIntf,
    DecoratorRequestFactoryImpl;

type
    (*!------------------------------------------------
     * factory class for TVerbTunnellingRequest
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TVerbTunnellingRequestFactory = class(TDecoratorRequestFactory)
    public

        (*!------------------------------------------------
         * build instance of IRequest
         *-------------------------------------------------
         * by default it just delegate task to actual factory
         * inherited class may want  to modify this
         *-------------------------------------------------
         * @param ICGIEnvironment CGI environment instance
         * @param IStdIn Standard input instance
         * @return IRequest newly created instance
         *------------------------------------------------*)
        function build(const env : ICGIEnvironment; const stdIn : IStdIn) : IRequest; override;

    end;

implementation

uses

    VerbTunnellingRequestImpl;

    (*!------------------------------------------------
     * build instance of IRequest
     *-------------------------------------------------
     * @param ICGIEnvironment CGI environment instance
     * @param IStdIn Standard input instance
     * @return IRequest newly created instance
     *------------------------------------------------*)
    function TVerbTunnellingRequestFactory.build(
        const env : ICGIEnvironment;
        const stdIn : IStdIn
    ) : IRequest;
    var request : IRequest;
    begin
        request := inherited build(env, stdIn);
        result := TVerbTunnellingRequest.create(request);
    end;
end.
