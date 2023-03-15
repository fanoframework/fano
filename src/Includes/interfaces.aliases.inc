{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare interface aliases that is included in fano.pas unit
 * This file is provided so we can use fano framework
 * by using only one uses to simplify things.
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

{$INCLUDE DI/Contracts/di.aliases.inc}
{$INCLUDE Core/Contracts/core.aliases.inc}
{$INCLUDE Dispatcher/Contracts/dispatcher.aliases.inc}
{$INCLUDE Environment/Contracts/environment.aliases.inc}
{$INCLUDE Error/Contracts/error.aliases.inc}
{$INCLUDE App/Contracts/app.aliases.inc}
{$INCLUDE Config/Contracts/config.aliases.inc}
{$INCLUDE Router/Contracts/router.aliases.inc}
{$INCLUDE Middleware/Contracts/middleware.aliases.inc}
{$INCLUDE Http/Contracts/http.aliases.inc}
{$INCLUDE Libs/Contracts/libs.aliases.inc}
{$INCLUDE Mvc/Contracts/mvc.aliases.inc}
{$INCLUDE Security/Contracts/security.aliases.inc}
{$INCLUDE Sessions/Contracts/sessions.aliases.inc}
{$INCLUDE Db/Contracts/db.aliases.inc}
