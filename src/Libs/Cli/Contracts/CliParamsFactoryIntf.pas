{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CliParamsFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    CliParamsIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to read
     * command line parameter options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ICliParamsFactory = interface
        ['{E32F0BEC-C606-4601-8AC3-2F3ADAB3D466}']

        (*!------------------------------------------------
         * add option
         *-----------------------------------------------
         * @param aName option name
         * @param hasArg flag if option has argument
         * @param aFlag flag if option has argument
         * @param aValue short option
         * @return current instance
         *-----------------------------------------------*)
        function addOption(
            const aName : string;
            const hasArg: integer = 0;
            const aFlag : pchar = nil;
            const aValue: char = #0
        ) : ICliParamsFactory;

        function build() : ICliParams;
    end;

implementation

end.
