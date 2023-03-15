{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
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

    (*!------------------------------------------------
     * explode string by delimiter as array of string
     *-----------------------------------------------
     * @param cDelimiter string to separate each
     * @param sValues string to explode
     * @param iCount max number string to return, 0 means find all string.
     * @return array of string
     *------------------------------------------------
     * @credit https://www.matthewhipkin.co.uk/codelib/cgi-mailform-using-freepascal/
     * @credit http://www.jasonwhite.co.uk/delphi-explode-function-like-php-explode/
     *-----------------------------------------------*)
    function explode(const cDelimiter,  sValue : string; iCount : integer = 0) : TStringArray;

implementation

uses

    regexpr,
    strutils;

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
        result := trim(originalStr);
        if (result = '') then
        begin
            exit;
        end;

        //bugfix for FPC 3.0.4 which does not support \W
        {$IF FPC_FULLVERSION > 30004}
            result := ReplaceRegExpr('[\W\s]+', lowercase(result), '-', true);
        {$ELSE}
            result := ReplaceRegExpr(
                '[~!@#$%^&*()_\-+={}\[\]|\\:;"''<>,.?/\s]+',
                lowercase(result),
                '-',
                true
            );
        {$ENDIF}

        // remove - from beginning if any
        if pos('-', result) = 1 then
        begin
            result := copy(result, 2, length(result) - 1);
        end;

        // remove - from end if any
        if rpos('-', result) = length(result) then
        begin
            result := copy(result, 1, length(result) - 1);
        end;
    end;

    (*!------------------------------------------------
     * explode string by delimiter as array of string
     *-----------------------------------------------
     * @param cDelimiter string to separate each
     * @param sValues string to explode
     * @param iCount max number string to return, 0 means find all string.
     * @return array of string
     *------------------------------------------------
     * @credit https://www.matthewhipkin.co.uk/codelib/cgi-mailform-using-freepascal/
     * @credit http://www.jasonwhite.co.uk/delphi-explode-function-like-php-explode/
     *-----------------------------------------------*)
    function explode(const cDelimiter,  sValue : string; iCount : integer = 0) : TStringArray;
    var
        s : string;
        i, p: integer;
    begin
        s := sValue;
        i := 0;
        result := nil;
        while length(s) > 0 do
        begin
            inc(i);
            SetLength(result, i);
            p := pos(cDelimiter, s);
            if (p > 0) and ((i < iCount) or (iCount=0)) then
            begin
                result[i-1] := copy(s, 0, p-1);
                s := copy(s, p + length(cDelimiter), length(s));
            end else
            begin
                result[i-1] := s;
                s := '';
            end;
        end;
    end;
end.
