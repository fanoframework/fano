{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdErrLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that output to STDERR
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdErrLogger = class(TAbstractLogger)
    public
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

    SysUtils;

    (*!--------------------------------------
     * log message
     * --------------------------------------
     * @param level type of log
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TStdErrLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    begin
        writeln(
            StdErr,
            '[', level,'] ',
            FormatDateTime('yyyy-mm-dd hh:nn:ss', Now),
            ' ',
            msg
        );
        if (context <> nil) then
        begin
            writeln(StdErr, '==== Start context ====');
            writeln(StdErr, context.serialize());
            writeln(StdErr, '==== End context ====');
        end;
        result := self;
    end;

end.
