{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullStdInImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StdInIntf,
    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * null implementation of IStdIn
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullStdIn = class (TInterfacedObject, IStdIn)
    public
        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdIn;

        function readStdIn(const contentLength : int64) : string;
    end;

implementation

    (*!------------------------------------------------
     * set stream to write to if any
     *-----------------------------------------------
     * @param stream, stream to write to
     * @return current instance
     *-----------------------------------------------*)
    function TNullStdIn.setStream(const astream : IStreamAdapter) : IStdIn;
    begin
        //intentionally does nothing
        result := self;
    end;

    function TNullStdIn.readStdIn(const contentLength : int64) : string;
    begin
        //intentionally does nothing
        result := '';
    end;

end.
