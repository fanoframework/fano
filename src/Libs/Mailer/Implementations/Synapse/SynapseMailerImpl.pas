{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SynapseMailerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    ssl_openssl,
    synautil,
    smtpsend,
    AbstractMailerImpl,
    MailerConfigTypes;

type

    (*!------------------------------------------------
     * class having capability to
     * send email using Synopse SMTPSend library
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSynapseMailer = class(TAbstractMailer)
    private
        fMailerConfig : TMailerConfig;

        procedure raiseError(const fmt :string; const reason: string);
        function sendRaw(
            const cfg : TMailerConfig;
            const mailFrom :string;
            const mailTo: string;
            const mailData : TStrings
        ): boolean;
    public
        constructor create(const cfg : TMailerConfig);

        function send() : boolean; override;
    end;

implementation

uses

    SysUtils,
    EMailerImpl;

    constructor TSynapseMailer.create(const cfg : TMailerConfig);
    begin
        fMailerConfig := cfg;
    end;

    procedure TSynapseMailer.raiseError(const fmt :string; const reason: string);
    begin
        raise EMailer.createFmt(fmt, [reason]);
    end;

    function TSynapseMailer.sendRaw(
        const cfg : TMailerConfig;
        const mailFrom :string;
        const mailTo: string;
        const mailData : TStrings
    ): boolean;
    var
        SMTP: TSMTPSend;
        multipleEmailAddr : string;
        emailAddr : string;
    begin
        result := false;
        SMTP := TSMTPSend.create();
        try
            SMTP.AutoTLS := cfg.useTLS;
            SMTP.FullSSL := cfg.useSSL;
            SMTP.TargetHost := cfg.host;
            SMTP.TargetPort := IntToStr(cfg.port);
            SMTP.Username := cfg.username;
            SMTP.Password := cfg.password;

            if SMTP.Login() then
            begin
                if SMTP.MailFrom(GetEmailAddr(mailFrom), Length(mailData.Text)) then
                begin
                    //assume mailTo contains multiple mail addresses separated by comma
                    multipleEmailAddr := mailTo;
                    repeat
                        //pick single address and remove from multipleEmailAddr
                        emailAddr := GetEmailAddr(Trim(FetchEx(multipleEmailAddr, ',', '"')));
                        if emailAddr <> '' then
                        begin
                            result := SMTP.MailTo(emailAddr);
                        end;

                        if not result then
                        begin
                            break;
                        end;
                    until multipleEmailAddr = '';

                    if result then
                    begin
                        result := SMTP.MailData(mailData);
                        if not result then
                        begin
                            raiseError('SMTP Error MailData: %s', smtp.EnhCodeString);
                        end;
                    end else
                    begin
                        raiseError('SMTP Error MailTo: %s', smtp.EnhCodeString);
                    end;
                end else
                begin
                    raiseError('SMTP Error MailFrom: %s', smtp.EnhCodeString);
                end;

                SMTP.Logout();
            end else
            begin
                raiseError('SMTP Error Login: %s', smtp.EnhCodeString);
            end;
        finally
            SMTP.free();
        end;
    end;

    function TSynapseMailer.send() : boolean;
    var mailData : TStrings;
        mailFrom : string;
        mailTo : string;
    begin
        mailData := TStringList.create();
        try
            mailFrom := composeSender();
            mailTo := composeRecipient();
            mailData.add('From: ' + mailFrom);
            mailData.add('To: ' + mailTo);
            mailData.add('Date: ' + Rfc822DateTime(now));
            mailData.add('Subject: ' + subject);
            mailData.add('');
            mailData.text := mailData.text + body;
            result := sendRaw(fMailerConfig, mailFrom, mailTo, mailData);
        finally
            mailData.free();
        end;
    end;
end.
