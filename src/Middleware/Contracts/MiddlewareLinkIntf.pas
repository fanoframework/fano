{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareLinkIntf;

interface

{$MODE OBJFPC}

uses

    RequestHandlerIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability
     * as middleware link
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IMiddlewareLink = interface(IRequestHandler)
        ['{275E4EC5-8ACB-40C5-8606-5D8AE1EE1594}']

        procedure setNext(const next : IRequestHandler);
        function getNext() : IRequestHandler;
        property next : IRequestHandler read getNext write setNext;
    end;

implementation
end.
