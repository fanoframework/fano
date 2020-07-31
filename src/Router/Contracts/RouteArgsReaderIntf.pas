{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RouteArgsReaderIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    PlaceholderTypes;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * read route arguments
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRouteArgsReader = interface
        ['{4AA94806-EE58-43E1-AF8C-B2B6F99BCD1B}']

        (*!-------------------------------------------
         * get route argument data
         *--------------------------------------------
         * @return current array of placeholders
         *--------------------------------------------*)
        function getArgs() : TArrayOfPlaceholders;

        (*!-------------------------------------------
         * get single route argument data
         *--------------------------------------------
         * @param key name of argument
         * @return placeholder
         *--------------------------------------------*)
        function getArg(const key : shortstring) : TPlaceholder;

        (*!-------------------------------------------
         * get single route argument value
         *--------------------------------------------
         * @param key name of argument
         * @return argument value
         *--------------------------------------------*)
        function getValue(const key : shortstring) : string;
        property value[const key : shortstring] : string read getValue; default;

        (*!-------------------------------------------
         * get route name
         *--------------------------------------------
         * @return current route name
         *--------------------------------------------*)
        function getName() : shortstring;
    end;

implementation
end.
