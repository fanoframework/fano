{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * list of auth units in security
 * that is included in implementations.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

CredentialTypes,

StaticCredentialsAuthImpl,
BasicAuthMiddlewareImpl,
StaticCredentialsBasicAuthMiddlewareFactoryImpl,

DigestStaticCredentialsAuthImpl,
DigestAuthMiddlewareImpl,
StaticCredentialsDigestAuthMiddlewareFactoryImpl,
