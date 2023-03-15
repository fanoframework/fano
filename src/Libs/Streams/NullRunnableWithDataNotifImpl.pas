{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullRunnableWithDataNotifImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf,
    RunnableWithDataNotifIntf,
    DataAvailListenerIntf;

type

    (*!-----------------------------------------------
     * null class having capability to be run
     * and notify when data is available
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullRunnableWithDataNotif = class(TInterfacedObject, IRunnable, IRunnableWithDataNotif)
    public

        (*!------------------------------------------------
        * set instance of class that will be notified when
        * data is available
        *-----------------------------------------------
        * @param dataListener, class that wish to be notified
        * @return true current instance
        *-----------------------------------------------*)
        function setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;

        (*!------------------------------------------------
         * run it
         *-------------------------------------------------
         * @return current instance
         *-------------------------------------------------*)
        function run() : IRunnable;
    end;

implementation

    (*!------------------------------------------------
     * set instance of class that will be notified when
     * data is available
     *-----------------------------------------------
     * @param dataListener, class that wish to be notified
     * @return true current instance
     *-----------------------------------------------*)
    function TNullRunnableWithDataNotif.setDataAvailListener(const dataListener : IDataAvailListener) : IRunnableWithDataNotif;
    begin
        //intentionally does nothing
        result := self
    end;

    (*!------------------------------------------------
     * run it
     *-------------------------------------------------
     * @return current instance
     *-------------------------------------------------*)
    function TNullRunnableWithDataNotif.run() : IRunnable;
    begin
        //intentionally does nothing
        result := self;
    end;
end.
