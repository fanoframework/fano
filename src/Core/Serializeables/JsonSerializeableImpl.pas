{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonSerializeableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    SerializeableIntf,
    fpjson;

type

    (*!------------------------------------------------
     * class that implements ISerializeable which wraps
     * TJSONData as ISerializeable interface
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TJsonSerializeable = class(TInjectableObject, ISerializeable)
    private
        fData : TJSONData;
        fOwned : boolean;
    public

        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param data actual TJSONData instance
         * @param owned if true then we will free its memory
         *              false then caller must free it
         *--------------------------------------------------*)
        constructor create(const data : TJSONData; const owned : boolean = false);
        destructor destroy(); override;
        function serialize() : string;
    end;

implementation

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param data actual TJSONData instance
     * @param owned if true then we will free its memory
     *              false then caller must free it
     *--------------------------------------------------*)
    constructor TJsonSerializeable.create(
        const data : TJSONData;
        const owned : boolean = false
    );
    begin
        fData := data;
        fOwned := owned;
    end;

    destructor TJsonSerializeable.destroy();
    begin
        if fOwned then
        begin
            fData.free();
        end;
        inherited destroy();
    end;

    function TJsonSerializeable.serialize() : string;
    begin
        result := fData.asJSON;
    end;
end.
