{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit Sha1SessionIdGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    DecoratorSessionIdGeneratorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * generate session id using SHA-1
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSha1SessionIdGenerator = class(TDecoratorSessionIdGenerator)
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

    sha1;

    (*!------------------------------------
     * get session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TSha1SessionIdGenerator.getSessionId(const request : IRequest) : string;
    begin
        result := SHA1Print(SHA1String(fActualGenerator.getSessionId(request)));
    end;

end.
