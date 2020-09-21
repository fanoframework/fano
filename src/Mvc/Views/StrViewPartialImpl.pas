{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StrViewPartialImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf,
    ViewPartialIntf,
    TemplateParserIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * View partial that can render from a HTML string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStrViewPartial = class(TInjectableObject, IViewPartial)
    private
        templateParser : ITemplateParser;
        templateStr : string;
    public
        constructor create(
            const templateParserInst : ITemplateParser;
            const template : string
        );
        destructor destroy(); override;

        function partial(
            const templatePath : string;
            const viewParams : IViewParameters
        ) : string;
    end;

implementation

    constructor TStrViewPartial.create(
        const templateParserInst : ITemplateParser;
        const template : string
    );
    begin
        templateParser := templateParserInst;
        templateStr := template;
    end;

    destructor TStrViewPartial.destroy();
    begin
        templateParser := nil;
        inherited destroy();
    end;

    function TStrViewPartial.partial(
        const templatePath : string;
        const viewParams : IViewParameters
    ) : string;
    begin
        result := templateParser.parse(templateStr, viewParams);
    end;

end.
