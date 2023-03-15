{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DaemonAppServiceProviderIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    AppServiceProviderIntf,
    RunnableWithDataNotifIntf,
    ProtocolProcessorIntf,
    OutputBufferIntf,
    StdOutIntf;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories for daemon app
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    IDaemonAppServiceProvider = interface(IAppServiceProvider)
        ['{4FF6129E-171F-429C-BE5B-7A8B941D3626}']

        function getServer() : IRunnableWithDataNotif;
        property server : IRunnableWithDataNotif read getServer;

        function getProtocol() : IProtocolProcessor;
        property protocol : IProtocolProcessor read getProtocol;

        function getOutputBuffer() : IOutputBuffer;
        property outputBuffer : IOutputBuffer read getOutputBuffer;

        function getStdOut() : IStdOut;
        property stdOut : IStdOut read getStdOut;

    end;

implementation

end.
