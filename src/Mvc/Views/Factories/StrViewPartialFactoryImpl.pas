{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StrViewPartialFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    ViewParametersIntf,
    ViewPartialIntf,
    TemplateParserIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * View that can render from a HTML template string to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStrViewPartialFactory = class(TFactory)
    private
        parser : ITemplateParser;
        fTemplatePath : string;
    public
        constructor create(
            const parserInst : ITemplateParser;
            const templatePath : string
        );
        destructor destroy(); override;

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    FileReaderIntf,
    StrViewPartialImpl,
    StringFileReaderImpl;

    constructor TStrViewPartialFactory.create(
        const parserInst : ITemplateParser;
        const templatePath : string
    );
    begin
        parser := parserInst;
        fTemplatePath := templatePath
    end;

    destructor TStrViewPartialFactory.destroy();
    begin
        parser := nil;
        inherited destroy();
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TStrViewPartialFactory.build(const container : IDependencyContainer) : IDependency;
    var fReader : IFileReader;
    begin
        fReader := TStringFileReader.create();
        result := TStrViewPartial.create(
            parser,
            fReader.readFile(fTemplatePath)
        );
    end;

end.
