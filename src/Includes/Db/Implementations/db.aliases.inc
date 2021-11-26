{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * unit interfaces that is included in fano.pas unit
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

TRdbms = RdbmsImpl.TRdbms;
TRdbmsPool = RdbmsPoolImpl.TRdbmsPool;
TThreadSafeRdbmsPool = ThreadSafeRdbmsPoolImpl.TThreadSafeRdbmsPool;
TRdbmsPoolFactory = RdbmsPoolFactoryImpl.TRdbmsPoolFactory;
TThreadSafeRdbmsPoolFactory = ThreadSafeRdbmsPoolFactoryImpl.TThreadSafeRdbmsPoolFactory;

TMySqlDb = MySqlDbImpl.TMySqlDb;
TMySQLDbFactory = MySqlDbFactoryImpl.TMySQLDbFactory;

TPostgreSqlDb = PostgreSqlDbImpl.TPostgreSqlDb;
TPostgreSqlDbFactory = PostgreSqlDbFactoryImpl.TPostgreSqlDbFactory;

TFirebirdDb = FirebirdDbImpl.TFirebirdDb;
TFirebirdDbFactory = FirebirdDbFactoryImpl.TFirebirdDbFactory;

TSQLiteDb = SQLiteDbImpl.TSQLiteDb;
TSQLiteDbFactory = SQLiteDbFactoryImpl.TSQLiteDbFactory;

TOdbcDb = OdbcDbImpl.TOdbcDb;
TOdbcDbFactory = OdbcDbFactoryImpl.TOdbcDbFactory;
