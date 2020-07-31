{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AbstractEnvironmentImpl;

type

    (*!------------------------------------------------
     * basic having capability to retrieve
     * CGI environment variable
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TCGIEnvironment = class(TAbstractCGIEnvironment)
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

uses

    SysUtils;


    (*!-----------------------------------------
     * Retrieve an environment variable
     *------------------------------------------
     * @param key name of variable
     * @return variable value
     *------------------------------------------*)
    function TCGIEnvironment.env(const keyName : string) : string;
    begin
        result := GetEnvironmentVariable(keyName);
    end;

    (*!------------------------------------------------
     * get number of variables
     *-----------------------------------------------
     * @return number of variables
     *-----------------------------------------------*)
    function TCGIEnvironment.count() : integer;
    begin
        //GetEnvironmentVariableCount() use 1-based index,
        //we always use zero-based so subtract 1
        result := GetEnvironmentVariableCount() - 1;
    end;

    (*!------------------------------------------------
     * get key by index
     *-----------------------------------------------
     * @param index index to use
     * @return key name
     *-----------------------------------------------*)
    function TCGIEnvironment.getKey(const indx : integer) : shortstring;
    begin
        //GetEnvironmentString() use 1-based index,
        //we always use zero-based so add 1
        result := GetEnvironmentString(indx + 1);
    end;
end.
