{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterCollectionFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterCollectionIntf,
    StreamAdapterCollectionFactoryIntf;

type

    (*!------------------------------------------------
     * Create stream adapter collection for TMemoryStream
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStreamAdapterCollectionFactory = class(TInterfacedObject, IStreamAdapterCollectionFactory)
    public
        (*!------------------------------------------------
         * create stream instance
         *-----------------------------------------------
         * @return created stream
         *-----------------------------------------------*)
        function build() : IStreamAdapterCollection;
    end;

implementation

uses

    MemStreamAdapterFactoryImpl,
    StreamAdapterCollectionImpl;

    (*!------------------------------------------------
     * create stream instance
     *-----------------------------------------------
     * @return created stream
     *-----------------------------------------------*)
    function TStreamAdapterCollectionFactory.build() : IStreamAdapterCollection;
    begin
        result := TStreamAdapterCollection.create(
            TMemStreamAdapterFactory.create()
        );
    end;
end.
