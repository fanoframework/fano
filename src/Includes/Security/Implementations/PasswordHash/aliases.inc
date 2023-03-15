{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for implementation in security
 * that is included in implementations.aliases.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)
TPbkdf2PasswordHash = Pbkdf2PasswordHashImpl.TPbkdf2PasswordHash;
TPbkdf2PasswordHashFactory = Pbkdf2PasswordHashFactoryImpl.TPbkdf2PasswordHashFactory;

TArgon2iPasswordHash = Argon2iPasswordHashImpl.TArgon2iPasswordHash;
TArgon2iPasswordHashFactory = Argon2iPasswordHashFactoryImpl.TArgon2iPasswordHashFactory;

TScryptPasswordHash = ScryptPasswordHashImpl.TScryptPasswordHash;
TScryptPasswordHashFactory = ScryptPasswordHashFactoryImpl.TScryptPasswordHashFactory;

TSha2_256PasswordHash = Sha2_256PasswordHashImpl.TSha2_256PasswordHash;
TSha2_512PasswordHash = Sha2_512PasswordHashImpl.TSha2_512PasswordHash;
TSha2PasswordHashFactory = Sha2PasswordHashFactoryImpl.TSha2PasswordHashFactory;
