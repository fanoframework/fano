{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullEnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AbstractEnvironmentImpl;

type

    (*!------------------------------------------------
     * dummy CGI environment variable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TNullCGIEnvironment = class(TAbstractCGIEnvironment)
    public
        (*!-----------------------------------------
         * Retrieve an environment variable
         *------------------------------------------
         * @param key name of variable
         * @return variable value
         *------------------------------------------*)
        function env(const keyName : string) : string; override;

        (*!------------------------------------------------
         * get number of variables
         *-----------------------------------------------
         * @return number of variables
         *-----------------------------------------------*)
        function count() : integer; override;

        (*!------------------------------------------------
         * get key by index
         *-----------------------------------------------
         * @param index index to use
         * @return key name
         *-----------------------------------------------*)
        function getKey(const indx : integer) : shortstring; override;
    end;

implementation


    (*!-----------------------------------------
     * Retrieve an environment variable
     *------------------------------------------
     * @param key name of variable
     * @return variable value
     *------------------------------------------*)
    function TNullCGIEnvironment.env(const keyName : string) : string;
    begin
        //intentionally does nothing
        result := '';
    end;

    (*!------------------------------------------------
     * get number of variables
     *-----------------------------------------------
     * @return number of variables
     *-----------------------------------------------*)
    function TNullCGIEnvironment.count() : integer;
    begin
        //intentionally does nothing
        result := 0;
    end;

    (*!------------------------------------------------
     * get key by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TNullCGIEnvironment.getKey(const indx : integer) : shortstring;
    begin
        //intentionally does nothing
        result := '';
    end;
end.
