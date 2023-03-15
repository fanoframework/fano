{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BackgroundThreadLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    SerializeableIntf,
    LoggerIntf,
    DecoratorLoggerImpl;

type

    (*!------------------------------------------------
     * thread implementation which call actual logger
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TLoggerThread = class(TThread)
    private
        fLogger : ILogger;
        fLevel : string;
        fMessage : string;
        fContext : ISerializeable;
    public
        constructor create(
            const logger : ILogger;
            const level : string;
            const msg : string;
            const context : ISerializeable
        );
        procedure execute(); override;
    end;

    (*!------------------------------------------------
     * logger class that execute log in background thread
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TBackgroundThreadLogger = class(TDecoratorLogger)
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

    constructor TLoggerThread.create(
        const logger : ILogger;
        const level : string;
        const msg : string;
        const context : ISerializeable
    );
    const SUSPENDED_THREAD = true;
    begin
        inherited create(SUSPENDED_THREAD);
        FreeOnTerminate := true;
        fLogger := logger;
        fLevel := level;
        fMessage := msg;
        fContext := context;
    end;

    procedure TLoggerThread.execute();
    begin
        //to simplify things we assumed fLogger
        //is thread-safe
        fLogger.log(fLevel, fMessage, fContext);
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
    function TBackgroundThreadLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    var loggerThread : TLoggerThread;
    begin
        loggerThread := TLoggerThread.create(fActualLogger, level, msg, context);
        loggerThread.start();
        result := self;
    end;

end.
