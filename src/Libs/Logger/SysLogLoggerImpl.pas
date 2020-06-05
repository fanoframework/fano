{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SysLogLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that output to system log (syslog)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSysLogLogger = class(TAbstractLogger)
    public
        constructor create(
            const prefix : string = '';
            const opt : integer = -1;
            const facility : integer = -1
        );
        destructor destroy(); override;

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

    SysUtils,
    SystemLog;

    function mapPriority(const level : string) : integer;
    begin
        result := LOG_EMERG;
        case (level) of
            'INFO' : result := LOG_INFO;
            'CRITICAL' : result := LOG_CRIT;
            'DEBUG' : result := LOG_DEBUG;
            'WARNING' : result := LOG_WARNING;
            'ERROR' : result := LOG_ERR;
            'EMERGENCY' : result := LOG_EMERG;
            'NOTICE' : result := LOG_NOTICE;
            'ALERT' : result := LOG_ALERT;
        end;
    end;

    constructor TSysLogLogger.create(
        const prefix : string = '';
        const opt : integer = -1;
        const facility : integer = -1
    );
    var ident : pchar;
        option : integer;
        fac : integer;
    begin
        ident := nil;
        if (prefix <> '') then
        begin
            ident := pchar(prefix);
        end;

        option := opt;
        if (option = -1) then
        begin
            option := LOG_NOWAIT or LOG_PID;
        end;

        fac := facility;
        if (fac = -1) then
        begin
            fac := LOG_USER;
        end;

        openlog(ident, option, fac);
    end;

    destructor TSysLogLogger.destroy();
    begin
        closelog();
        inherited destroy();
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
    function TSysLogLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    var logMsg : string;
    begin
        logMsg := '[' + level + '] ' + msg + LineEnding;
        if (context <> nil) then
        begin
            logMsg := logMsg + '==== Start context ====' + LineEnding +
                context.serialize() + LineEnding +
                '==== End context ====' + LineEnding;
        end;
        syslog(mapPriority(level), '%s', [ pchar(logMsg) ]);
        result := self;
    end;

end.
