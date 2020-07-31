{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RegexImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RegexIntf,
    regexpr;

type

    (*!------------------------------------------------
     * basic class having capability to replace string
     * using regex
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TRegex = class(TInterfacedObject, IRegex)
    private
        function getMatchesResult(
            const indx : integer;
            const res : TRegexMatchResult;
            const re :TRegExpr
        ) : TRegexMatchResult;
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
    classes;

    {*!--------------------------------
     * Replace string regex pattern
     * --------------------------------
     * @param regexPattern regex pattern
     * @param source original string
     * @param replacement string to be used to replace
     * @return replaced string
     *----------------------------------*}
    function TRegex.replace(
        const regexPattern : string;
        const source : string;
        const replacement : string
    ) : string;
    begin
        result := ReplaceRegExpr(
            regexPattern,
            source,
            replacement,
            true
        );
    end;

    function TRegex.quote(const regexPattern : string) : string;
    begin
        result := QuoteRegExprMetaChars(regexPattern);
    end;

    {*!--------------------------------
     * Build regex matches result as
     * multi dimensional array
     * --------------------------------
     * @param indx current index
     * @param res match results
     * @param re regex expression class
     * @return modified match results
     *----------------------------------*}
    function TRegex.getMatchesResult(
        const indx : integer;
        const res : TRegexMatchResult;
        const re :TRegExpr
    ) : TRegexMatchResult;
    var i, subExprCount : integer;
    begin
        subExprCount := re.SubExprMatchCount;
        if (subExprCount > 0) then
        begin
            setLength(res.matches[indx], 1 + subExprCount);
            for i:= 0 to subExprCount do
            begin
                res.matches[indx][i] := re.match[i];
            end;
        end else
        begin
            setLength(res.matches[indx], 1);
            res.matches[indx][0] := re.match[0];
        end;
        result := res;
    end;

    function TRegex.match(
        const regexPattern : string;
        const source : string
    ) : TRegexMatchResult;
    var re : TRegExpr;
    begin
        result := default(TRegexMatchResult);
        re := TRegExpr.create(regexPattern);
        try
            setLength(result.matches, 0);
            result.matched := re.exec(source);
            if (result.matched) then
            begin
                setlength(result.matches, 1);
                result := getMatchesResult(0, result, re);
            end;
        finally
            re.free();
        end;
    end;

    function TRegex.greedyMatch(
        const regexPattern : string;
        const source : string
    ) : TRegexMatchResult;
    const MAX_ELEMENT = 100;
    var re : TRegExpr;
        actualElement : integer;
    begin
        result := default(TRegexMatchResult);
        re := TRegExpr.create(regexPattern);
        try
            re.modifierG := true;
            //assume no match
            setLength(result.matches, 0);
            result.matched := re.exec(source);
            if (result.matched) then
            begin
                //pre-allocated element, to avoid frequent
                //memory allocation/deallocation
                setLength(result.matches, MAX_ELEMENT);
                actualElement := 1;
                result := getMatchesResult(0, result, re);
                while (re.execNext()) do
                begin
                    if (actualElement < MAX_ELEMENT) then
                    begin
                        result := getMatchesResult(actualElement, result, re);
                    end else
                    begin
                        //grow array
                        setLength(
                            result.matches,
                            length(result.matches) + MAX_ELEMENT
                        );
                        result := getMatchesResult(actualElement, result, re);
                    end;
                    inc(actualElement);
                end;
                //truncate array to number of actual element
                setLength(result.matches, actualElement);
            end;
        finally
            re.free();
        end;
    end;
end.
