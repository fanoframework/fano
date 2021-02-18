{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestResponseFactoryIntf;

interface

{$MODE OBJFPC}

uses

    RequestFactoryIntf,
    ResponseFactoryIntf;

type

    (*!---------------------------------------------------
     * interface for any class having capability return
     * request and response factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    IRequestResponseFactory = interface
        ['{EF48EDCE-8C23-4D25-A91F-12ABC6B544C0}']

        function getRequestFactory() : IRequestFactory;
        function getResponseFactory() : IResponseFactory;

        property requestFactory : IRequestFactory read getRequestFactory;
        property responseFactory : IResponseFactory read getResponseFactory;
    end;

implementation
end.
