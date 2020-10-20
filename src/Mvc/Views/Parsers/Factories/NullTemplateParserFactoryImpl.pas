{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullTemplateParserFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    BaseTemplateParserFactoryImpl;

type

    (*!------------------------------------------------
     * basic class that can create null template parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullTemplateParserFactory = class(TBaseTemplateParserFactory, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    NullTemplateParserImpl;

    function TNullTemplateParserFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        //replace nothing
        result := TNullTemplateParser.create();
    end;
end.
