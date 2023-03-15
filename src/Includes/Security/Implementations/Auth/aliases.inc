{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for implementation in auth
 * that is included in implementations.aliases.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TCredential = CredentialTypes.TCredential;
TCredentials = CredentialTypes.TCredentials;

TAbstractPasswHashAuth = AbstractPasswHashAuthImpl.TAbstractPasswHashAuth;
TDbPasswHashAuth = DbPasswHashAuthImpl.TDbPasswHashAuth;
TStaticCredentialsAuth = StaticCredentialsAuthImpl.TStaticCredentialsAuth;
TStaticPasswHashAuth = StaticPasswHashAuthImpl.TStaticPasswHashAuth;

TBasicAuthMiddleware = BasicAuthMiddlewareImpl.TBasicAuthMiddleware;
TStaticCredentialsBasicAuthMiddlewareFactory = StaticCredentialsBasicAuthMiddlewareFactoryImpl.TStaticCredentialsBasicAuthMiddlewareFactory;

TDigestStaticCredentialsAuth = DigestStaticCredentialsAuthImpl.TDigestStaticCredentialsAuth;
TDigestAuthMiddleware = DigestAuthMiddlewareImpl.TDigestAuthMiddleware;
TStaticCredentialsDigestAuthMiddlewareFactory = StaticCredentialsDigestAuthMiddlewareFactoryImpl.TStaticCredentialsDigestAuthMiddlewareFactory;

TBearerAuthMiddleware = BearerAuthMiddlewareImpl.TBearerAuthMiddleware;
TBearerAuthMiddlewareFactory = BearerAuthMiddlewareFactoryImpl.TBearerAuthMiddlewareFactory;

TDbPasswHashAuthFactory = DbPasswHashAuthFactoryImpl.TDbPasswHashAuthFactory;
TStaticPasswHashAuthFactory = StaticPasswHashAuthFactoryImpl.TStaticPasswHashAuthFactory;
