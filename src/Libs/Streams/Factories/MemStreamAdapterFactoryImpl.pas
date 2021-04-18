{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MemStreamAdapterFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StreamAdapterFactoryIntf;

type

    (*!------------------------------------------------
     * Create stream adapter for TMemoryStream
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMemStreamAdapterFactory = class(TInterfacedObject, IStreamAdapterFactory)
    public
        (*!------------------------------------------------
         * create stream instance
         *-----------------------------------------------
         * @return created stream
         *-----------------------------------------------*)
        function build() : IStreamAdapter;
    end;

implementation

uses

    Classes,
    StreamAdapterImpl;

    (*!------------------------------------------------
     * create stream instance
     *-----------------------------------------------
     * @return created stream
     *-----------------------------------------------*)
    function TMemStreamAdapterFactory.build() : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TMemoryStream.create());
    end;
end.
