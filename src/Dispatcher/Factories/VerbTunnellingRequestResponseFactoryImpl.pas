{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerbTunnellingRequestResponseFactoryImpl;

interface

{$MODE OBJFPC}

uses

    RequestFactoryIntf,
    ResponseFactoryIntf,
    RequestResponseFactoryIntf,
    InjectableObjectImpl,
    DecoratorRequestResponseFactoryImpl;

type

    (*!---------------------------------------------------
     * class having capability return request and response
     * factory which support verb tunnelling
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    TVerbTunnellingRequestResponseFactory = class(TDecoratorRequestResponseFactory)
    public
        function getRequestFactory() : IRequestFactory; override;
    end;

implementation

uses

    VerbTunnellingRequestFactoryImpl;

    function TVerbTunnellingRequestResponseFactory.getRequestFactory() : IRequestFactory;
    begin
        result := TVerbTunnellingRequestFactory.create(
            inherited getRequestFactory()
        );
    end;

end.
