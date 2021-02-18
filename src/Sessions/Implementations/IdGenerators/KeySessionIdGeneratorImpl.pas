{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit KeySessionIdGeneratorImpl;

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
     * append secret key to generate session id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKeySessionIdGenerator = class(TDecoratorSessionIdGenerator)
    private
        fSecretKey : string;
    public
        constructor create(const gen : ISessionIdGenerator; const secretKey : string);

        (*!------------------------------------
         * get session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function getSessionId(const request : IRequest) : string; override;
    end;

implementation


    constructor TKeySessionIdGenerator.create(const gen : ISessionIdGenerator; const secretKey : string);
    begin
        inherited create(gen);
        fSecretKey := secretKey;
    end;

    (*!------------------------------------
     * get session id
     *-------------------------------------
     * @return session id string
     *-------------------------------------*)
    function TKeySessionIdGenerator.getSessionId(const request : IRequest) : string;
    begin
        result := fSecretKey + fActualGenerator.getSessionId(request);
    end;

end.
