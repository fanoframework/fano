{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullRunnableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf;

type

    (*!------------------------------------------------
     * null IRunnable implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullRunnable = class(TInterfacedObject, IRunnable)
    public
        function run() : IRunnable;
    end;


implementation

    function TNullRunnable.run() : IRunnable;
    begin
        //intentionally does nothing
        result := self;
    end;


end.
