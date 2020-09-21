{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareListFactoryIntf;

interface

{$MODE OBJFPC}

uses

   MiddlewareListItemIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * manage one or more middlewares
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IMiddlewareListFactory = interface
        ['{D91F3951-9FAF-4051-8CC0-A0BE3C7DC31D}']
        function build() : IMiddlewareListItem;
    end;

implementation

end.
