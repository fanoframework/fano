{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit WithErrLogSvrImpl;

interface

{$MODE OBJFPC}
uses

     RunnableIntf,
     RunnableWithDataNotifIntf,
     DataAvailListenerIntf,
     LoggerIntf;

type

    (*!------------------------------------------------
     * IRunnable decorator implementation that handle
     * ESockStream exception and log exception
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TWithErrLogSvr = class (TInterfacedObject, IRunnable, IRunnableWithDataNotif)
    private
        fActualSvr : IRunnableWithDataNotif;
        fLogger : ILogger;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param actualSvr actual worker server
         * @param logger logger instance
         *-------------------------------------------------*)
        constructor create(
            const actualSvr : IRunnableWithDataNotif;
            const logger : ILogger
        );
        destructor destroy(); override;

        (*!------------------------------------------------
         * run it
         *-------------------------------------------------
         * @return current instance
         *-------------------------------------------------*)
        function run() : IRunnable;

        (*!------------------------------------------------
        * set instance of class that will be notified when
        * data is available
        *-----------------------------------------------
        * @param dataListener, class that wish to be notified
        * @return true current instance
        *-----------------------------------------------*)
        function setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    end;

implementation

uses

    ESockStreamImpl;

    constructor TWithErrLogSvr.create(
        const actualSvr : IRunnableWithDataNotif;
        const logger : ILogger
    );
    begin
        fActualSvr := actualSvr;
        fLogger := logger;
    end;

    destructor TWithErrLogSvr.destroy();
    begin
        fActualSvr := nil;
        fLogger := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * run it until terminate
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TWithErrLogSvr.run() : IRunnable;
    var terminated : boolean;
    begin
        terminated := false;
        repeat
            try
                fActualSvr.run();
                terminated := true;
            except
                on e : ESockStream do
                begin
                    terminated := false;
                    fLogger.critical('ESockStream exception :' + e.message);
                end;
            end;
        until terminated;
        result := self;
    end;

    (*!------------------------------------------------
     * set instance of class that will be notified when
     * data is available
     *-----------------------------------------------
     * @param dataListener, class that wish to be notified
     * @return true current instance
     *-----------------------------------------------*)
    function TWithErrLogSvr.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        fActualSvr.setDataAvailListener(dataListener);
        result := self;
    end;

end.
