{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ExceptionSerializeableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    sysutils,
    InjectableObjectImpl,
    SerializeableIntf;

type
    (*!------------------------------------------------
     * class that implements ISerializeable which wraps
     * Pascal Exception as ISerializeable interface
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TExceptionSerializeable = class(TInjectableObject, ISerializeable)
    private
        fActualExcept : Exception;
        function getStackTrace(const e : Exception) : string;
    public
        constructor create(const excpt : Exception);
        function serialize() : string;
    end;

implementation

    constructor TExceptionSerializeable.create(const excpt : Exception);
    begin
        fActualExcept := excpt;
    end;

    function TExceptionSerializeable.getStackTrace(const e : Exception) : string;
    var
        i: integer;
        frames: PPointer;
    begin
        result := '';
        if (e <> nil) then
        begin
            result := result +
                'Exception class : ' + e.className + LineEnding  +
                'Message : ' + e.message + LineEnding;
        end;

        result := result + 'Stacktrace:' + LineEnding +
            LineEnding + BackTraceStrFunc(ExceptAddr) + LineEnding;

        frames := ExceptFrames;
        for i := 0 to ExceptFrameCount - 1 do
        begin
            result := result + BackTraceStrFunc(frames[i]) + LineEnding;
        end;
    end;

    function TExceptionSerializeable.serialize() : string;
    begin
        result := getStackTrace(fActualExcept);
    end;
end.
