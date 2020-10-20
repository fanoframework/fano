{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SocketSvrFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableWithDataNotifIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability setup
     * create socket server
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISocketSvrFactory = interface
        ['{E32719D0-ADC3-467F-955A-80178924C8B8}']

        function build() : IRunnableWithDataNotif;
    end;

implementation

end.
