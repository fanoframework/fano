{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerbTunnellingRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    EnvironmentIntf,
    DecoratorRequestImpl;

type

    (*!------------------------------------------------
     * decorator class having capability as
     * wrap HTTP request and override http method
     * (http verb tunnelling)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TVerbTunnellingRequest = class(TDecoratorRequest)
    protected
        fVerbTunnelingEnv : ICGIEnvironment;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param IRequest actual request to be decorated
         *------------------------------------------------*)
        constructor create(const request : IRequest);

        (*!------------------------------------------------
         * destructor
         *------------------------------------------------*)
        destructor destroy(); override;


        (*!------------------------------------------------
         * get request method GET, POST, HEAD, etc
         *-------------------------------------------------
         * @return string request method
         *------------------------------------------------*)
        function getMethod() : string; override;

        (*!------------------------------------------------
         * get CGI environment
         *-------------------------------------------------
         * @return ICGIEnvironment
         *------------------------------------------------*)
        function getEnvironment() : ICGIEnvironment; override;

    end;

implementation

uses

    VerbTunnellingEnvironmentImpl;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param IRequest actual request to be decorated
     *------------------------------------------------*)
    constructor TVerbTunnellingRequest.create(const request : IRequest);
    begin
        inherited create(request);
        //decorate original environment
        fVerbTunnelingEnv := TVerbTunnellingEnvironment.create(request.env);
    end;

    destructor TVerbTunnellingRequest.destroy();
    begin
        fVerbTunnelingEnv := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * get request method GET, POST, HEAD, etc
     *-------------------------------------------------
     * @return string request method
     *------------------------------------------------*)
    function TVerbTunnellingRequest.getMethod() : string;
    begin
        result := fVerbTunnelingEnv.requestMethod();
    end;

    (*!------------------------------------------------
     * get CGI environment
     *-------------------------------------------------
     * @return ICGIEnvironment
     *------------------------------------------------*)
    function TVerbTunnellingRequest.getEnvironment() : ICGIEnvironment;
    begin
        result := fVerbTunnelingEnv;
    end;
end.
