{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteDataTypes;

interface

{$MODE OBJFPC}

uses

    PlaceholderTypes,
    RouteHandlerIntf;

type


    (*!------------------------------------------------
     * Data structure for storing route data
     * for HTTP GET, PUT, POST, DELETE, PATCH, HEAD, OPTIONS
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     * -----------------------------------------------*)
    TRouteRec = record
        getRoute : IRouteHandler;
        postRoute : IRouteHandler;
        putRoute : IRouteHandler;
        patchRoute : IRouteHandler;
        deleteRoute : IRouteHandler;
        optionsRoute : IRouteHandler;
        headRoute : IRouteHandler;

        placeholders : TArrayOfPlaceholders;
    end;
    PRouteRec = ^TRouteRec;

implementation



end.
