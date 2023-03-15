{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

TOutputBufferFactory = OutputBufferFactoryImpl.TOutputBufferFactory;
TStdErrBufferFactory = StdErrBufferFactoryImpl.TStdErrBufferFactory;

TStringFileReader = StringFileReaderImpl.TStringFileReader;
TStringFileReaderFactory = StringFileReaderFactoryImpl.TStringFileReaderFactory;
TBasicFileReader = BasicFileReaderImpl.TBasicFileReader;
TBasicFileReaderFactory = BasicFileReaderFactoryImpl.TBasicFileReaderFactory;

TStreamAdapter = StreamAdapterImpl.TStreamAdapter;
EInvalidStream = EInvalidStreamImpl.EInvalidStream;
TSerializeableStream = SerializeableStreamImpl.TSerializeableStream;

TStdInReader = StdInReaderImpl.TStdInReader;
TSimpleStdInReader = SimpleStdInReaderImpl.TSimpleStdInReader;
TStdInFromString = StdInFromStringImpl.TStdInFromString;
TStdInFromStream = StdInFromStreamImpl.TStdInFromStream;

TKeyValuePair = KeyValuePairImpl.TKeyValuePair;
TKeyValuePairFactory = KeyValuePairFactoryImpl.TKeyValuePairFactory;

{$INCLUDE Socket/libs.aliases.inc}
{$INCLUDE Socket2/libs.aliases.inc}
{$INCLUDE Logger/libs.aliases.inc}
{$INCLUDE Regex/libs.aliases.inc}
{$INCLUDE HttpClient/libs.aliases.inc}
{$INCLUDE Protocol/libs.aliases.inc}
{$INCLUDE Random/libs.aliases.inc}
{$INCLUDE Cli/libs.aliases.inc}
{$INCLUDE Encrypter/libs.aliases.inc}
{$INCLUDE Antivirus/libs.aliases.inc}
{$INCLUDE Mailer/libs.aliases.inc}
{$INCLUDE UserAgent/libs.aliases.inc}
{$INCLUDE Throttle/libs.aliases.inc}
