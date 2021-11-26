{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionWriterFactoryIntf;

interface

{$MODE OBJFPC}

uses

    UploadedFileCollectionWriterIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability create
     * instance of IUploadedFileCollectionWriter
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUploadedFileCollectionWriterFactory = interface
        ['{0291F3C7-8C84-41C4-80C9-AEB3787C7F08}']

        function createCollectionWriter() : IUploadedFileCollectionWriter;
    end;

implementation

end.
