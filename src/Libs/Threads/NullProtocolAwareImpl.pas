{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullProtocolAwareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ProtocolAwareIntf,
    ProtocolProcessorIntf;

type

    (*!-----------------------------------------------
     * null class aware of IProtocolProcessor
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullProtocolAware = class (TInterfacedObject, IProtocolAware)
    public

        (*!------------------------------------------------
         * set protocol processor
         *-----------------------------------------------
         * @param protocol protocol processor
         *-----------------------------------------------*)
        procedure setProtocol(const protocol : IProtocolProcessor);

    end;

implementation

    (*!------------------------------------------------
     * set protocol processor
     *-----------------------------------------------
     * @param protocol protocol processor
     *-----------------------------------------------*)
    procedure TNullProtocolAware.setProtocol(const protocol : IProtocolProcessor);
    begin
        //intentionally does nothing
    end;

end.
