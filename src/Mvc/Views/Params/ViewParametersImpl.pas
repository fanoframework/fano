{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewParametersImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    classes,
    contnrs,
    ViewParametersIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * class having capability to store view parameters
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TViewParameters = class(TInjectableObject, IViewParameters)
    private
        keyValueMap : TFPHashList;
        keys : TStringList;
        procedure clearVars();
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

uses

    EKeyNotFoundImpl;

resourcestring

    sKeyNotFound = 'View parameter %s not found.';

type

    TValue = record
        data : string;
    end;
    PValue = ^TValue;


    constructor TViewParameters.create();
    begin
        keyValueMap := TFPHashList.create();
        keys := TStringList.create();
    end;

    procedure TViewParameters.clearVars();
    var i :integer;
        param : PValue;
    begin
        for i:=keyValueMap.count-1 downto 0 do
        begin
            param := keyValueMap.find(keyValueMap.nameOfIndex(i));
            setlength(param^.data, 0);
            dispose(param);
            keyValueMap.delete(i);
        end;
    end;

    destructor TViewParameters.destroy();
    begin
        inherited destroy();
        clearVars();
        keyValueMap.free();
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
    function TViewParameters.asStrings() : TStrings;
    begin
        result := keys;
    end;

    (*!------------------------------------------------
     * get variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @return value of variable
     *-----------------------------------------------*)
    function TViewParameters.getVar(const varName : shortstring) : string;
    var param : PValue;
    begin
        param := keyValueMap.find(varName);
        if (param <> nil) then
        begin
            result := param^.data;
        end else
        begin
            raise EKeyNotFound.createFmt(sKeyNotFound, [varName]);
        end;
    end;

    (*!------------------------------------------------
     * set variable value by name
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    function TViewParameters.setVar(
        const varName : shortstring;
        const valueData :string
    ) : IViewParameters;
    var param : PValue;
    begin
        param := keyValueMap.find(varName);
        if (param = nil) then
        begin
            //not exists
            new(param);
            param^.data := valueData;
            keyValueMap.add(varName, param);
            keys.add(varName);
        end else
        begin
            param^.data := valueData;
        end;;
        result := self;
    end;

    (*!------------------------------------------------
     * set variable value by name. Alias to setVar
     *-----------------------------------------------
     * @param varName name of variable
     * @param valueData value to be store
     * @return current class instance
     *-----------------------------------------------*)
    procedure TViewParameters.putVar(
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
    function TViewParameters.has(const varName : shortstring) : boolean;
    begin
        result := (keyValueMap.find(varName) <> nil);
    end;
end.
