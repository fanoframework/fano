{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewParametersAsJsonImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes,
    ViewParametersIntf,
    JsonIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * dummy view parameters implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TViewParametersAsJson = class(TInjectableObject, IViewParameters, IJson)
    private
        fActualViewParameters : IViewParameters;
    public
        constructor create(const viewParams : IViewParameters);

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
         *-----------------------------------------------*)
        function setVar(const varName : shortstring; const valueData :string) : IViewParameters;

        (*!------------------------------------------------
         * set variable value by name. Alias to setVar()
         *-----------------------------------------------
         * @param varName name of variable
         * @param valueData value to be store
         *-----------------------------------------------*)
        procedure putVar(const varName : shortstring; const valueData :string);

        (*!------------------------------------------------
         * test if variable name is set
         *-----------------------------------------------
         * @param varName name of variable
         * @return boolean
         *-----------------------------------------------*)
        function has(const varName : shortstring) : boolean;

        (*!------------------------------------------------
         * return data as JSON string
         *-----------------------------------------------
         * @return JSON string
         *-----------------------------------------------*)
        function asJSON() : string;
    end;

implementation


    constructor TViewParametersAsJson.create(const viewParams : IViewParameters);
    begin
        fActualViewParameters := viewParams;
    end;

    (*!------------------------------------------------
     * get all registered variable name as array of string
     *-----------------------------------------------
     * @return instance of TStrings
     *-----------------------------------------------
     * Note: caller MUST not modify or destroy TStrings
     * instance and should read only
     *-----------------------------------------------*)
    function TViewParametersAsJson.asStrings() : TStrings;
    begin
        result := fActualViewParameters.asStrings();
    end;

    (*!------------------------------------------------
     * get variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @return value of variable
     *-----------------------------------------------*)
    function TViewParametersAsJson.getVar(const varName : shortstring) : string;
    begin
        result := fActualViewParameters.getVar(varName);
    end;

    (*!------------------------------------------------
     * set variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    function TViewParametersAsJson.setVar(
        const varName : shortstring;
        const valueData :string
    ) : IViewParameters;
    begin
        fActualViewParameters.setVar(varName, valueData);
        result := self;
    end;

    (*!------------------------------------------------
     * set variable value by name. Alias to setVar
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    procedure TViewParametersAsJson.putVar(
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
    function TViewParametersAsJson.has(const varName : shortstring) : boolean;
    begin
        result := fActualViewParameters.has(varName);
    end;

    (*!------------------------------------------------
     * return data as JSON string
     *-----------------------------------------------
     * @return JSON string
     *-----------------------------------------------*)
    function TViewParametersAsJson.asJSON() : string;
    var
    begin

    end;
end.
