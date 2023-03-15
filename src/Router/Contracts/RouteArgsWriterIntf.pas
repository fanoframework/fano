{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteArgsWriterIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    PlaceholderTypes;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * write route arguments
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRouteArgsWriter = interface
        ['{A7C2443A-631D-4132-8DA2-02AB5379D181}']

        (*!-------------------------------------------
         * Set route argument data
         *--------------------------------------------
         * @param placeHolders array of placeholders
         * @return current instance
         *--------------------------------------------*)
        function setArgs(const placeHolders : TArrayOfPlaceholders) : IRouteArgsWriter;
    end;

implementation
end.
