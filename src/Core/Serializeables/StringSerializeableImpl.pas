{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StringSerializeableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    SerializeableIntf;

type
    (*!------------------------------------------------
     * class that implements ISerializeable which wraps
     * Pascal string as ISerializeable interface
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TStringSerializeable = class(TInjectableObject, ISerializeable)
    private
        actualString : string;
    public
        constructor create(const str : string);
        function serialize() : string;
    end;

implementation

    constructor TStringSerializeable.create(const str : string);
    begin
        actualString := str;
    end;

    function TStringSerializeable.serialize() : string;
    begin
        result := actualString;
    end;
end.
