{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewPartialFactoryImpl;

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
     * View that can render from a HTML template file to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TViewPartialFactory = class(TFactory)
    private
        parser : ITemplateParser;
    public
        constructor create(const parserInst : ITemplateParser);
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

    ViewPartialImpl,
    StringFileReaderImpl;

    constructor TViewPartialFactory.create(const parserInst : ITemplateParser);
    begin
        parser := parserInst;
    end;

    destructor TViewPartialFactory.destroy();
    begin
        parser := nil;
        inherited destroy();
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TViewPartialFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TViewPartial.create(parser, TStringFileReader.create());
    end;

end.
