{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * THttpClient factory class
     *------------------------------------------------
     * This class can serve as factory class for THttpClient
     * and also can be injected into dependency container
     * directly to build THttpClient class
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpClientFactory = class(TFactory)
    private
        fGetClientFactory : IDependencyFactory;
        fPostClientFactory : IDependencyFactory;
        fPutClientFactory : IDependencyFactory;
        fPatchClientFactory : IDependencyFactory;
        fDeleteClientFactory : IDependencyFactory;
        fHeadClientFactory : IDependencyFactory;
        fOptionsClientFactory : IDependencyFactory;
    public
        constructor create(
            getClientFactory : IDependencyFactory;
            postClientFactory : IDependencyFactory;
            putClientFactory : IDependencyFactory;
            patchClientFactory : IDependencyFactory;
            deleteClientFactory : IDependencyFactory;
            headClientFactory : IDependencyFactory;
            optionsClientFactory : IDependencyFactory
        );

        destructor destroy(); override;

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *----------------------------------------------------
         * This is implementation of IDependencyFactory
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    HttpGetClientIntf,
    HttpPostClientIntf,
    HttpPutClientIntf,
    HttpPatchClientIntf,
    HttpDeleteClientIntf,
    HttpHeadClientIntf,
    HttpOptionsClientIntf,

    HttpClientImpl;

    constructor THttpClientFactory.create(
        getClientFactory : IDependencyFactory;
        postClientFactory : IDependencyFactory;
        putClientFactory : IDependencyFactory;
        patchClientFactory : IDependencyFactory;
        deleteClientFactory : IDependencyFactory;
        headClientFactory : IDependencyFactory;
        optionsClientFactory : IDependencyFactory
    );
    begin
        fGetClientFactory := getClientFactory;
        fPostClientFactory := postClientFactory;
        fPutClientFactory := putClientFactory;
        fPatchClientFactory := patchClientFactory;
        fDeleteClientFactory := deleteClientFactory;
        fHeadClientFactory := headClientFactory;
        fOptionsClientFactory := optionsClientFactory;
    end;

    destructor THttpClientFactory.destroy();
    begin
        inherited destroy();
        fGetClientFactory := nil;
        fPostClientFactory := nil;
        fPutClientFactory := nil;
        fPatchClientFactory := nil;
        fDeleteClientFactory := nil;
        fHeadClientFactory := nil;
        fOptionsClientFactory := nil;
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function THttpClientFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := THttpClient.create(
            fGetClientFactory.build(container) as IHttpGetClient,
            fPostClientFactory.build(container) as IHttpPostClient,
            fPutClientFactory.build(container) as IHttpPutClient,
            fPatchClientFactory.build(container) as IHttpPatchClient,
            fDeleteClientFactory.build(container) as IHttpDeleteClient,
            fHeadClientFactory.build(container) as IHttpHeadClient,
            fOptionsClientFactory.build(container) as IHttpOptionsClient
        );
    end;
end.
