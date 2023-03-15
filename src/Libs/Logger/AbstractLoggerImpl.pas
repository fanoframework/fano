{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * base for any class having capability to log
     * message
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractLogger = class(TInjectableObject, ILogger)
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
        ) : ILogger; virtual; abstract;

        (*!--------------------------------------
         * log critical message
         * --------------------------------------
         * @param msg log message
         * @param context data related to log message
         *               (if any)
         * @return current instance
         *---------------------------------------*)
        function critical(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!--------------------------------------
         * log debug message
         * --------------------------------------
         * @param msg log message
         * @param context data related to log message
         *               (if any)
         * @return current instance
         *---------------------------------------*)
        function debug(const msg : string; const context : ISerializeable  = nil) : ILogger;

        (*!--------------------------------------
         * log info message
         * --------------------------------------
         * @param msg log message
         * @param context data related to log message
         *               (if any)
         * @return current instance
         *---------------------------------------*)
        function info(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!--------------------------------------
         * log warning message
         * --------------------------------------
         * @param msg log message
         * @param context data related to log message
         *               (if any)
         * @return current instance
         *---------------------------------------*)
        function warning(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!------------------------------------------------
         * log notice level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function notice(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!------------------------------------------------
         * log error level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function error(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!------------------------------------------------
         * log alert level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function alert(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!------------------------------------------------
         * log emergency level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function emergency(const msg : string; const context : ISerializeable = nil) : ILogger;
    end;

implementation

    (*!--------------------------------------
     * log critical message
     * --------------------------------------
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TAbstractLogger.critical(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('CRITICAL', msg, context);
    end;

    (*!--------------------------------------
     * log debug message
     * --------------------------------------
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TAbstractLogger.debug(const msg : string; const context : ISerializeable  = nil) : ILogger;
    begin
        result := log('DEBUG', msg, context);
    end;

    (*!--------------------------------------
     * log info message
     * --------------------------------------
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TAbstractLogger.info(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('INFO', msg, context);
    end;

    (*!--------------------------------------
     * log warning message
     * --------------------------------------
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TAbstractLogger.warning(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('WARNING', msg, context);
    end;

    (*!------------------------------------------------
     * log notice level message
     *-----------------------------------------------
     * @param msg actual message to log
     * @param context object instance related to this message
     * @return current logger instance
     *-----------------------------------------------*)
    function TAbstractLogger.notice(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('NOTICE', msg, context);
    end;

    (*!------------------------------------------------
     * log error level message
     *-----------------------------------------------
     * @param msg actual message to log
     * @param context object instance related to this message
     * @return current logger instance
     *-----------------------------------------------*)
    function TAbstractLogger.error(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('ERROR', msg, context);
    end;

    (*!------------------------------------------------
     * log alert level message
     *-----------------------------------------------
     * @param msg actual message to log
     * @param context object instance related to this message
     * @return current logger instance
     *-----------------------------------------------*)
    function TAbstractLogger.alert(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('ALERT', msg, context);
    end;

    (*!------------------------------------------------
     * log emergency level message
     *-----------------------------------------------
     * @param msg actual message to log
     * @param context object instance related to this message
     * @return current logger instance
     *-----------------------------------------------*)
    function TAbstractLogger.emergency(const msg : string; const context : ISerializeable = nil) : ILogger;
    begin
        result := log('EMERGENCY', msg, context);
    end;
end.
