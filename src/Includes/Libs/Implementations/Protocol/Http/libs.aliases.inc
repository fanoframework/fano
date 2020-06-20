{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

{------------ Begin libmicrohttpd-related------------------}
{$IFDEF LIBMICROHTTPD}
TMhdSvrConfig = MhdSvrConfigTypes.TMhdSvrConfig;
TMhdAppServiceProvider = MhdAppServiceProviderImpl.TMhdAppServiceProvider;
TMhdStdOutWriter = MhdStdOutWriterImpl.TMhdStdOutWriter;
TMhdProcessor = MhdProcessorImpl.TMhdProcessor;
{$ENDIF}
{------------ End libmicrohttpd-related------------------}
