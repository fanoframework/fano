{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ClientOsIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * get client OS platform
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IClientOS = interface
        ['{57CF3D60-5BDE-42B0-B138-14DCE70310D3}']

        function isOS(const osName : shortString) : boolean;
        property OS[const osName : shortString] : boolean read isOS;
    end;

implementation
end.
