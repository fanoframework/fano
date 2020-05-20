{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ExceptionSerializeableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    InjectableObjectImpl,
    SerializeableIntf;

type
    (*!------------------------------------------------
     * adapter class that implements ISerializeable which wraps
     * Exception
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TExceptionSerializeable = class(TInjectableObject, ISerializeable)
    private
        fExcept : Exception;
    public
        constructor create(const aExcept : Exception);
        function serialize() : string;
    end;

implementation

    constructor TExceptionSerializeable.create(const aExcept : Exception);
    begin
        fExcept := aExcept;
    end;

    function TExceptionSerializeable.serialize() : string;
    begin
        result := fExcept.ToString;
    end;
end.
