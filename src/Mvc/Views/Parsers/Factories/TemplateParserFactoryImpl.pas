{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TemplateParserFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    BaseTemplateParserFactoryImpl;

type

    (*!------------------------------------------------
     * basic class that can create template parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TTemplateParserFactory = class(TBaseTemplateParserFactory, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses
    TemplateParserImpl,
    RegexImpl;

    function TTemplateParserFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        //replace any variable {{ variableName }} with value
        result := TTemplateParser.create(
            TRegex.create(),
            openTag,
            closeTag
        );
    end;
end.
