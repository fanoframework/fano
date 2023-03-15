{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TemplateParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf,
    TemplateParserIntf,
    RegexIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class that can parse template and replace
     * variable placeholder with value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TTemplateParser = class(TInjectableObject, ITemplateParser)
    private
        regex : IRegex;
        openTag: string;
        closeTag : string;
    public
        constructor create(
            const regexInst : IRegex;
            const openTagStr : string;
            const closeTagStr : string
        );
        destructor destroy(); override;

        (*!---------------------------------------------------
         * replace template content with view parameters
         * ----------------------------------------------------
         * @param templateStr string contain content of template
         * @param viewParams view parameters instance
         * @return replaced content
         *-----------------------------------------------------*)
        function parse(
            const templateStr : string;
            const viewParams : IViewParameters
        ) : string;
    end;

implementation

uses
    classes;

    constructor TTemplateParser.create(
        const regexInst : IRegex;
        const openTagStr : string;
        const closeTagStr : string
    );
    begin
        regex := regexInst;
        openTag := regex.quote(openTagStr);
        closeTag := regex.quote(closeTagStr);
    end;

    destructor TTemplateParser.destroy();
    begin
        inherited destroy();
        regex := nil;
    end;

    (*!---------------------------------------------------
     * replace template content with view parameters
     * ----------------------------------------------------
     * @param templateStr string contain content of template
     * @param viewParams view parameters instance
     * @return replaced content
     * ----------------------------------------------------
     * if opentag='{{' and close tag='}}'' and view parameters
     * contain key='name' with value='joko'
     * then for template content 'hello {{ name }}'
     * output will be  'hello joko'
     * pattern {{name}} {{ name }} {{   name   }} are considered
     * same
     *-----------------------------------------------------*)
    function TTemplateParser.parse(
        const templateStr : string;
        const viewParams : IViewParameters
    ) : string;
    var keys : TStrings;
        i:integer;
        pattern, valueData : string;
    begin
        result := templateStr;
        keys := viewParams.asStrings();
        //TODO: improve by collecting keys and replace all keys in one go
        for i := 0 to keys.count-1 do
        begin
            //if openTag is {{ and closeTag is }} then we
            //build pattern such as \{\{\s*variableName\s*\}\}
            pattern := openTag + '\s*' + keys[i] + '\s*' + closeTag;
            valueData := viewParams.getVar(keys[i]);
            result := regex.replace(pattern, result, valueData);
        end;
    end;
end.
