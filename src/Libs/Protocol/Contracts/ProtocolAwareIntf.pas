{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ProtocolAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ProtocolProcessorIntf;

type

    (*!-----------------------------------------------
     * Interface for any class aware of IProtocolProcessor
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IProtocolAware = interface
        ['{A7D14061-91A5-47C6-BA2F-AA105E36ED78}']

        (*!------------------------------------------------
         * set protocol processor
         *-----------------------------------------------
         * @param protocol protocol processor
         *-----------------------------------------------*)
        procedure setProtocol(const protocol : IProtocolProcessor);

    end;

implementation

end.
