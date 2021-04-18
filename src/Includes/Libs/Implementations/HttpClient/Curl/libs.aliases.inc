{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

{------------ Begin LibCurl-related------------------}
{$IFDEF LIBCURL}
THttpCurl = HttpCurlImpl.THttpCurl;
THttpCurlFactory = HttpCurlFactoryImpl.THttpCurlFactory;
THttpClientHeaders = HttpClientHeadersImpl.THttpClientHeaders;


THttpGet = HttpGetImpl.THttpGet;
THttpGetFactory = HttpGetFactoryImpl.THttpGetFactory;
THttpGetLogFactory = HttpGetLogFactoryImpl.THttpGetLogFactory;

THttpPost = HttpPostImpl.THttpPost;
THttpPostFactory = HttpPostFactoryImpl.THttpPostFactory;

THttpPut = HttpPutImpl.THttpPut;
THttpPutFactory = HttpPutFactoryImpl.THttpPutFactory;

THttpDelete = HttpDeleteImpl.THttpDelete;
THttpDeleteFactory = HttpDeleteFactoryImpl.THttpDeleteFactory;

THttpHead = HttpHeadImpl.THttpHead;
THttpHeadFactory = HttpHeadFactoryImpl.THttpHeadFactory;
{$ENDIF}
{------------ End LibCurl-related------------------}
