{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewStackFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    ViewParametersIntf,
    ViewStackIntf,
    TemplateParserIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * Factory class for IViewStack and IViewPush
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TViewStackFactory = class(TFactory)
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

    ViewStackImpl;

    constructor TViewStackFactory.create(const parserInst : ITemplateParser);
    begin
        parser := parserInst;
    end;

    destructor TViewStackFactory.destroy();
    begin
        parser := nil;
        inherited destroy();
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TViewStackFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TViewStack.create(parser);
    end;

end.
