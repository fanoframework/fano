{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiParamsFactory;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    FcgiRecordFactory;

type

    (*!-----------------------------------------------
     * Params Request record factory (FCGI_PARAMS)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiParamsFactory = class(TFcgiRecordFactory)
    public
        (*!------------------------------------------------
         * build fastcgi record from stream
         *-----------------------------------------------
         * @return instance IFcgiRecord of corresponding fastcgi record
         *-----------------------------------------------*)
        function build() : IFcgiRecord; override;
    end;

implementation

uses

    KeyValuePairImpl,
    FcgiParams;

    (*!------------------------------------------------
     * build fastcgi record from stream
     *-----------------------------------------------
     * @return instance IFcgiRecord of corresponding fastcgi record
     *-----------------------------------------------*)
    function TFcgiParamsFactory.build() : IFcgiRecord;
    begin
        result := TFcgiParams.createFromStream(
            initStreamFromBuffer(fBuffer, fBufferSize),
            initEmptyStream(),
            TKeyValuePair.create()
        );
    end;
end.
