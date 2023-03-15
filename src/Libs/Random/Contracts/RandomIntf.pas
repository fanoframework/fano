{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RandomIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * get random value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IRandom = interface
        ['{44932581-5658-42C1-BEF5-9C46917CAE30}']

        function randomBytes(const totalBytes : integer) : TBytes;
    end;

implementation
end.
