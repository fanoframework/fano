{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RunnableWithDataNotifIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf,
    DataAvailListenerIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to be run
     * and notify when data is available
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IRunnableWithDataNotif = interface(IRunnable)
        ['{4435EA47-B22E-43A2-90E7-A3FEEBDF5DE7}']

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

end.
