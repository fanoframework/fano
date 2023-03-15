{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionWriterFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    UploadedFileCollectionWriterIntf,
    UploadedFileCollectionWriterFactoryIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * factory class TUploadedFileCollection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFileCollectionWriterFactory = class(TFactory, IUploadedFileCollectionWriterFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
        function createCollectionWriter() : IUploadedFileCollectionWriter;
    end;

implementation

uses

    UploadedFileCollectionImpl,
    UploadedFileFactoryImpl,
    HashListImpl;

    function TUploadedFileCollectionWriterFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        result := createCollectionWriter() as IDependency;
    end;

    function TUploadedFileCollectionWriterFactory.createCollectionWriter() : IUploadedFileCollectionWriter;
    begin
        result := TUploadedFileCollection.create(
            THashList.create(),
            TUploadedFileFactory.create()
        );
    end;
end.
