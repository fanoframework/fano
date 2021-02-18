{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit IpTimeSessionIdGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    SessionIdGeneratorIntf,
    DecoratorSessionIdGeneratorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * append IP address and current time to generate session id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIpTimeSessionIdGenerator = class(TDecoratorSessionIdGenerator)
    public
        (*!------------------------------------
         * get session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function getSessionId(const request : IRequest) : string; override;
    end;

implementation

uses

    SysUtils,
    BaseUnix,
    Unix;

    (*!------------------------------------
     * get session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TIpTimeSessionIdGenerator.getSessionId(const request : IRequest) : string;
    var ipAddr : string;
        tval : TTimeVal;
    begin
        ipAddr := request.env.remoteAddr();
        fpGetTimeOfDay(@tval, nil);

        result := format(
            '%s%d%d%s',
            [
                ipAddr,
                tval.tv_sec,
                tval.tv_usec,
                fActualGenerator.getSessionId(request)
            ]
        );
    end;

end.
