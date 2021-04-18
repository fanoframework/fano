{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiEnvironmentFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    StreamAdapterIntf,
    EnvironmentIntf,
    EnvironmentFactoryIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * factory class to create class having capability
     * to retrieve FastCGI environment variable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TFCGIEnvironmentFactory = class(TFactory, IDependencyFactory, ICGIEnvironmentFactory)
    private
        fParamStream : IStreamAdapter;
    public
        constructor create(const paramStream : IStreamAdapter);
        destructor destroy(); override;
        function build(const container : IDependencyContainer) : IDependency; override;
        function build() : ICGIEnvironment;
    end;

implementation

uses

    classes,
    FcgiParamKeyValuePairImpl,
    KeyValueEnvironmentImpl;

    constructor TFCGIEnvironmentFactory.create(const paramStream : IStreamAdapter);
    begin
        fParamStream := paramStream;
    end;

    destructor TFCGIEnvironmentFactory.destroy();
    begin
        fParamStream := nil;
        inherited destroy();
    end;

    function TFCGIEnvironmentFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := build() as IDependency;
    end;

    function TFCGIEnvironmentFactory.build() : ICGIEnvironment;
    begin
        result := TKeyValueEnvironment.create(
            TFcgiParamKeyValuePair.create(fParamStream)
        );
    end;

end.
