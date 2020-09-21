{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReadOnlySessionManagerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    RequestIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * read session from request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IReadOnlySessionManager = interface
        ['{A7D1A4B7-0D8E-4048-80F7-2107AF81E9AE}']

        (*!------------------------------------
         * get session from request
         *-------------------------------------
         * @param request current request instance
         * @return session instance or nil if not found
         *-------------------------------------*)
        function getSession(const request : IRequest) : ISession;

        property sessions[const request : IRequest] : ISession read getSession; default;
    end;

implementation
end.
