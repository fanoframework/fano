{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StripTagsSanitizerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SanitizerIntf,
    RegexIntf;

type

    (*!------------------------------------------------
     * class sanitizes by removing html tags
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TStripTagsSanitizer = class(TInterfacedObject, ISanitizer)
    private
        fRegex : IRegex;
        fAllowedTags : array of string;
    public
        constructor create(const regex : IRegex; const allowedTags : array of string);
        destructor destroy(); override;

        (*!------------------------------------------------
         * sanitize input string with html entities
         *-------------------------------------------------
         * @param dataToSanitize input data to sanitize
         * @return sanitized output
         *-------------------------------------------------*)
        function sanitize(const dataToSanitize : string) : string;
    end;

implementation

    constructor TStripTagsSanitizer.create(const regex : IRegex; const allowedTags : array of string);
    var i : integer;
    begin
        fRegex := regex;
        setLength(fAllowedTags, length(allowedTags));
        for i := 0 to length(fAllowedTags) - 1 do
        begin
            fAllowedTags[i] := allowedTags[i];
        end;
    end;

    destructor TStripTagsSanitizer.destroy();
    begin
        fRegex := nil;
        fAllowedTags := nil;
        inherited destroy();
    end;

    (*!------------------------------------------------
     * sanitize input string
     *-------------------------------------------------
     * @param dataToSanitize input data to sanitize
     * @return sanitized output
     *-------------------------------------------------*)
    function TStripTagsSanitizer.sanitize(const dataToSanitize : string) : string;
    const
        tagPattern = '/<\/?([a-z0-9]*)\b[^>]*>?/';
        commentPattern = '/<!--[\s\S]*?-->/';
    var afterStr, beforeStr : string;
    begin
        afterStr := dataToSanitize;
        while true do
        begin
            beforeStr := afterStr;
            afterStr := fRegex.replaceEx(commentPattern, afterStr, '', 'gi');
            afterStr := fRegex.replaceEx(tagPattern, afterStr, '', 'gi');

            // return once no more tags are removed
            if (beforeStr = afterStr) then
            begin
                break;
            end;
        end;
        result := afterStr;
    end;

end.
