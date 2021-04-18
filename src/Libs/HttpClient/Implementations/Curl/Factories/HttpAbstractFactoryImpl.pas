{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpAbstractFactoryImpl;

interface

{$MODE OBJFPC}

uses

    HttpClientHandleAwareIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * Base factory class for http client factory
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THttpAbstractFactory = class(TFactory)
    protected
        handle : IHttpClientHandleAware;
    public
        constructor create(const handleInst : IHttpClientHandleAware);
        destructor destroy(); override;
    end;

implementation

    constructor THttpAbstractFactory.create(const handleInst : IHttpClientHandleAware);
    begin
        handle := handleInst;
    end;

    destructor THttpAbstractFactory.destroy();
    begin
        inherited destroy();
        handle := nil;
    end;

end.
