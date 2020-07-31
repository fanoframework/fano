{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit Md5SessionIdGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    DecoratorSessionIdGeneratorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * generate session id using MD5
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TMd5SessionIdGenerator = class(TDecoratorSessionIdGenerator)
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

    md5;

    (*!------------------------------------
     * get session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TMd5SessionIdGenerator.getSessionId(const request : IRequest) : string;
    begin
        result := MD5Print(MD5String(fActualGenerator.getSessionId(request)));
    end;

end.
