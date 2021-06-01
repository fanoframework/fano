{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewStackImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    ViewParametersIntf,
    ViewStackIntf,
    ViewPushIntf,
    TemplateParserIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * View that can render from stacked template string
     *-------------------------------------------------
     * This is inspired by Laravel Blade @stack @push directive
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TViewStack = class(TInjectableObject, IViewStack, IViewPush)
    private
        fTemplateParser : ITemplateParser;
        fTemplateStack : TStrings;
        function getStringsByName(const stackName : string) : TStrings;
    public
        constructor create(const templateParserInst : ITemplateParser);
        destructor destroy(); override;

        (*!------------------------------------------------
         * clear all stacked template
         *-----------------------------------------------
         * @param stackName name of stack to clear. if
         *        empty, all will be clear
         *-----------------------------------------------*)
        procedure clear(const stackName : string = '');

        (*!------------------------------------------------
         * concat all templates and rendered them as string
         *-----------------------------------------------
         * @param viewParams instance contains view parameters
         * @return string which all variables replaced with value from
         *        view parameters
         *-----------------------------------------------*)
        function stack(
            const stackName : string;
            const viewParams : IViewParameters
        ) : string;

        (*!------------------------------------------------
         * get instance of IViewPush related to this
         *-----------------------------------------------
         * @return IViewPush instance
         *-----------------------------------------------*)
        function getPusher() : IViewPush;

        (*!------------------------------------------------
         * push template string
         *-----------------------------------------------
         * @param stackName name of stack
         * @param tpl template string
         * @return current instance
         *-----------------------------------------------*)
        function push(const stackName : string; const tpl : string) : IViewPush;

    end;

implementation

uses

    sysutils;

    constructor TViewStack.create(const templateParserInst : ITemplateParser);
    var strList : TStringList;
    begin
        fTemplateParser := templateParserInst;

        //make sorted list so that find by name fast
        strList:= TStringList.create();
        strList.sorted := true;

        fTemplateStack := strList;
    end;

    destructor TViewStack.destroy();
    begin
        clear();
        fTemplateStack.free();
        fTemplateParser := nil;
        inherited destroy();
    end;

    function TViewStack.getStringsByName(const stackName : string) : TStrings;
    const NOT_FOUND = -1;
    var idx : integer;
    begin
        idx := fTemplateStack.indexOf(stackName);
        if (idx = NOT_FOUND) then
        begin
            result := nil;
        end else
        begin
            result := TStrings(fTemplateStack.Objects[idx]);
        end;
    end;

    (*!------------------------------------------------
     * clear all stacked template
     *-----------------------------------------------
     * @param stackName name of stack to clear. if
     *        empty, all will be clear
     *-----------------------------------------------*)
    procedure TViewStack.clear(const stackName : string = '');
    var i : integer;
        strs : TStrings;
    begin
        if stackName = '' then
        begin
            for i := 0 to fTemplateStack.count-1 do
            begin
                fTemplateStack.objects[i].free();
            end;
            fTemplateStack.clear();
        end else
        begin
            strs := getStringsByName(stackName);
            if assigned(strs) then
            begin
                strs.clear();
            end;
        end;
    end;

    (*!------------------------------------------------
     * concat all templates and rendered them as string
     *-----------------------------------------------
     * @param stackName name of stack
     * @param viewParams instance contains view parameters
     * @return string which all variables replaced with value from
     *        view parameters
     *-----------------------------------------------*)
    function TViewStack.stack(
        const stackName : string;
        const viewParams : IViewParameters
    ) : string;
    var strs : TStrings;
    begin
        strs := getStringsByName(stackName);
        if assigned(strs) then
        begin
            result := fTemplateParser.parse(strs.text, viewParams);
        end else
        begin
            result := '';
        end;
    end;

    (*!------------------------------------------------
     * get instance of IViewPush related to this
     *-----------------------------------------------
     * @return IViewPush instance
     *-----------------------------------------------*)
    function TViewStack.getPusher() : IViewPush;
    begin
        result := self;
    end;

    (*!------------------------------------------------
     * push template string to stack identified by name
     *-----------------------------------------------
     * @param stackName name of stack
     * @return current instance
     *-----------------------------------------------*)
    function TViewStack.push(const stackName : string; const tpl : string) : IViewPush;
    var strs : TStrings;
    begin
        strs := getStringsByName(stackName);
        if assigned(strs) then
        begin
            strs.add(tpl);
        end else
        begin
            //stack not created yet, add one
            strs := TStringList.create();
            strs.add(tpl);
            fTemplateStack.addObject(stackName, strs);
        end;
        result := self;
    end;
end.
