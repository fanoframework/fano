{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SerializeableStreamImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    SerializeableIntf;

type

    (*!------------------------------------------------
     * adapter class that turn TStream into ISerializeable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSerializeableStream = class(TInterfacedObject, ISerializeable)
    private
        fActualStream : TStream;
        fOwned : boolean;
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param stream instance of actual TStream
         * @param owned true if stream instance memory
         *              should be freed when this class is freed
         *-------------------------------------*)
        constructor create(const stream : TStream; const owned : boolean = true);

        (*!------------------------------------
         * destructor
         *-------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * serialize stream content to string
         *-----------------------------------------------
         * @return stream content as string
         *-----------------------------------------------*)
        function serialize() : string;

    end;

implementation

uses

    SysUtils;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param stream instance of actual TStream
     * @param owned true if stream instance memory
     *              should be freed when this class is freed
     *-------------------------------------*)
    constructor TSerializeableStream.create(const stream : TStream; const owned : boolean = true);
    begin
        inherited create();
        fActualStream := stream;
        fOwned := owned;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TSerializeableStream.destroy();
    begin
        inherited destroy();
        if (fOwned) then
        begin
            fActualStream.free();
        end;
    end;

    (*!------------------------------------------------
     * serialize stream content to string
     *-----------------------------------------------
     * @return stream content as string
     *-----------------------------------------------*)
    function TSerializeableStream.serialize() : string;
    var strStream : TStringStream;
    begin
        strStream := TStringStream.create('');
        try
            fActualStream.seek(0, soFromBeginning);
            strStream.copyFrom(fActualStream, 0);
            result := strStream.dataString;
        finally
            strStream.free();
        end;
    end;

end.
