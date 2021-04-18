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

const

    VERB_OVERRIDE_PARAM = '_method';

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
        fVerbOverrideParam : shortstring;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param IRequest actual request to be decorated
         *------------------------------------------------*)
        constructor create(
            const request : IRequest;
            const verbOverrideParam : shortstring = VERB_OVERRIDE_PARAM
        );

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

    XVerbTunnellingEnvironmentImpl;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param IRequest actual request to be decorated
     *------------------------------------------------*)
    constructor TVerbTunnellingRequest.create(
        const request : IRequest;
        const verbOverrideParam : shortstring = VERB_OVERRIDE_PARAM
    );
    begin
        inherited create(request);
        //decorate original environment
        fVerbTunnelingEnv := TXVerbTunnellingEnvironment.create(
            request.env,
            self,
            verbOverrideParam
        );
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
