{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HtmlEntitiesSanitizerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SanitizerIntf;

type

    (*!------------------------------------------------
     * class which replace html special characters with its
     * corresponding html entities, for example < with &lt;
     * > with &gt; and so on.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THtmlEntitiesSanitizer = class(TInterfacedObject, ISanitizer)
    public

        (*!------------------------------------------------
         * sanitize input string with html entities
         *-------------------------------------------------
         * @param dataToSanitize input data to sanitize
         * @return sanitized output
         *-------------------------------------------------*)
        function sanitize(const dataToSanitize : string) : string;
    end;

implementation

uses

    SysUtils;

    (*!------------------------------------------------
     * sanitize input string with html entities
     *-------------------------------------------------
     * @param dataToSanitize input data to sanitize
     * @return sanitized output
     *-------------------------------------------------*)
    function THtmlEntitiesSanitizer.sanitize(const dataToSanitize : string) : string;
    begin
        result := StringReplace(dataToSanitize, '<', '&lt;', [rfReplaceAll]);
        result := StringReplace(result, '>', '&gt;', [rfReplaceAll]);
        result := StringReplace(result, '&', '&amp;', [rfReplaceAll]);
        result := StringReplace(result, '"', '&quot;', [rfReplaceAll]);
        result := StringReplace(result, '''', '&apos;', [rfReplaceAll]);
    end;

end.
