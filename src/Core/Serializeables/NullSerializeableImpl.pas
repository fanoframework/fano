{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullSerializeableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    SerializeableIntf;

type
    (*!------------------------------------------------
     * class that implements ISerializeable which does nothing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TNullSerializeable = class(TInjectableObject, ISerializeable)
    public
        function serialize() : string;
    end;

implementation

    function TNullSerializeable.serialize() : string;
    begin
        //intentionally does nothing
        result := '';
    end;
end.
