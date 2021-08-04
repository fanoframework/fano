{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullSanitizerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SanitizerIntf;

type

    (*!------------------------------------------------
     * null class sanitizes nothing and returns input as is
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TNullSanitizer = class(TInterfacedObject, ISanitizer)
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

    (*!------------------------------------------------
     * sanitize input string
     *-------------------------------------------------
     * @param dataToSanitize input data to sanitize
     * @return sanitized output
     *-------------------------------------------------*)
    function TNullSanitizer.sanitize(const dataToSanitize : string) : string;
    begin
        result := dataToSanitize;
    end;

end.
