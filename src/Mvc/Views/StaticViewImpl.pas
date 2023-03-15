{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StaticViewImpl;

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
     * View that can render static a HTML template string
     * No variable replacement is performed
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStaticView = class(TInjectableObject, IView)
    private
        (*!------------------------------------------------
         * original HTML template content
         *-----------------------------------------------*)
        fHtml : string;
    public

        (*!------------------------------------------------
         * constructor
         *------------------------------------------------
         * @param tplContent template content
         *-----------------------------------------------*)
        constructor create(const html : string);

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
     * @param html template content
     *-----------------------------------------------*)
    constructor TStaticView.create(const html : string);
    begin
        fHtml := html;
    end;

    (*!------------------------------------------------
     * render view
     *------------------------------------------------
     * @param viewParams view parameters
     * @param response response instance
     * @return response
     *-----------------------------------------------*)
    function TStaticView.render(
        const viewParams : IViewParameters;
        const response : IResponse
    ) : IResponse;
    var bodyInst : IResponseStream;
    begin
        bodyInst := response.body();
        bodyInst.write(fHtml);
        response.headers().setHeader('Content-Length',  intToStr(bodyInst.size()));
        result := response;
    end;
end.
