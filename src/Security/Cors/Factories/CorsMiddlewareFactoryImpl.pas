{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CorsMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    BaseCorsMiddlewareFactoryImpl,
    DependencyContainerIntf,
    DependencyIntf,
    SysUtils;

type

    (*!------------------------------------------------
     * basic class having capability to create
     * middleware that handle CORS
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCorsMiddlewareFactory = class(TBaseCorsMiddlewareFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    CorsMiddlewareImpl,
    CorsImpl,
    CorsConfigImpl,
    RegexImpl;

    function TCorsMiddlewareFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TCorsMiddleware.create(
            TCors.create(
                TCorsConfig.create(
                    fAllowedOrigins,
                    fAllowedOriginsPatterns,
                    fAllowedMethods,
                    fAllowedHeaders,
                    fExposedHeaders,
                    fSupportsCredentials,
                    fMaxAge
                ),
                TRegex.create()
            )
        );
    end;
end.
