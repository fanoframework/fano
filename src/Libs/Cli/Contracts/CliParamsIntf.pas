{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CliParamsIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to read
     * command line parameter options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ICliParams = interface
        ['{7EBAA6AB-7A5A-4839-B06F-E66F521FF156}']

        (*!------------------------------------------------
         * get option from command line parameters
         *-----------------------------------------------
         * @param opt option
         * @return value
         *-----------------------------------------------*)
        function getOption(const opt : string; const defValue : string) : string; overload;

        (*!------------------------------------------------
         * get option from command line parameters as integer
         *-----------------------------------------------
         * @param opt option
         * @return value
         *-----------------------------------------------*)
        function getOption(const opt : string; const defValue : integer) : integer; overload;

        (*!------------------------------------------------
         * get option from command line parameters as word
         *-----------------------------------------------
         * @param opt option
         * @return value
         *-----------------------------------------------*)
        function getOption(const opt : string; const defValue : word) : word; overload;

        (*!------------------------------------------------
         * get option from command line parameters as boolean
         *-----------------------------------------------
         * @param opt option
         * @return value
         *-----------------------------------------------*)
        function getOption(const opt : string; const defValue : boolean) : boolean; overload;

        (*!------------------------------------------------
         * test if option is set
         *-----------------------------------------------
         * @param opt option
         * @return boolean
         *-----------------------------------------------*)
        function hasOption(const opt : string) : boolean;
    end;

implementation

end.
