{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DataAvailListenerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    CloseableIntf,
    StreamAdapterIntf,
    StreamIdIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * handle data availability
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IDataAvailListener = interface
        ['{C8C08F35-663E-49ED-93CA-32E8345187E4}']

        (*!------------------------------------------------
        * handle if data is available
        *-----------------------------------------------
        * @param stream, stream that store data
        * @param context, additional data related to stream
        * @param streamCloser, instance that can close stream if required
        * @return true if data is handled
        *-----------------------------------------------*)
        function handleData(
            const stream : IStreamAdapter;
            const context : TObject;
            const streamCloser : ICloseable;
            const streamId : IStreamId
        ) : boolean;

    end;

implementation

end.
