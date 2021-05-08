{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorStdInImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    StreamAdapterIntf,
    StdInIntf;

type

    (*!------------------------------------------------
     * decorator IStdIn implementation class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorStdIn = class(TInjectableObject, IStdIn)
    protected
        fActualStdIn : IStdIn;
    public
        constructor create(const actualStdIn : IStdIn);

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdIn; virtual;

        function readStdIn(const contentLength : int64) : string; virtual;
    end;

implementation

    constructor TDecoratorStdIn.create(const actualStdIn : IStdIn);
    begin
        fActualStdIn := actualStdIn;
    end;

    function TDecoratorStdIn.readStdIn(const contentLength : int64) : string;
    begin
        result := fActualStdIn.readStdIn(contentLength);
    end;

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TDecoratorStdIn.setStream(const astream : IStreamAdapter) : IStdIn;
    begin
        fActualStdIn.setStream(astream);
        result := self;
    end;
end.
