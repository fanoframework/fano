{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MailLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    MailerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that log to email
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMailLogger = class(TAbstractLogger)
    protected
        fMailer : IMailer;
        fTo : string;
        fFrom : string;
        fPrefix : string;

        function buildSubject(
            const level : string;
            const msg : string;
            const context : ISerializeable
        ) : string; virtual;

        function buildMessage(
            const level : string;
            const msg : string;
            const context : ISerializeable
        ) : string; virtual;
    public
        constructor create(
            const mailer : IMailer;
            const mailTo : string;
            const mailFrom : string;
            const prefix : string = ''
        );

        (*!--------------------------------------
         * log message
         * --------------------------------------
         * @param level type of log
         * @param msg log message
         * @param context data related to log message
         *               (if any)
         * @return current instance
         *---------------------------------------*)
        function log(
            const level : string;
            const msg : string;
            const context : ISerializeable = nil
        ) : ILogger; override;
    end;

implementation

uses

    sysutils;

    constructor TMailLogger.create(
        const mailer : IMailer;
        const mailTo : string;
        const mailFrom : string;
        const prefix : string = ''
    );
    begin
        fMailer := mailer;
        fTo := mailTo;
        fFrom := mailFrom;
        fPrefix := prefix;
    end;

    function TMailLogger.buildSubject(
        const level : string;
        const msg : string;
        const context : ISerializeable
    ) : string;
    begin
        if fPrefix = '' then
        begin
            result := '[' + level + '] ';
        end else
        begin
            result := fPrefix + ' [' + level + '] ';
        end;
    end;

    function TMailLogger.buildMessage(
        const level : string;
        const msg : string;
        const context : ISerializeable
    ) : string;
    begin
        result := '[' + level + '] ' +
            FormatDateTime('yyyy-mm-dd hh:nn:ss', Now) +
            ' ' +
            msg + LineEnding;

        if (context <> nil) then
        begin
            result := result + LineEnding +
                '==== Start context ====' + LineEnding +
                context.serialize() +
                '==== End context ====';
        end;
    end;

    (*!--------------------------------------
     * log message
     * --------------------------------------
     * @param level type of log
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TMailLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    begin
        fMailer.recipient := fTo;
        fMailer.sender := fFrom;
        fMailer.subject := buildSubject(level, msg, context);
        fMailer.body := buildMessage(level, msg, context);
        fMailer.send();
        result := self;
    end;

end.
