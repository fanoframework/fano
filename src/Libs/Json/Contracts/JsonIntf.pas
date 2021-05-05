{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyKeyValuePairIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability as json
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IJson = interface
        ['{B9C9BD8D-3BC9-48B0-B755-6EB24F10C038}']

        (*!------------------------------------------------
         * return data as JSON string
         *-----------------------------------------------
         * @return JSON string
         *-----------------------------------------------*)
        function asJSON() : string;

    end;

implementation
end.
