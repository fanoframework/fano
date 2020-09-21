{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * store session variables
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISession = interface(ISerializeable)
        ['{17731DEE-C1ED-4543-86BE-7F72F2A19FEF}']

        (*!------------------------------------
         * get session name
         *-------------------------------------
         * @return session name
         *-------------------------------------*)
        function name() : shortstring;


        (*!------------------------------------
         * get current session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function id() : string;

        (*!------------------------------------
         * test if session variable is set
         *-------------------------------------
         * @return true if session variable is set
         *-------------------------------------*)
        function has(const sessionVar : shortstring) : boolean;

        (*!------------------------------------
         * set session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @param sessionVal value of session variable
         * @return current instance
         *-------------------------------------*)
        procedure setVar(const sessionVar : shortstring; const sessionVal : string);

        (*!------------------------------------
         * get session variable
         *-------------------------------------
         * @return session value
         *-------------------------------------*)
        function getVar(const sessionVar : shortstring) : string;

        (*!------------------------------------
         * delete session variable
         *-------------------------------------
         * @param sessionVar name of session variable
         * @return current instance
         *-------------------------------------*)
        function delete(const sessionVar : shortstring) : ISession;

        (*!------------------------------------
         * clear all session variables
         *-------------------------------------
         * @return current instance
         *-------------------------------------*)
        function clear() : ISession;

        (*!------------------------------------
         * test if current session is expired
         *-------------------------------------
         * @return true if session is expired
         *-------------------------------------*)
        function expired() : boolean;

        (*!------------------------------------
         * get session expiration date
         *-------------------------------------
         * @return date time when session is expired
         *-------------------------------------*)
        function expiresAt() : TDateTime;

        property vars[const key : shortstring] : string read getVar write setVar; default;
    end;

implementation
end.
