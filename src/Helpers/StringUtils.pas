{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StringUtils;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils;

    (*!------------------------------------------------
     * string utilities function collection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)

    (*!------------------------------------------------
     * join array of string with a delimiter
     *-----------------------------------------------
     * @param delimiter string to separate each
     * @param values array of string to join
     *-----------------------------------------------*)
    function join(const delimiter : string; const values : array of string) : string;

    (*!------------------------------------------------
     * convert array of string to TStringArray
     *-----------------------------------------------
     * @param values array of string to convert
     *-----------------------------------------------*)
    function toStringArray(const values : array of string) : TStringArray;

    (*!------------------------------------------------
     * generate slug
     *-----------------------------------------------
     * @param originalStr input string
     * @return slug
     *-----------------------------------------------*)
    function slug(const originalStr : string) : string;

implementation

uses

    regexpr;

    (*!------------------------------------------------
     * join array of string with a delimiter
     *-----------------------------------------------
     * @param delimiter string to separate each
     * @param values array of string to join
     *-----------------------------------------------*)
    function join(const delimiter : string; const values : array of string) : string;
    var
        i, tot : integer;
    begin
        tot := high(values) - low(values) + 1;
        result := '';
        for i := 0 to tot-2 do
        begin
            //TODO: improve as this is cause many memory reallocation
            result := result + values[i] + delimiter;
        end;
        result := result + values[tot-1];
    end;

    (*!------------------------------------------------
     * convert array of string to TStringArray
     *-----------------------------------------------
     * @param values array of string to convert
     *-----------------------------------------------*)
    function toStringArray(const values : array of string) : TStringArray;
    var i, len : integer;
    begin
        result := default(TStringArray);
        len := high(values) - low(values) + 1;
        setLength(result, len);
        for i := 0 to len -1 do
        begin
            result[i] := values[i];
        end;
    end;

    (*!------------------------------------------------
     * generate slug
     *-----------------------------------------------
     * replace string 'test hei$#@slug to Slug 10' to
     * 'test-hei-slug-to-slug-10'
     *-----------------------------------------------
     * @param originalStr input string
     * @return slug
     *-----------------------------------------------*)
    function slug(const originalStr : string) : string;
    begin
        result := ReplaceRegExpr('[\W\s]+', lowercase(trim(originalStr)), '-', true);
    end;
end.
