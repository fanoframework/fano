{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    UploadedFileCollectionIntf,
    UploadedFileCollectionFactoryIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * factory class TUploadedFileCollection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TUploadedFileCollectionFactory = class(TFactory, IUploadedFileCollectionFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
        function createCollection() : IUploadedFileCollection;
    end;

implementation

uses

    UploadedFileCollectionImpl,
    UploadedFileFactoryImpl,
    HashListImpl;

    function TUploadedFileCollectionFactory.build(
        const container : IDependencyContainer
    ) : IDependency;
    begin
        result := createCollection() as IDependency;
    end;

    function TUploadedFileCollectionFactory.createCollection() : IUploadedFileCollection;
    begin
        result := TUploadedFileCollection.create(
            THashList.create(),
            TUploadedFileFactory.create()
        );
    end;
end.
