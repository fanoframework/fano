{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullRegexImpl;

interface

{$MODE OBJFPC}
{$H+}

uses
    RegexIntf;

type

    (*!------------------------------------------------
     * IRegex implementation that does nothing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullRegex = class(TInterfacedObject, IRegex)
    private
    public
        function replace(
            const regexPattern : string;
            const source : string;
            const replacement : string
        ) : string;

        function quote(const regexPattern : string) : string;

        function match(
            const regexPattern : string;
            const source : string
        ) : TRegexMatchResult;

        function greedyMatch(
            const regexPattern : string;
            const source : string
        ) : TRegexMatchResult;
    end;

implementation

uses
    regexpr;

    function TNullRegex.replace(
        const regexPattern : string;
        const source : string;
        const replacement : string
    ) : string;
    begin
        result := source;
    end;

    function TNullRegex.quote(const regexPattern : string) : string;
    begin
        result := QuoteRegExprMetaChars(regexPattern);
    end;

    function TNullRegex.match(
        const regexPattern : string;
        const source : string
    ) : TRegexMatchResult;
    begin
        result := default(TRegexMatchResult);
    end;

    function TNullRegex.greedyMatch(
        const regexPattern : string;
        const source : string
    ) : TRegexMatchResult;
    begin
        result := default(TRegexMatchResult);
    end;
end.
