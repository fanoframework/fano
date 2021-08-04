{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for implementation in security
 * that is included in implementations.aliases.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TBase64Encrypter = Base64EncrypterImpl.TBase64Encrypter;
TBlowfishEncrypter = BlowfishEncrypterImpl.TBlowfishEncrypter;
TCompositeEncrypter = CompositeEncrypterImpl.TCompositeEncrypter;
THmacEncrypter = HmacEncrypterImpl.THmacEncrypter;
TMd5HmacEncrypter = Md5HmacEncrypterImpl.TMd5HmacEncrypter;
TSha1HmacEncrypter = Sha1HmacEncrypterImpl.TSha1HmacEncrypter;

TBlowfishEncrypterFactory = BlowfishEncrypterFactoryImpl.TBlowfishEncrypterFactory;
THmacEncrypterFactory = HmacEncrypterFactoryImpl.THmacEncrypterFactory;
TMd5HmacEncrypterFactory = Md5HmacEncrypterFactoryImpl.TMd5HmacEncrypterFactory;
TSha1HmacEncrypterFactory = Sha1HmacEncrypterFactoryImpl.TSha1HmacEncrypterFactory;
