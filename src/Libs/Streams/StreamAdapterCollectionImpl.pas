{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterCollectionImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fgl,
    StreamAdapterIntf,
    StreamAdapterFactoryIntf,
    StreamAdapterCollectionIntf,
    StreamAdapterAwareIntf;

type

    TStreamAdapterList = specialize TFPGInterfacedObjectList <IStreamAdapter>;

    (*!------------------------------------------------
     * Combine collection of IStreamAdapter instances as
     * a single IStreamAdapter
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStreamAdapterCollection = class(TInterfacedObject, IStreamAdapterCollection, IStreamAdapterAware)
    private
        fStreamFactory : IStreamAdapterFactory;
        streamCollection : TStreamAdapterList;
        procedure clearCollection(const coll : TStreamAdapterList);
    public
        (*!------------------------------------
         * constructor
         *-------------------------------------*)
        constructor create(const streamFactory : IStreamAdapterFactory);

        (*!------------------------------------
         * destructor
         *-------------------------------------*)
        destructor destroy(); override;


        (*!------------------------------------------------
         * get all stream as one big stream
         *-----------------------------------------------
         * @return combined stream
         *-----------------------------------------------*)
        function data() : IStreamAdapter;

        (*!------------------------------------------------
         * add stream
         *-----------------------------------------------
         * @return current stream collection
         *-----------------------------------------------*)
        function add(const stream : IStreamAdapter) : IStreamAdapterCollection;
    end;

implementation


    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor TStreamAdapterCollection.create(const streamFactory : IStreamAdapterFactory);
    begin
        fStreamFactory := streamFactory;
        streamCollection := TStreamAdapterList.create();
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TStreamAdapterCollection.destroy();
    begin
        inherited destroy();
        clearCollection(streamCollection);
        streamCollection.free();
        fStreamFactory := nil;
    end;

    (*!------------------------------------------------
     * clear stream collection
     *-----------------------------------------------*)
    procedure TStreamAdapterCollection.clearCollection(const coll : TStreamAdapterList);
    var i : integer;
    begin
        for i:= coll.count-1 downto 0 do
        begin
            coll.delete(i);
        end;
    end;

    (*!------------------------------------------------
     * get all stream as one big stream
     *-----------------------------------------------
     * @return combined stream
     *-----------------------------------------------*)
    function TStreamAdapterCollection.data() : IStreamAdapter;
    var i, len : integer;
        stream : IStreamAdapter;
    begin
        result := fStreamFactory.build();
        len := streamCollection.count;
        for i:= 0 to len-1 do
        begin
            stream := streamCollection[i];
            stream.seek(0);
            result.writeStream(stream, stream.size());
        end;
        result.seek(0);
    end;

    (*!------------------------------------------------
     * add stream
     *-----------------------------------------------
     * @return current stream collection
     *-----------------------------------------------*)
    function TStreamAdapterCollection.add(const stream : IStreamAdapter) : IStreamAdapterCollection;
    begin
        streamCollection.add(stream);
        result := self;
    end;
end.
