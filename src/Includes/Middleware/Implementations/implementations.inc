{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * implementation units for middleware
 * that is included in fano.pas unit
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)
MiddlewareExecutorImpl,

MiddlewareListImpl,
NullMiddlewareListImpl,

MiddlewareListFactoryImpl,
NullMiddlewareListFactoryImpl,

AbstractMiddlewareImpl,
NullMiddlewareImpl,
CompositeMiddlewareImpl,
RequestHandlerAsMiddlewareImpl,
JsonContentTypeMiddlewareImpl,
JsonContentTypeMiddlewareFactoryImpl,
CacheControlMiddlewareImpl,
CacheControlMiddlewareFactoryImpl,
NoCacheMiddlewareImpl,
NoCacheMiddlewareFactoryImpl,

StaticFilesMiddlewareImpl,
StaticFilesMiddlewareFactoryImpl,
CommonStaticFilesMiddlewareFactoryImpl,

MiddlewareTypes,
FuncMiddlewareImpl,
MethodMiddlewareImpl,

MaintenanceModeMiddlewareImpl,