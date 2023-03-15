{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonRttiSerializeableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    SerializeableIntf;

type

    (*!------------------------------------------------
     * class that implements ISerializeable which wraps
     * TObject with RTTI information as ISerializeable interface
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TJsonRttiSerializeable = class(TInjectableObject, ISerializeable)
    private
        fData : TObject;
        fOwned : boolean;
    public

        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * object is TObject class or its descendant with {$M+}
         * in its declaration
         *-------------------------------------------------
         * @param data object with RTTI info instance
         * @param owned if true then we will free its memory
         *              false then caller must free it
         *--------------------------------------------------*)
        constructor create(const data : TObject; const owned : boolean = false);
        destructor destroy(); override;
        function serialize() : string;
    end;

implementation

uses

    fpjson,
    fpjsonrtti;

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * object is TObject class or its descendant with {$M+}
     * in its declaration
     *-------------------------------------------------
     * @param data object with RTTI info instance
     * @param owned if true then we will free its memory
     *              false then caller must free it
     *--------------------------------------------------*)
    constructor TJsonRttiSerializeable.create(
        const data : TObject;
        const owned : boolean = false
    );
    begin
        fData := data;
        fOwned := owned;
    end;

    destructor TJsonRttiSerializeable.destroy();
    begin
        if fOwned then
        begin
            fData.free();
        end;
        inherited destroy();
    end;

    function TJsonRttiSerializeable.serialize() : string;
    var
        streamer: TJSONStreamer;
    begin
        streamer := TJSONStreamer.create(nil);
        try
            // Save TStrings as JSON array
            streamer.Options := streamer.Options + [jsoTStringsAsArray];
            result := streamer.ObjectToJSONString(fData);
        finally
            streamer.free();
        end;
    end;
end.
