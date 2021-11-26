{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

IOutputBuffer = OutputBufferIntf.IOutputBuffer;
ILogger = LoggerIntf.ILogger;
IFileReader = FileReaderIntf.IFileReader;
IStreamAdapter = StreamAdapterIntf.IStreamAdapter;
IStdIn = StdInIntf.IStdIn;
IStdOut = StdOutIntf.IStdOut;
IStdErr = StdErrIntf.IStdErr;
IStdInStreamAware = StdInStreamAwareIntf.IStdInStreamAware;

IHttpClientHandleAware = HttpClientHandleAwareIntf.IHttpClientHandleAware;
IHttpClientHeaders = HttpClientHeadersIntf.IHttpClientHeaders;
IHttpGetClient = HttpGetClientIntf.IHttpGetClient;
IHttpPostClient = HttpPostClientIntf.IHttpPostClient;
IHttpPutClient = HttpPutClientIntf.IHttpPutClient;
IHttpDeleteClient = HttpDeleteClientIntf.IHttpDeleteClient;
IHttpHeadClient = HttpHeadClientIntf.IHttpHeadClient;

IKeyValuePair = KeyValuePairIntf.IKeyValuePair;

IRunnableWithDataNotif = RunnableWithDataNotifIntf.IRunnableWithDataNotif;

IFcgiRecord = FcgiRecordIntf.IFcgiRecord;
IFcgiRecordFactory = FcgiRecordFactoryIntf.IFcgiRecordFactory;
IFcgiRequest = FcgiRequestIntf.IFcgiRequest;
IFcgiRequestManager = FcgiRequestManagerIntf.IFcgiRequestManager;
IFcgiFrameParser = FcgiFrameParserIntf.IFcgiFrameParser;

IProtocolProcessor = ProtocolProcessorIntf.IProtocolProcessor;
IReadyListener = ReadyListenerIntf.IReadyListener;

IRegex = RegexIntf.IRegex;

IAntivirus = AntivirusIntf.IAntivirus;
IScanResult = ScanResultIntf.IScanResult;
IRandom = RandomIntf.IRandom;

ICliParams = CliParamsIntf.ICliParams;
ICliParamsFactory = CliParamsFactoryIntf.ICliParamsFactory;

IEncrypter = EncrypterIntf.IEncrypter;
IDecrypter = DecrypterIntf.IDecrypter;

{$INCLUDE Socket2/libs.aliases.inc}
{$INCLUDE Mailer/libs.aliases.inc}
{$INCLUDE UserAgent/libs.aliases.inc}
{$INCLUDE Throttle/libs.aliases.inc}
