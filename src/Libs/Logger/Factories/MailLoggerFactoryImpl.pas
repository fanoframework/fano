{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MailLoggerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TMailLogger
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMailLoggerFactory = class(TFactory, IDependencyFactory)
    private
        fMailerSvcName : shortstring;
        fTo : string;
        fFrom : string;
        fPrefix : string;
    public
        constructor create();
        function mailer(const mailerSvcName : shortstring) : TMailLoggerFactory;
        function recipient(const emailTo : string) : TMailLoggerFactory;
        function sender(const emailFrom : string) : TMailLoggerFactory;
        function prefix(const sPrefix : string) : TMailLoggerFactory;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    MailerIntf,
    MailLoggerImpl;

const

    DEFAULT_MAILER_SERVICE = 'mailer';
    DEFAULT_PREFIX = 'Fano';

    constructor TMailLoggerFactory.create();
    begin
        fMailerSvcName := DEFAULT_MAILER_SERVICE;
        fPrefix := DEFAULT_PREFIX;
    end;

    function TMailLoggerFactory.mailer(const mailerSvcName : shortstring) : TMailLoggerFactory;
    begin
        fMailerSvcName := mailerSvcName;
        result := self;
    end;

    function TMailLoggerFactory.recipient(const emailTo : string) : TMailLoggerFactory;
    begin
        fTo := emailTo;
        result := self;
    end;

    function TMailLoggerFactory.sender(const emailFrom : string) : TMailLoggerFactory;
    begin
        fFrom := emailFrom;
        result := self;
    end;

    function TMailLoggerFactory.prefix(const sPrefix : string) : TMailLoggerFactory;
    begin
        fPrefix := sPrefix;
        result := self;
    end;

    function TMailLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    var mailerInst : IMailer;
    begin
        mailerInst := container[fMailerSvcName] as IMailer;
        result := TMailLogger.create(mailerInst, fTo, fFrom, fPrefix);
    end;

end.
