{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StrStreamAdapterFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StreamAdapterFactoryIntf;

type

    (*!------------------------------------------------
     * Create stream adapter for TStringStream
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStrStreamAdapterFactory = class(TInterfacedObject, IStreamAdapterFactory)
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
    function TStrStreamAdapterFactory.build() : IStreamAdapter;
    begin
        result := TStreamAdapter.create(TStringStream.create(''));
    end;
end.
