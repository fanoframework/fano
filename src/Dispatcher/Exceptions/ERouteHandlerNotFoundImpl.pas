{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ERouteHandlerNotFoundImpl;

interface

{$MODE OBJFPC}

uses

    ENotFoundImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when route is not found.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ERouteHandlerNotFound = class(ENotFound);

implementation

end.
