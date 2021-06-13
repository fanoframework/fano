{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionRequestIdentifierImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ReadOnlySessionManagerIntf,
    AbstractRequestIdentifierImpl;

type

    (*!------------------------------------------------
     * request identifier implementation which use client
     * session id as identifier
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSessionRequestIdentifier = class (TAbstractRequestIdentifier)
    private
        fSessionManager : IReadOnlySessionManager;
    public
        constructor create(const sessionManager : IReadOnlySessionManager);

        (*!------------------------------------------------
         * get identifier from request
         *-----------------------------------------------
         * @param request request object
         * @return identifier string
         *-----------------------------------------------*)
        function getId(const request : IRequest) : shortstring; override;
    end;

implementation

uses

    SessionIntf;

    constructor TSessionRequestIdentifier.create(
        const sessionManager : IReadOnlySessionManager
    );
    begin
        fSessionManager := sessionManager;
    end;

    (*!------------------------------------------------
     * get identifier from request
     *-----------------------------------------------
     * @param request request object
     * @return identifier string
     *-----------------------------------------------*)
    function TSessionRequestIdentifier.getId(const request : IRequest) : shortstring;
    var sess : ISession;
    begin
        sess := fSessionManager[request];
        result := sess.id;
    end;

end.
