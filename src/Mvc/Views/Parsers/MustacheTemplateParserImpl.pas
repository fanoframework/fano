{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MustacheTemplateParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf,
    TemplateParserIntf,
    RegexIntf,
    InjectableObjectImpl,
    mustache;

type

    (*!------------------------------------------------
     * basic class that can parse template and replace
     * variable placeholder with value
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TMustacheTemplateParser = class(TInjectableObject, ITemplateParser)
    private
        fMustache : TMustache;
    public
        constructor create();
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

    Classes,
    JsonIntf;

    constructor TMustacheTemplateParser.create();
    begin
        fMustache := TMustache.create(nil)
    end;

    destructor TMustacheTemplateParser.destroy();
    begin
        fMustache.free();
        inherited destroy();
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
    function TMustacheTemplateParser.parse(
        const templateStr : string;
        const viewParams : IViewParameters
    ) : string;
    var jsonStr : IJson;
    begin
        jsonStr := TViewParametersAsJson.create(viewParams);
        try
            result := fMustache.render(templateStr, jsonStr.asJson);
        finally
            jsonStr := nil;
        end;
    end;
end.


