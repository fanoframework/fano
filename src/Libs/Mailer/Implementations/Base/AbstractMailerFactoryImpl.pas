{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit AbstractMailerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl,
    MailerConfigTypes;

type

    (*!------------------------------------------------
     * abstract factory class for mailer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TAbstractMailerFactory = class abstract (TFactory, IDependencyFactory)
    protected
        fMailerConfig : TMailerConfig;
    public
        constructor create();
        function host(const smtpHost : string) : TAbstractMailerFactory;
        function port(const smtpPort : word) : TAbstractMailerFactory;
        function username(const smtpUsername : string) : TAbstractMailerFactory;
        function password(const smtpPasw : string) : TAbstractMailerFactory;
        function useTls(const smtpTls : boolean) : TAbstractMailerFactory;
        function useSSL(const smtpSsl : boolean) : TAbstractMailerFactory;
    end;

implementation

    constructor TAbstractMailerFactory.create();
    begin
        //set some sensible default config
        fMailerConfig := default(TMailerConfig);
        fMailerConfig.host := 'localhost';
        fMailerConfig.port := 25;
        fMailerConfig.timeout := 5000;
    end;

    function TAbstractMailerFactory.host(const smtpHost : string) : TAbstractMailerFactory;
    begin
        fMailerConfig.host := smtpHost;
        result := self;
    end;

    function TAbstractMailerFactory.port(const smtpPort : word) : TAbstractMailerFactory;
    begin
        fMailerConfig.port := smtpPort;
        result := self;
    end;

    function TAbstractMailerFactory.username(const smtpUsername : string) : TAbstractMailerFactory;
    begin
        fMailerConfig.username := smtpUsername;
        result := self;
    end;

    function TAbstractMailerFactory.password(const smtpPasw : string) : TAbstractMailerFactory;
    begin
        fMailerConfig.password := smtpPasw;
        result := self;
    end;

    function TAbstractMailerFactory.useTls(const smtpTls : boolean) : TAbstractMailerFactory;
    begin
        fMailerConfig.useTLS := smtpTls;
        result := self;
    end;

    function TAbstractMailerFactory.useSSL(const smtpSsl : boolean) : TAbstractMailerFactory;
    begin
        fMailerConfig.useSSL := smtpSsl;
        result := self;
    end;

end.
