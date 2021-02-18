{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewPartialImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf,
    ViewPartialIntf,
    TemplateParserIntf,
    FileReaderIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * View that can render from a HTML template to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TViewPartial = class(TInjectableObject, IViewPartial)
    private
        templateParser : ITemplateParser;
        fileReader : IFileReader;
    public
        constructor create(
            const templateParserInst : ITemplateParser;
            const fileReaderInst : IFileReader
        );
        destructor destroy(); override;

        function partial(
            const templatePath : string;
            const viewParams : IViewParameters
        ) : string;
    end;

implementation

uses
    classes,
    sysutils;

    constructor TViewPartial.create(
        const templateParserInst : ITemplateParser;
        const fileReaderInst : IFileReader
    );
    begin
        templateParser := templateParserInst;
        fileReader := fileReaderInst;
    end;

    destructor TViewPartial.destroy();
    begin
        fileReader := nil;
        templateParser := nil;
        inherited destroy();
    end;

    function TViewPartial.partial(
        const templatePath : string;
        const viewParams : IViewParameters
    ) : string;
    begin
        result := templateParser.parse(
            fileReader.readFile(templatePath),
            viewParams
        );
    end;

end.
