{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullCorsMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    BaseCorsMiddlewareFactoryImpl,
    DependencyContainerIntf,
    DependencyIntf;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * middleware that always allowed CORS
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullCorsMiddlewareFactory = class(TBaseCorsMiddlewareFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    CorsMiddlewareImpl,
    NullCorsImpl;

    function TNullCorsMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TCorsMiddleware.create(TNullCors.create());
    end;
end.
