{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SimpleTemplateParserFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    BaseTemplateParserFactoryImpl;

type

    (*!------------------------------------------------
     * basic class that can create simple template parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSimpleTemplateParserFactory = class(TBaseTemplateParserFactory, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses
    SimpleTemplateParserImpl;

    function TSimpleTemplateParserFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        //replace any variable {{variableName}} with value
        result := TSimpleTemplateParser.create(
            openTag,
            closeTag
        );
    end;
end.
