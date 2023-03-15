{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullTemplateParserImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf,
    TemplateParserIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic class that implements ITemplateParser
     * that does nothing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullTemplateParser = class(TInjectableObject, ITemplateParser)
    public

        (*!---------------------------------------------------
         * replace template content with view parameters
         * ----------------------------------------------------
         * @param templateStr string contain content of template
         * @param viewParams view parameters instance
         * @return replaced content
         *-----------------------------------------------------*)
        function parse(
            const templateStr : string;
            const viewParams : IViewParameters
        ) : string;
    end;

implementation


    (*!---------------------------------------------------
     * replace template content with view parameters
     * ----------------------------------------------------
     * @param templateStr string contain content of template
     * @param viewParams view parameters instance
     * @return replaced content
     *-----------------------------------------------------*)
    function TNullTemplateParser.parse(
        const templateStr : string;
        const viewParams : IViewParameters
    ) : string;
    begin
        //intentionally does nothing
        result := templateStr;
    end;
end.
