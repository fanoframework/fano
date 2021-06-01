{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit GetOptsParamsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    getopts,
    Classes,
    CliParamsIntf,
    CliParamsFactoryIntf;

type

    (*!------------------------------------------------
     * basic class having capability to read
     * command line parameter options using getopt()
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TGetOptsParams = class(TInterfacedObject, ICliParams, ICliParamsFactory)
    private
        fOptions : TStringList;
        fOpts : array of TOption;
        fOptCount : integer;
        procedure buildOptions();
    public
        constructor create();
        destructor destroy(); override;

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

uses

    SysUtils,
    ECliParamsImpl;

    constructor TGetOptsParams.create();
    begin
        fOptions := TStringList.create();
        setLength(fOpts, 10);
        fOptCount := 0;
    end;

    destructor TGetOptsParams.destroy();
    begin
        fOptions.free();
        setLength(fOpts, 0);
        fOpts := nil;
        fOptCount := 0;
        inherited destroy();
    end;

    procedure TGetOptsParams.buildOptions();
    var c : char;
        optionIndex : longint;
    begin
        c:=#0;
        repeat
            //shortopts must not empty string, otherwise access violation
            //we do not use short option. Here we just use space.
            //see https://bugs.freepascal.org/view.php?id=37233
            c := getLongOpts(' ', @fOpts[0], optionIndex);
            if c = #0 then
            begin
                //optionIndex will be start from 1 instead of zero
                if (fOpts[optionIndex - 1].has_arg > 0) then
                begin
                    fOptions.add(fOpts[optionIndex - 1].name + '=' + optarg);
                end else
                begin
                    fOptions.add(fOpts[optionIndex - 1].name);
                end;
            end;
            if (c = '?') or (c = ':') then
            begin
                raise ECliParams.createFmt('Error with option %s', [optopt]);
            end;
        until c = EndOfOptions;
    end;

    (*!------------------------------------------------
     * get option from command line parameters
     *-----------------------------------------------
     * @param opt option
     * @return value
     *-----------------------------------------------*)
    function TGetOptsParams.getOption(const opt : string; const defValue : string) : string;
    var indx : integer;
    begin
        indx := fOptions.indexOfName(opt);
        if indx > -1 then
        begin
            result := fOptions.valueFromIndex[indx];
        end else
        begin
            result := defValue;
        end;
    end;

    (*!------------------------------------------------
     * get option from command line parameters as integer
     *-----------------------------------------------
     * @param opt option
     * @return value
     *-----------------------------------------------*)
    function TGetOptsParams.getOption(const opt : string; const defValue : integer) : integer;
    var indx : integer;
    begin
        indx := fOptions.indexOfName(opt);
        if indx > -1 then
        begin
            result := strToInt(fOptions.valueFromIndex[indx]);
        end else
        begin
            result := defValue;
        end;
    end;

    (*!------------------------------------------------
     * get option from command line parameters as word
     *-----------------------------------------------
     * @param opt option
     * @return value
     *-----------------------------------------------*)
    function TGetOptsParams.getOption(const opt : string; const defValue : word) : word;
    var indx : integer;
    begin
        indx := fOptions.indexOfName(opt);
        if indx > -1 then
        begin
            result := word(strToInt(fOptions.valueFromIndex[indx]));
        end else
        begin
            result := defValue;
        end;
    end;

    (*!------------------------------------------------
     * get option from command line parameters as boolean
     *-----------------------------------------------
     * @param opt option
     * @return value
     *-----------------------------------------------*)
    function TGetOptsParams.getOption(const opt : string; const defValue : boolean) : boolean;
    var indx : integer;
    begin
        indx := fOptions.indexOfName(opt);
        if indx > -1 then
        begin
            result := strToBool(fOptions.valueFromIndex[indx]);
        end else
        begin
            result := defValue;
        end;
    end;

    (*!------------------------------------------------
     * test if option is set
     *-----------------------------------------------
     * @param opt option
     * @return boolean
     *-----------------------------------------------*)
    function TGetOptsParams.hasOption(const opt : string) : boolean;
    begin
        result := (fOptions.indexOfName(opt) > -1);
    end;

    (*!------------------------------------------------
     * add option
     *-----------------------------------------------
     * @param aName option name
     * @param hasArg flag if option has argument
     * @param aFlag flag if option has argument
     * @param aValue short option
     * @return current instance
     *-----------------------------------------------*)
    function TGetOptsParams.addOption(
        const aName : string;
        const hasArg: integer = 0;
        const aFlag : pchar = nil;
        const aValue: char = #0
    ) : ICliParamsFactory;
    var currLen : integer;
    begin
        currLen := length(fOpts);
        if (fOptCount = currLen) then
        begin
            setLength(fOpts, currLen + 10);
        end;
        with fOpts[fOptCount] do
        begin
            name := aName;
            has_arg := hasArg;
            flag := aFlag;
            value := aValue;
        end;
        inc(fOptCount);
        result := self;
    end;

    function TGetOptsParams.build() : ICliParams;
    var currLen : integer;
    begin
        currLen := length(fOpts);
        if (fOptCount < currLen) then
        begin
            setLength(fOpts, fOptCount);
        end;
        buildOptions();
        result := self;
    end;
end.
