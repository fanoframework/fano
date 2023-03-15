{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractMailerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    InjectableObjectImpl,
    MailerIntf;

type

    (*!------------------------------------------------
     * abstract class having capability to
     * send email
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractMailer = class abstract (TInjectableObject, IMailer)
    private
        fSenderEmail : string;
        fSenderName : string;
        fRecipientEmail : string;
        fRecipientName : string;
        fSubject : string;
        fMessage : string;
        fAttachment : TStream;
        fHeader : string;
    protected
        function composeSender() : string;
        function composeRecipient() : string;
    public
        function getRecipient() : string;
        procedure setRecipient(const aTo : string);
        property recipient : string read getRecipient write setRecipient;

        function getRecipientName() : string;
        procedure setRecipientName(const aRecipientName : string);
        property recipientName : string read getRecipientName write setRecipientName;

        function getSender() : string;
        procedure setSender(const aFrom : string);
        property sender : string read getSender write setSender;

        function getSenderName() : string;
        procedure setSenderName(const aSenderName : string);
        property senderName : string read getSenderName write setSenderName;

        function getSubject() : string;
        procedure setSubject(const aSubject : string);
        property subject : string read getSubject write setSubject;

        function getBody() : string;
        procedure setBody(const aMessage : string);
        property body : string read getBody write setBody;

        function getAttachment() : TStream;
        procedure setAttachment(const aAttachment : TStream);
        property attachment : TStream read getAttachment write setAttachment;

        function getHeader() : string;
        procedure setHeader(const aHeader : string);
        property header : string read getHeader write setHeader;

        function send() : boolean; virtual; abstract;
    end;

implementation

uses

    EMailerImpl;

resourcestring

    sErrEmptyRecipient = 'Empty mail recipient';

    function TAbstractMailer.getRecipient() : string;
    begin
        result := fRecipientEmail;
    end;

    procedure TAbstractMailer.setRecipient(const aTo : string);
    begin
        if aTo = '' then
        begin
            raise EMailer.create(sErrEmptyRecipient);
        end;

        fRecipientEmail := aTo;
    end;

    function TAbstractMailer.getRecipientName() : string;
    begin
        result := fRecipientName;
    end;

    procedure TAbstractMailer.setRecipientName(const aRecipientName : string);
    begin
        fRecipientName := aRecipientName;
    end;

    function TAbstractMailer.getSender() : string;
    begin
        result := fSenderEmail;
    end;

    procedure TAbstractMailer.setSender(const aFrom : string);
    begin
        fSenderEmail := aFrom;
    end;

    function TAbstractMailer.getSenderName() : string;
    begin
        result := fSenderName;
    end;

    procedure TAbstractMailer.setSenderName(const aSenderName : string);
    begin
        fSenderName := aSenderName;
    end;

    function TAbstractMailer.composeSender() : string;
    begin
        if fSenderName = '' then
        begin
            result := fSenderEmail;
        end else
        begin
            result := fSenderName + ' <' + fSenderEmail + '>';
        end;
    end;

    function TAbstractMailer.composeRecipient() : string;
    begin
        if fRecipientName = '' then
        begin
            result := fRecipientEmail;
        end else
        begin
            result := fRecipientName + ' <' + fRecipientEmail + '>';
        end;
    end;

    function TAbstractMailer.getSubject() : string;
    begin
        result := fSubject;
    end;

    procedure TAbstractMailer.setSubject(const aSubject : string);
    begin
        fSubject := aSubject;
    end;

    function TAbstractMailer.getBody() : string;
    begin
        result := fMessage;
    end;

    procedure TAbstractMailer.setBody(const aMessage : string);
    begin
        fMessage := aMessage;
    end;

    function TAbstractMailer.getAttachment() : TStream;
    begin
        result := fAttachment;
    end;

    procedure TAbstractMailer.setAttachment(const aAttachment : TStream);
    begin
        fAttachment := aAttachment;
    end;

    function TAbstractMailer.getHeader() : string;
    begin
        result := fHeader;
    end;

    procedure TAbstractMailer.setHeader(const aHeader : string);
    begin
        fHeader := aHeader;
    end;

end.
