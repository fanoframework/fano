{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare implementation aliases that is included in fano.pas unit
 * This file is provided so we can use fano framework
 * by using only one uses to simplify things.
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

{$INCLUDE Core/Implementations/core.aliases.inc}
{$INCLUDE DI/Implementations/di.aliases.inc}
{$INCLUDE Environment/Implementations/environment.aliases.inc}
{$INCLUDE Error/Implementations/error.aliases.inc}
{$INCLUDE App/Implementations/app.aliases.inc}
{$INCLUDE Config/Implementations/config.aliases.inc}
{$INCLUDE Dispatcher/Implementations/dispatcher.aliases.inc}
{$INCLUDE Middleware/Implementations/middleware.aliases.inc}
{$INCLUDE Router/Implementations/router.aliases.inc}
{$INCLUDE Http/Implementations/http.aliases.inc}
{$INCLUDE Libs/Implementations/libs.aliases.inc}
{$INCLUDE Mvc/Implementations/mvc.aliases.inc}
{$INCLUDE Security/Implementations/security.aliases.inc}
{$INCLUDE Sessions/Implementations/sessions.aliases.inc}
{$INCLUDE Db/Implementations/db.aliases.inc}
