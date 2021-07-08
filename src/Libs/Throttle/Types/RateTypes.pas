{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RateTypes;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ResponseIntf,
    RequestHandlerIntf,
    RouteArgsReaderIntf;

type

    TRate = record
        //number of operations allowed
        operations : integer;

        //interval in seconds
        interval : integer;
    end;

    TLimitStatus = record
        limitReached : boolean;
        limit : integer;
        remainingAttempts : integer;

        //timestamp when counter will be reset
        resetTimestamp : integer;

        //number of seconds after counter will be reset
        retryAfter : integer;
    end;

    TOnLimitReachedEvent = function (
        const status : TLimitStatus;
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse of object;

implementation

end.
