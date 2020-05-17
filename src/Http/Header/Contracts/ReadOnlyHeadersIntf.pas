{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ReadOnlyHeadersIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    CloneableIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * read HTTP headers
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IReadOnlyHeaders = interface(ICloneable)
        ['{D709619D-84D4-4F89-A993-7988D167376D}']

        (*!------------------------------------
         * get http header
         *-------------------------------------
         * @param key name  of http header to get
         * @return header value
         * @throws EHeaderNotSet
         *-------------------------------------*)
        function getHeader(const key : shortstring) : string;
        property values[const key : shortString] : string read getHeader; default;

        (*!------------------------------------
         * test if http header already been set
         *-------------------------------------
         * @param key name  of http header to test
         * @return boolean true if header is set
         *-------------------------------------*)
        function has(const key : shortstring) : boolean;
    end;

implementation
end.
