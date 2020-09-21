{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewParametersIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes;

type

    (*!------------------------------------------------
     * interface for any class having capability as
     * view parameters
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IViewParameters = interface
        ['{F93CA7D6-4454-4A04-A585-78BFF12F49E3}']

        (*!------------------------------------------------
         * get all registered variable name as array of string
         *-----------------------------------------------
         * @return instance of TStrings
         *-----------------------------------------------
         * Note: caller MUST not modify or destroy TStrings
         * instance and should read only
         *-----------------------------------------------*)
        function asStrings() : TStrings;

        (*!------------------------------------------------
         * test if variable name is set
         *-----------------------------------------------
         * @param varName name of variable
         * @return boolean
         *-----------------------------------------------*)
        function has(const varName : shortstring) : boolean;

        (*!------------------------------------------------
         * get variable value by name
         *-----------------------------------------------
         * @param varName name of variable
         * @return value of variable
         *-----------------------------------------------*)
        function getVar(const varName : shortstring) : string;

        (*!------------------------------------------------
         * set variable value by name
         *-----------------------------------------------
         * @param varName name of variable
         * @param valueData value to be store
         * @return current class instance
         *-----------------------------------------------
         * This method is as exact functionality as putVar()
         * but deliberately not removed so we can set variable
         * as chained method call, e.g,
         * v.setVar('var1', 'val1').setVar('var2', 'val2');
         *-----------------------------------------------*)
        function setVar(const varName : shortstring; const valueData :string) : IViewParameters;

        (*!------------------------------------------------
         * set variable value by name. Alias to setVar()
         *-----------------------------------------------
         * @param varName name of variable
         * @param valueData value to be store
         *-----------------------------------------------
         * This method is as exact functionality as setVar()
         * but deliberately not removed so we can set variable
         * in array-like fashion with default property, e.g,
         * v['var1'] := 'val1';
         * v['var2'] := 'val2';
         *-----------------------------------------------*)
        procedure putVar(const varName : shortstring; const valueData :string);
        (*!------------------------------------------------
         * property to read and set value in array-like fashin
         *-----------------------------------------------*)
        property vars[const varName : shortstring] : string read getVar write putVar; default;

    end;

implementation
end.
