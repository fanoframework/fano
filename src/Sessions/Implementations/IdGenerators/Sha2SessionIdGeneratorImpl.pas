{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit Sha2SessionIdGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    DecoratorSessionIdGeneratorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * generate session id using SHA-2 256-bit
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSha2SessionIdGenerator = class(TDecoratorSessionIdGenerator)
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
    Classes,
    SysUtils,
    HlpIHash,
    HlpHashFactory,
    HlpIHashInfo;

    (*!------------------------------------
     * get session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TSha2SessionIdGenerator.getSessionId(const request : IRequest) : string;
    var
        hashInst: IHash;
    begin
        hashInst := THashFactory.TCrypto.CreateSHA2_256();
        result := hashInst.ComputeString(
            fActualGenerator.getSessionId(request),
            TEncoding.UTF8
        ).toString();
    end;

end.
