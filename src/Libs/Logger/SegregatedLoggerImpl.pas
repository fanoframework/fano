{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SegregatedLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that segregates each level
     * to dedicated logger. So we can separate,
     * for example, to log INFO type log to separate
     * file than CRITICAL type, or suppress DEBUG level type, etc
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSegregatedLogger = class(TAbstractLogger)
    private
        emergencyLogger : ILogger;
        alertLogger : ILogger;
        criticalLogger : ILogger;
        errorLogger : ILogger;
        warningLogger : ILogger;
        noticeLogger : ILogger;
        infoLogger : ILogger;
        debugLogger : ILogger;
    public

        (*!--------------------------------------
         * constructor
         * --------------------------------------
         * @param emergencyLoggerInst logger for emergency log
         * @param alertLoggerInst logger for alert log
         * @param criticalLoggerInst logger for critical log
         * @param errorLoggerInst logger for error log
         * @param warningLoggerInst logger for warning log
         * @param noticeLoggerInst logger for notice log
         * @param infoLoggerInst logger for info log
         * @param debugLoggerInst logger for debug log
         *---------------------------------------*)
        constructor create(
            const emergencyLoggerInst : ILogger;
            const alertLoggerInst : ILogger;
            const criticalLoggerInst : ILogger;
            const errorLoggerInst : ILogger;
            const warningLoggerInst : ILogger;
            const noticeLoggerInst : ILogger;
            const infoLoggerInst : ILogger;
            const debugLoggerInst : ILogger
        );

        (*!--------------------------------------
         * destructor
         *---------------------------------------*)
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

    (*!--------------------------------------
     * constructor
     * --------------------------------------
     * @param infoLoggerInst logger for info log
     * @param debugLoggerInst logger for debug log
     * @param warningLoggerInst logger for warning log
     * @param criticalLoggerInst logger for critical log
     *---------------------------------------*)
    constructor TSegregatedLogger.create(
        const emergencyLoggerInst : ILogger;
        const alertLoggerInst : ILogger;
        const criticalLoggerInst : ILogger;
        const errorLoggerInst : ILogger;
        const warningLoggerInst : ILogger;
        const noticeLoggerInst : ILogger;
        const infoLoggerInst : ILogger;
        const debugLoggerInst : ILogger
    );
    begin
        emergencyLogger := emergencyLoggerInst;
        alertLogger := alertLoggerInst;
        criticalLogger := criticalLoggerInst;
        errorLogger := errorLoggerInst;
        warningLogger := warningLoggerInst;
        noticeLogger := noticeLoggerInst;
        infoLogger := infoLoggerInst;
        debugLogger := debugLoggerInst;
    end;

    (*!--------------------------------------
     * destructor
     *---------------------------------------*)
    destructor TSegregatedLogger.destroy();
    begin
        emergencyLogger := nil;
        alertLogger := nil;
        criticalLogger := nil;
        errorLogger := nil;
        warningLogger := nil;
        noticeLogger := nil;
        infoLogger := nil;
        debugLogger := nil;
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
    function TSegregatedLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    begin
        case level of
            'EMERGENCY' : emergencyLogger.log(level, msg, context);
            'ALERT' : alertLogger.log(level, msg, context);
            'CRITICAL' : criticalLogger.log(level, msg, context);
            'ERROR' : errorLogger.log(level, msg, context);
            'WARNING' : warningLogger.log(level, msg, context);
            'NOTICE' : noticeLogger.log(level, msg, context);
            'INFO' : infoLogger.log(level, msg, context);
            'DEBUG' : debugLogger.log(level, msg, context);
        end;

        result := self;
    end;

end.
