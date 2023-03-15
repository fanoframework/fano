{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionManagerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    RequestIntf,
    ReadOnlySessionManagerIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * create session from request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISessionManager = interface(IReadOnlySessionManager)
        ['{F6526BF2-538B-46CC-AF49-D5F373B6E2F5}']

        (*!------------------------------------
         * begin session from request
         *-------------------------------------
         * @param request current request instance
         * @param lifeTimeInSec life time of session in seconds
         * @return session instance
         *-------------------------------------*)
        function beginSession(
            const request : IRequest;
            const lifeTimeInSec : integer
        ) : ISession;

        (*!------------------------------------
         * end session and save session data to
         * persistent storage if not expired or
         * if expired destroy its storage
         *-------------------------------------
         * @param session session instance returned by beginSession()
         * @return current instance
         *-------------------------------------*)
        function endSession(const session : ISession) : ISessionManager;
    end;

implementation
end.
