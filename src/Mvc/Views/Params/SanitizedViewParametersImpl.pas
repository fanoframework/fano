{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SanitizedViewParametersImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    ViewParametersIntf,
    SanitizerIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic decorator class that can parse template and
     * replace all html entities with is sanitized entities
     * i.e it replaces '<' with &lt; and so on.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSanitizedViewParameters = class(TInjectableObject, IViewParameters)
    private
        fActualParam : IViewParameters;
        fSanitizer : ISanitizer;
    public
        constructor create(
            const actualParam : IViewParameters;
            const sanitizer : ISanitizer
        );

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
    end;

implementation

    constructor TSanitizedViewParameters.create(
        const actualParam : IViewParameters;
        const sanitizer : ISanitizer
    );
    begin
        fActualParam := actualParam;
        fSanitizer := sanitizer;
    end;

    (*!------------------------------------------------
     * get all registered variable name as array of string
     *-----------------------------------------------
     * @return instance of TStrings
     *-----------------------------------------------
     * Note: caller MUST not modify or destroy TStrings
     * instance and should read only
     *-----------------------------------------------*)
    function TSanitizedViewParameters.asStrings() : TStrings;
    begin
        result := fActualParam.asStrings();
    end;

    (*!------------------------------------------------
     * get variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @return value of variable
     *-----------------------------------------------*)
    function TSanitizedViewParameters.getVar(const varName : shortstring) : string;
    begin
        result := fSanitizer.sanitize(fActualParam.getVar(varName));
    end;

    (*!------------------------------------------------
     * set variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    function TSanitizedViewParameters.setVar(
        const varName : shortstring;
        const valueData :string
    ) : IViewParameters;
    begin
        fActualParam.setVar(varName, valueData);
        result := self;
    end;

    (*!------------------------------------------------
     * set variable value by name. Alias to setVar
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    procedure TSanitizedViewParameters.putVar(
        const varName : shortstring;
        const valueData :string
    );
    begin
        setVar(varName, valueData);
    end;

    (*!------------------------------------------------
     * test if variable name is set
     *-----------------------------------------------
     * @param varName name of variable
     * @return boolean
     *-----------------------------------------------*)
    function TSanitizedViewParameters.has(const varName : shortstring) : boolean;
    begin
        result := fActualParam.has(varName);
    end;
end.
