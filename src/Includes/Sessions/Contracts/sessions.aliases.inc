{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for interface in sessions
 * that is included in fano.pas unit
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

ISessionIdGenerator = SessionIdGeneratorIntf.ISessionIdGenerator;
ISessionIdGeneratorFactory = SessionIdGeneratorFactoryIntf.ISessionIdGeneratorFactory;
ISession = SessionIntf.ISession;
ISessionFactory = SessionFactoryIntf.ISessionFactory;
ISessionManager = SessionManagerIntf.ISessionManager;
IReadOnlySessionManager = ReadOnlySessionManagerIntf.IReadOnlySessionManager;
