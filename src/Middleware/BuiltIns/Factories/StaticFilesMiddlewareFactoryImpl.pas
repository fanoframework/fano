{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticFilesMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    KeyValuePairIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TStaticFilesMiddleware
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticFilesMiddlewareFactory = class(TFactory, IDependencyFactory)
    private
        fBaseDirectory : string;
        fMimeTypes : IKeyValuePair;
    public
        constructor create();

        function baseDirectory(const baseDir : string) : TStaticFilesMiddlewareFactory;

        (*!---------------------------------------
         * associate file extension with Content-Type
         * (Mime type)
         *----------------------------------------
         * @param ext file extension
         * @param contentType mime type to associate
         * @return current instance
         *----------------------------------------*)
        function addMimeType(const ext : string; const contentType : string) : TStaticFilesMiddlewareFactory;

        (*!---------------------------------------
         * build middleware instance
         *----------------------------------------
         * @param container dependency container
         * @return instance of middleware
         *----------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    SysUtils,
    StaticFilesMiddlewareImpl,
    KeyValuePairImpl;

    constructor TStaticFilesMiddlewareFactory.create();
    begin
        fBaseDirectory := GetCurrentDir();
        fMimeTypes := TKeyValuePair.create();
    end;

    function TStaticFilesMiddlewareFactory.baseDirectory(const baseDir : string) : TStaticFilesMiddlewareFactory;
    begin
        fBaseDirectory := baseDir;
        result := self;
    end;

    function TStaticFilesMiddlewareFactory.addMimeType(const ext : string; const contentType : string) : TStaticFilesMiddlewareFactory;
    begin
        fMimeTypes.setValue(ext, contentType);
        result := self;
    end;

    function TStaticFilesMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TStaticFilesMiddleware.create(fBaseDirectory, fMimeTypes);
    end;

end.
