{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RegexIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    TRegexMatches = array of array of string;
    TRegexMatchResult = record
        matched : boolean;
        matches : TRegexMatches;
    end;

    (*!------------------------------------------------
     * interface for any class having capability to replace string
     * using regex
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IRegex = interface
        ['{E08AD12B-C606-48FF-A9FA-728EAB14AB35}']
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
end.
