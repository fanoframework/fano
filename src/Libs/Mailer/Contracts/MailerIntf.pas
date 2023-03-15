{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MailerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * send email
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IMailer = interface
        ['{0C1A40B2-9FD3-470A-8BBD-241D5686DEB3}']

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

        function send() : boolean;
    end;

implementation
end.
