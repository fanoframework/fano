{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ResponseIntf,
    ViewParametersIntf,
    ViewIntf,
    TemplateParserIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * View that can render from a HTML template string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TView = class(TInjectableObject, IView)
    private

        (*!------------------------------------------------
         * original HTML template content
         *-----------------------------------------------*)
        templateContent : string;

        (*!------------------------------------------------
         * helper class that will parse template content
         * and replace variable placeholder with value
         *-----------------------------------------------*)
        templateParser : ITemplateParser;
    public

        (*!------------------------------------------------
         * constructor
         *------------------------------------------------
         * @param templateParserInst template variable parser
         * @param tplContent template content
         *-----------------------------------------------*)
        constructor create(
            const templateParserInst : ITemplateParser;
            const tplContent : string
        );

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

        (*!------------------------------------------------
         * render view
         *------------------------------------------------
         * @param viewParams view parameters
         * @param response response instance
         * @return response
         *-----------------------------------------------*)
        function render(
            const viewParams : IViewParameters;
            const response : IResponse
        ) : IResponse;

    end;

implementation

uses

    SysUtils,
    ResponseStreamIntf;

    (*!------------------------------------------------
     * constructor
     *------------------------------------------------
     * @param templateParserInst template variable parser
     * @param tplContent template content
     *-----------------------------------------------*)
    constructor TView.create(
        const templateParserInst : ITemplateParser;
        const tplContent : string
    );
    begin
        inherited create();
        templateParser := templateParserInst;
        templateContent := tplContent;
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TView.destroy();
    begin
        templateParser := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * render view
     *------------------------------------------------
     * @param viewParams view parameters
     * @param response response instance
     * @return response
     *-----------------------------------------------*)
    function TView.render(
        const viewParams : IViewParameters;
        const response : IResponse
    ) : IResponse;
    var bodyInst : IResponseStream;
        contentLength : string;
    begin
        bodyInst := response.body();
        bodyInst.write(templateParser.parse(templateContent, viewParams));
        contentLength := intToStr(bodyInst.size());
        response.headers().setHeader('Content-Length',  contentLength);
        result := response;
    end;
end.
