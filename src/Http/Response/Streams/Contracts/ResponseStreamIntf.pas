{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseStreamIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!----------------------------------------------
     * interface for any class having capability as
     * HTTP response body
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IResponseStream = interface(IStreamAdapter)
        ['{14394487-875D-4C4E-B4AE-9176B7393CAC}']

        (*!------------------------------------
         * write string to stream
         *-------------------------------------
         * @param buffer string to write
         * @return number of bytes actually written
         *-------------------------------------*)
        function write(const buffer : string) : int64; overload;

        (*!------------------------------------
         * read stream to string
         *-------------------------------------
         * @return string
         *-------------------------------------*)
        function read() : string; overload;
    end;

implementation

end.
