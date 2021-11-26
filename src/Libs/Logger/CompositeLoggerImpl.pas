{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CompositeLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    TLoggerArray = array of ILogger;

    (*!------------------------------------------------
     * logger class that is composed from several loggers
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCompositeLogger = class(TAbstractLogger)
    private
        fLoggers : TLoggerArray;
        procedure freeLoggers(var loggers : TLoggerArray);
        function initLoggers(const loggers : array of ILogger) : TLoggerArray;
    public

        (*!--------------------------------------
         * constructor
         * --------------------------------------
         * @param loggers array of loggers
         *---------------------------------------*)
        constructor create(const loggers : array of ILogger);

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
     * @param loggers array of loggers
     *---------------------------------------*)
    constructor TCompositeLogger.create(const loggers : array of ILogger);
    begin
        fLoggers := initLoggers(loggers);
    end;

    (*!--------------------------------------
     * destructor
     *---------------------------------------*)
    destructor TCompositeLogger.destroy();
    begin
        freeLoggers(fLoggers);
        inherited destroy();
    end;

    function TCompositeLogger.initLoggers(const loggers : array of ILogger) : TLoggerArray;
    var i, totLoggers : integer;
    begin
        result := default(TLoggerArray);
        totLoggers := high(loggers) - low(loggers) + 1;
        setLength(result, totLoggers);
        for i := 0 to totLoggers - 1 do
        begin
            result[i] := loggers[i];
        end;
    end;

    procedure TCompositeLogger.freeLoggers(var loggers : TLoggerArray);
    var i, totLoggers : integer;
    begin
        totLoggers := length(loggers);
        for i := 0 to totLoggers - 1 do
        begin
            loggers[i] := nil;
        end;
        setLength(loggers, 0);
        loggers := nil;
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
    function TCompositeLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    var i, totLoggers : integer;
    begin
        totLoggers := length(fLoggers);
        for i:= 0 to totLoggers - 1 do
        begin
            fLoggers[i].log(level, msg, context);
        end;
        result := self;
    end;

end.
