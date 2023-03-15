{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientOptsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    libcurl,
    HttpClientOptsIntf,
    HttpClientHandleAwareIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * class that set/get Curl HTTP options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpClientOpts = class(TInjectableObject, IHttpClientOpts)
    private
        (*!------------------------------------------------
        * internal variable that holds curl handle
        *-----------------------------------------------*)
        hCurl : PCurl;
    public
        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param curlHandle instance class that can get handle
         *-----------------------------------------------*)
        constructor create(const curlHandle : IHttpClientHandleAware);

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * set HTTP client options
         *-----------------------------------------------
         * @param optName option to set
         * @param optValue option value
         * @return current instance
         *-----------------------------------------------*)
        function setOpt(
            const optName : string;
            const optValue : integer
        ) : IHttpClientOpts;

        (*!------------------------------------------------
         * get HTTP client options
         *-----------------------------------------------
         * @param optName option to get
         * @return option value
         *-----------------------------------------------*)
        function getOpt(const opt : string): integer;
    end;

implementation

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------*)
    constructor THttpClientOpts.create(const curlHandle : IHttpClientHandleAware);
    begin
        hCurl := curlHandle.handle();
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor THttpClientOpts.destroy();
    begin
        inherited destroy();
        hCurl := nil;
    end;

    (*!------------------------------------------------
     * set HTTP client options
     *-----------------------------------------------
     * @param optName option to set
     * @param optValue option value
     * @return current instance
     *-----------------------------------------------*)
    function THttpClientOpts.setOpt(
        const optName : string;
        const optValue : integer
    ) : IHttpClientOpts;
    begin
        result := self;
    end;

    (*!------------------------------------------------
     * get HTTP client options
     *-----------------------------------------------
     * @param optName option to get
     * @return option value
     *-----------------------------------------------*)
    function THttpClientOpts.getOpt(const opt : string): integer;
    begin
        result := 0;
    end;

end.
