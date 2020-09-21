{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit BaseTemplateParserFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * base abstract class that can create template parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TBaseTemplateParserFactory = class(TFactory, IDependencyFactory)
    protected
        openTag : string;
        closeTag : string;
    public
        constructor create(
            const openTagStr : string = '{{';
            const closeTagStr : string = '}}'
        );
    end;

implementation

    constructor TBaseTemplateParserFactory.create(
        const openTagStr : string = '{{';
        const closeTagStr : string = '}}'
    );
    begin
        openTag := openTagStr;
        closeTag := closeTagStr;
    end;

end.
