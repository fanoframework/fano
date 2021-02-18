{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiGetValuesFactory;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    FcgiRecordFactory;

type

    (*!-----------------------------------------------
     * Get Values record factory (FCGI_GET_VALUES)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiGetValuesFactory = class(TFcgiRecordFactory)
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

    FcgiGetValues;

    (*!------------------------------------------------
     * build fastcgi record from stream
     *-----------------------------------------------
     * @return instance IFcgiRecord of corresponding fastcgi record
     *-----------------------------------------------*)
    function TFcgiGetValuesFactory.build() : IFcgiRecord;
    begin
        result := TFcgiGetValues.createFromStream(
            initStreamFromBuffer(fBuffer, fBufferSize),
            initEmptyStream()
        );
    end;
end.
