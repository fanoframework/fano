{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit MultiThreadDaemonAppImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf,
    CloseableIntf,
    DependencyContainerIntf,
    DispatcherIntf,
    EnvironmentIntf,
    ErrorHandlerIntf,
    OutputBufferIntf,
    DataAvailListenerIntf,
    RunnableWithDataNotifIntf,
    DaemonAppServiceProviderIntf,
    StdOutIntf,
    StdInIntf,
    RouteBuilderIntf,
    ProtocolProcessorIntf,
    ReadyListenerIntf,
    StreamAdapterIntf,
    StreamIdIntf,
    CoreAppConsts,
    CoreAppImpl;

type

    (*!-----------------------------------------------
     * Base web application that implements IWebApplication
     * which run as daemon and executes application code in
     * background thread
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMultiThreadDaemonWebApplication = class(TDaemonWebApplication)
    protected
        procedure setReadyListener(
            const protocol : IProtocolProcessor;
            const listener : IReadyListener
        ); override;
    public
    end;

implementation

uses

    MultiThreadReadyListenerImpl;

    procedure TMultiThreadDaemonWebApplication.setReadyListener(
        const protocol : IProtocolProcessor;
        const listener : IReadyListener
    );
    begin
        if (listener = nil) then
        begin
            //we are cleaning up, just call parent
            inherited setReadyListener(protocol, listener);
        end else
        begin
            //wrap actual listener with multi threads listener so that its
            //ready method will be called in new background thread
            inherited setReadyListener(
                protocol,
                TMultiThreadReadyListener.create(listener)
            );
        end;
    end;

end.
