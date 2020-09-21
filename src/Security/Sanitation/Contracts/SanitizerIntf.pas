{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SanitizerIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * sanitize input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ISanitizer = interface
        ['{4E58C0BF-FD8C-48AC-AF77-B01A31B1CDC8}']

        (*!------------------------------------------------
         * sanitize input string
         *-------------------------------------------------
         * @param dataToSanitize input data to sanitize
         * @return sanitized output
         *-------------------------------------------------*)
        function sanitize(const dataToSanitize : string) : string;
    end;

implementation

end.
