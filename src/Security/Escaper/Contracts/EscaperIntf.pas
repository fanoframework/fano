{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EscaperIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * escape string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IEscaper = interface
        ['{B20202DD-05D0-4E98-914F-F56967CCF289}']

        (*!------------------------------------------------
         * escape string
         *-------------------------------------------------
         * @param inputStr
         * @return escaped string
         *-------------------------------------------------*)
        function escape(const inputStr : string) : string;
    end;

implementation

end.
