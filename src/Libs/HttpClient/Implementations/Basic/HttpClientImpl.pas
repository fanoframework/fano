{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    HttpGetClientIntf,
    HttpPostClientIntf,
    HttpPutClientIntf,
    HttpPatchClientIntf,
    HttpDeleteClientIntf,
    HttpHeadClientIntf,
    HttpOptionsClientIntf;

type

    (*!------------------------------------------------
     * basic HTTP client having capability to send
     * GET, POST, PUT, PATCH,  DELETE and HEAD, OPTIONS
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpClient = class(
        TInjectableObject,
        IHttpGetClient,
        IHttpPostClient,
        IHttpPutClient,
        IHttpPatchClient,
        IHttpDeleteClient,
        IHttpHeadClient,
        IHttpOptionsClient
    )
    private
        fGetClient : IHttpGetClient;
        fPostClient : IHttpPostClient;
        fPutClient : IHttpPutClient;
        fPatchClient : IHttpPatchClient;
        fDeleteClient : IHttpDeleteClient;
        fHeadClient : IHttpHeadClient;
        fOptionsClient : IHttpOptionsClient;
    public

        (*!------------------------------------------------
         * constructor
         *
         * @author Zamrony P. Juhara <zamronypj@yahoo.com>
         *-----------------------------------------------*)
        constructor create(
            getClient : IHttpGetClient;
            postClient : IHttpPostClient;
            putClient : IHttpPutClient;
            patchClient : IHttpPatchClient;
            deleteClient : IHttpDeleteClient;
            headClient : IHttpHeadClient;
            optsClient : IHttpOptionsClient
        );
        destructor destroy(); override;

        property httpGet : IHttpGetClient read fGetClient implements IHttpGetClient;
        property httpPost : IHttpPostClient read fPostClient implements IHttpPostClient;
        property httpPut : IHttpPutClient read fPutClient implements IHttpPutClient;
        property httpPatch : IHttpPatchClient read fPatchClient implements IHttpPatchClient;
        property httpDelete : IHttpDeleteClient read fDeleteClient implements IHttpDeleteClient;
        property httpHead : IHttpHeadClient read fHeadClient implements IHttpHeadClient;
        property httpOptions : IHttpOptionsClient read fOptionsClient implements IHttpOptionsClient;

    end;

implementation

    constructor THttpClient.create(
        getClient : IHttpGetClient;
        postClient : IHttpPostClient;
        putClient : IHttpPutClient;
        patchClient : IHttpPatchClient;
        deleteClient : IHttpDeleteClient;
        headClient : IHttpHeadClient;
        optsClient : IHttpOptionsClient
    );
    begin
        fGetClient := getClient;
        fPostClient := postClient;
        fPutClient := putClient;
        fPatchClient := patchClient;
        fDeleteClient := deleteClient;
        fHeadClient := headClient;
        fOptionsClient := optsClient;
    end;

    destructor THttpClient.destroy();
    begin
        fGetClient := nil;
        fPostClient := nil;
        fPutClient := nil;
        fPatchClient := nil;
        fDeleteClient := nil;
        fHeadClient := nil;
        fOptionsClient := nil;
        inherited destroy();
    end;

end.
