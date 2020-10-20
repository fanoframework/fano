{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit RawSessionIdGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIdGeneratorIntf,
    EnvironmentIntf,
    RandomIntf,
    RequestIntf;

type

    (*!------------------------------------------------
     * basic class having capability to
     * generate session id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TRawSessionIdGenerator = class(TInterfacedObject, ISessionIdGenerator)
    private
        fRandom : IRandom;
        fNumBytes : integer;
    public
        constructor create(const randInst : IRandom; const numBytes : integer = 32);
        destructor destroy(); override;

        (*!------------------------------------
         * get session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function getSessionId(const request : IRequest) : string;
    end;

implementation

uses

    Unix,
    SysUtils,
    BaseUnix;

    constructor TRawSessionIdGenerator.create(
        const randInst : IRandom;
        const numBytes : integer = 32
    );
    begin
        inherited create();
        fRandom := randInst;
        fNumBytes := numBytes;
    end;

    destructor TRawSessionIdGenerator.destroy();
    begin
        fRandom := nil;
        inherited destroy();
    end;

    (*!------------------------------------
     * get session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TRawSessionIdGenerator.getSessionId(const request : IRequest) : string;
    var tv: TTimeVal;
    begin
        fpGetTimeOfDay (@tv, nil);
        result := format(
            '%s%d%d%s',
            [
                request.env.remoteAddr(),
                tv.tv_sec,
                tv.tv_usec,
                stringOf(fRandom.randomBytes(fNumBytes))
            ]
        );
    end;

end.
