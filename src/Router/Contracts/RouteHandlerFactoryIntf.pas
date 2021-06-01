{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteHandlerFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestHandlerIntf,
    RouteHandlerIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * create route handler
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRouteHandlerFactory = interface
        ['{1EBACEAD-A5EB-4754-A7D5-531F969088D1}']

        function build(const handler : IRequestHandler) : IRouteHandler;
    end;

implementation
end.
