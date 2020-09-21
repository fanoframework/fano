{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit SendmailMailerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TSendmailMailer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TSendmailMailerFactory = class(TFactory, IDependencyFactory)
    private
        fSendmailBin : string;
    public
        constructor create();
        function sendmailBin(const sendmailBinPath : string) : TSendmailMailerFactory;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    SendmailConsts,
    SendmailMailerImpl;

    constructor TSendmailMailerFactory.create();
    begin
        fSendmailBin := DEFAULT_SENDMAIL_BIN;
    end;

    function TSendmailMailerFactory.sendmailBin(const sendmailBinPath : string) : TSendmailMailerFactory;
    begin
        fSendmailBin := sendmailBinPath;
        result := self;
    end;

    function TSendmailMailerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TSendmailMailer.create(fSendmailBin);
    end;

end.
