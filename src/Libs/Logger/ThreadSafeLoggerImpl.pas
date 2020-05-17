{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThreadSafeLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SyncObjs,
    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that makes other logger become
     * thread-safe
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TThreadSafeLogger = class(TAbstractLogger)
    private
        fActualLogger : ILogger;
        fLock : TCriticalSection;
    public
        constructor create(const logger : ILogger);
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

    constructor TThreadSafeLogger.create(const logger : ILogger);
    begin
        fLock := TCriticalSection.create();
        fActualLogger := logger;
    end;

    destructor TThreadSafeLogger.destroy();
    begin
        fActualLogger := nil;
        fLock.free();
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
    function TThreadSafeLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    begin
        fLock.acquire();
        try
            fActualLogger.log(level, msg, context);
            result := self;
        finally
            fLock.release();
        end;
    end;

end.
