{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * unit interfaces that is included in fano.pas unit
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

OutputBufferIntf,
LoggerIntf,
FileReaderIntf,
StreamAdapterIntf,

StdInIntf,
StdOutIntf,
StdErrIntf,
StdInStreamAwareIntf,

HttpClientHandleAwareIntf,
HttpClientHeadersIntf,
HttpGetClientIntf,
HttpPostClientIntf,
HttpPutClientIntf,
HttpDeleteClientIntf,
HttpHeadClientIntf,

KeyValuePairIntf,

RunnableWithDataNotifIntf,

FcgiRecordIntf,
FcgiRecordFactoryIntf,
FcgiRequestIntf,
FcgiRequestManagerIntf,
FcgiFrameParserIntf,

ProtocolProcessorIntf,
ReadyListenerIntf,

RegexIntf,
AntivirusIntf,
ScanResultIntf,

RandomIntf,

CliParamsIntf,
CliParamsFactoryIntf,

EncrypterIntf,
DecrypterIntf,

{$INCLUDE Socket2/interfaces.inc}
{$INCLUDE Mailer/interfaces.inc}
