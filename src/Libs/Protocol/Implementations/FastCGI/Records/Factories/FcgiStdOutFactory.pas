{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiStdOutFactory;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    FcgiRecordFactory;

type

    (*!-----------------------------------------------
     * StdOut record factory (FCGI_STDOUT)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiStdOutFactory = class(TFcgiRecordFactory)
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

    FcgiStdOut;

    (*!------------------------------------------------
     * build fastcgi record from stream
     *-----------------------------------------------
     * @return instance IFcgiRecord of corresponding fastcgi record
     *-----------------------------------------------*)
    function TFcgiStdOutFactory.build() : IFcgiRecord;
    begin
        result := TFcgiStdOut.createFromStream(
            initStreamFromBuffer(fBuffer, fBufferSize),
            initEmptyStream()
        );
    end;
end.
