{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for implementation in auth
 * that is included in implementations.aliases.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TAbstractHmacJwtAlg = AbstractHmacJwtAlgImpl.TAbstractHmacJwtAlg;
THmacSha256JwtAlg = HmacSha256JwtAlgImpl.THmacSha256JwtAlg;
THmacSha384JwtAlg = HmacSha384JwtAlgImpl.THmacSha384JwtAlg;
THmacSha512JwtAlg = HmacSha512JwtAlgImpl.THmacSha512JwtAlg;
TNoneJwtAlg = NoneJwtAlgImpl.TNoneJwtAlg;

TJwtTokenVerifier = JwtTokenVerifierImpl.TJwtTokenVerifier;
TJwtTokenVerifierFactory = JwtTokenVerifierFactoryImpl.TJwtTokenVerifierFactory;

TJwtTokenGenerator = JwtTokenGeneratorImpl.TJwtTokenGenerator;
TJwtTokenGeneratorFactory = JwtTokenGeneratorFactoryImpl.TJwtTokenGeneratorFactory;

EJwt = EJwtImpl.EJwt;
