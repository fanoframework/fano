{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullViewParametersImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes,
    ViewParametersIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * dummy view parameters implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullViewParameters = class(TInjectableObject, IViewParameters)
    private
        keys : TStringList;
    public
        constructor create();
        destructor destroy(); override;

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
    end;

implementation


    constructor TNullViewParameters.create();
    begin
        keys := TStringList.create();
    end;

    destructor TNullViewParameters.destroy();
    begin
        inherited destroy();
        keys.free();
    end;

    (*!------------------------------------------------
     * get all registered variable name as array of string
     *-----------------------------------------------
     * @return instance of TStrings
     *-----------------------------------------------
     * Note: caller MUST not modify or destroy TStrings
     * instance and should read only
     *-----------------------------------------------*)
    function TNullViewParameters.asStrings() : TStrings;
    begin
        result := keys;
    end;

    (*!------------------------------------------------
     * get variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @return value of variable
     *-----------------------------------------------*)
    function TNullViewParameters.getVar(const varName : shortstring) : string;
    begin
        //intentionally does nothing and always return empty string
        result := '';
    end;

    (*!------------------------------------------------
     * set variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    function TNullViewParameters.setVar(
        const varName : shortstring;
        const valueData :string
    ) : IViewParameters;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * set variable value by name. Alias to setVar
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    procedure TNullViewParameters.putVar(
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
    function TNullViewParameters.has(const varName : shortstring) : boolean;
    begin
        //intentionally does nothing
        result := false;
    end;
end.
