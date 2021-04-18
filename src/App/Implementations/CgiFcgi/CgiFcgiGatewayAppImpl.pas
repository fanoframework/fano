{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CgiFcgiGatewayAppImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf,
    AppIntf;

type

    (*!-----------------------------------------------
     * web application that implements IWebApplication
     * and run as ordinary CGI application or FastCGI application
     * based how application is invoked.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCgiFcgiGatewayApplication = class(TInterfacedObject, IWebApplication)
    private
        fCgiApp : IWebApplication;
        fFcgiApp : IWebApplication;

        function isRunAsFastCgi() : boolean;
    public
        (*!-----------------------------------------------
         * constructor
         *------------------------------------------------
         * @param cgiAppInst instance CGI Application
         * @param fcgiAppInst instance FastCGI application
         *-----------------------------------------------*)
        constructor create(
            const cgiAppInst : IWebApplication;
            const fcgiAppInst : IWebApplication
        );
        destructor destroy(); override;
        function run() : IRunnable;

    end;

implementation

uses

    sockets,
    fastcgi;

    (*!-----------------------------------------------
     * constructor
     *------------------------------------------------
     * @param cgiAppInst instance CGI Application
     * @param fcgiAppInst instance FastCGI application
     *-----------------------------------------------*)
    constructor TCgiFcgiGatewayApplication.create(
        const cgiAppInst : IWebApplication;
        const fcgiAppInst : IWebApplication
    );
    begin
        inherited create();
        fCgiApp := cgiAppInst;
        fFcgiApp := fcgiAppInst;
    end;

    destructor TCgiFcgiGatewayApplication.destroy();
    begin
        fCgiApp := nil;
        fFcgiApp := nil;
        inherited destroy();
    end;

    function TCgiFcgiGatewayApplication.isRunAsFastCgi() : boolean;
    var sockAddr :TSockAddr;
        len, err: longint;
    begin
        len := sizeOf(TSockAddr);
        fillChar(sockAddr, len, 0);
        err := fpGetPeerName(FCGI_LISTENSOCK_FILENO, @sockAddr, @len);
        result := (err = -1) and (socketError() = EsockENOTCONN);
    end;

    function TCgiFcgiGatewayApplication.run() : IRunnable;
    begin
        if (isRunAsFastCgi()) then
        begin
            result := fFcgiApp.run();
        end else
        begin
            result := fCgiApp.run();
        end;
    end;

end.
