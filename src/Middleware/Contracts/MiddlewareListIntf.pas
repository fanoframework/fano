{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MiddlewareListIntf;

interface

{$MODE OBJFPC}

uses

   MiddlewareIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * add a middleware to collection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IMiddlewareList = interface
        ['{DF2C4336-6849-4A50-AACE-3676CD9FB395}']
        function add(const middleware : IMiddleware) : IMiddlewareList;
    end;

implementation

end.
