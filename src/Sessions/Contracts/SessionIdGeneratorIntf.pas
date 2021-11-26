{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionIdGeneratorIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * generate session id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISessionIdGenerator = interface
        ['{DD1BED9D-3C01-4857-A585-B3B77B7463AF}']

        (*!------------------------------------
         * get session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function getSessionId(const request : IRequest) : string;
    end;

implementation
end.
