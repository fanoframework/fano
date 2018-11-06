{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/zamronypj/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/zamronypj/fano/blob/master/LICENSE (GPL 3.0)
 *}

unit LoggerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to log
     * message
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ILogger = interface
        ['{A2334E59-76CC-4FCC-83BC-B694963D4B1A}']

        (*!------------------------------------------------
         * log arbitrary level message
         *-----------------------------------------------
         * @param level level type of log
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function log(
            const level : string;
            const msg : string;
            const context : ISerializeable = nil
        ) : ILogger;

        (*!------------------------------------------------
         * log critical level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function critical(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!------------------------------------------------
         * log debug level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function debug(const msg : string; const context : ISerializeable  = nil) : ILogger;

        (*!------------------------------------------------
         * log info level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function info(const msg : string; const context : ISerializeable = nil) : ILogger;

        (*!------------------------------------------------
         * log warning level message
         *-----------------------------------------------
         * @param msg actual message to log
         * @param context object instance related to this message
         * @return current logger instance
         *-----------------------------------------------*)
        function warning(const msg : string; const context : ISerializeable = nil) : ILogger;
    end;

implementation

end.
