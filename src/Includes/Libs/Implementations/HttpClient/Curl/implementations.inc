{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

{------------ Begin LibCurl-related------------------}
{$IFDEF LIBCURL}
HttpCurlImpl,
HttpCurlFactoryImpl,

HttpClientHeadersImpl,

HttpGetImpl,
HttpGetFactoryImpl,

HttpGetLogFactoryImpl,

HttpPostImpl,
HttpPostFactoryImpl,

HttpPutImpl,
HttpPutFactoryImpl,

HttpDeleteImpl,
HttpDeleteFactoryImpl,

HttpHeadImpl,
HttpHeadFactoryImpl,

HttpClientImpl,
HttpClientFactoryImpl,
{$ENDIF}
{------------ End LibCurl-related------------------}
