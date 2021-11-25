{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ERouteMatcherImpl;

interface

{$MODE OBJFPC}

uses

    EInternalServerErrorImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when route matching
     * is failed
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ERouteMatcher = class(EInternalServerError);

implementation

end.
