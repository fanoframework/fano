{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullRouteArgsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RouteArgsReaderIntf,
    RouteArgsWriterIntf,
    PlaceholderTypes;

type

    (*!------------------------------------------------
     * null implementation class having capability to
     * read write route arguments
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullRouteArgs = class (TInterfacedObject, IRouteArgsReader, IRouteArgsWriter)
    public
        (*!-------------------------------------------
         * get route argument data
         *--------------------------------------------
         * @return current array of placeholders
         *--------------------------------------------*)
        function getArgs() : TArrayOfPlaceholders;

        (*!-------------------------------------------
         * Set route argument data
         *--------------------------------------------
         * @param placeHolders array of placeholders
         * @return current instance
         *--------------------------------------------*)
        function setArgs(const placeHolders : TArrayOfPlaceholders) : IRouteArgsWriter;

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

        (*!-------------------------------------------
         * get route name
         *--------------------------------------------
         * @return current route name
         *--------------------------------------------*)
        function getName() : shortstring;
    end;

implementation

    (*!-------------------------------------------
     * get route argument data
     *--------------------------------------------
     * @return current array of placeholders
     *--------------------------------------------*)
    function TNullRouteArgs.getArgs() : TArrayOfPlaceholders;
    begin
        result := [];
    end;

    (*!-------------------------------------------
     * Set route argument data
     *--------------------------------------------
     * @param placeHolders array of placeholders
     * @return current instance
     *--------------------------------------------*)
    function TNullRouteArgs.setArgs(const placeHolders : TArrayOfPlaceholders) : IRouteArgsWriter;
    begin
        //intentionally do nothing
        result := self;
    end;

    (*!-------------------------------------------
     * get single route argument data
     *--------------------------------------------
     * @param key name of argument
     * @return placeholder
     *--------------------------------------------*)
    function TNullRouteArgs.getArg(const key : shortstring) : TPlaceholder;
    begin
        result := default(TPlaceholder);
    end;

    (*!-------------------------------------------
     * get single route argument value
     *--------------------------------------------
     * @param key name of argument
     * @return argument value
     *--------------------------------------------*)
    function TNullRouteArgs.getValue(const key : shortstring) : string;
    begin
        result := '';
    end;

    (*!-------------------------------------------
     * get route name
     *--------------------------------------------
     * @return current route name
     *--------------------------------------------*)
    function TNullRouteArgs.getName() : shortstring;
    begin
        result := '';
    end;
end.
