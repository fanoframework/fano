{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdOutIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * interface for any classes having capability to
     * write string to standard output, e.g., system STDOUT,
     * FastCGI FCGI_STDOUT, etc.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStdOut = interface
        ['{CC7A9DCF-B0F2-46B9-89D2-9B7BD5075F73}']

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdOut;

        (*!------------------------------------------------
         * write string to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function write(const str : string) : IStdOut;

        (*!------------------------------------------------
         * write string with newline to stdout
         *-----------------------------------------------
         * @param str, string to write
         * @return current instance
         *-----------------------------------------------*)
        function writeln(const str : string) : IStdOut;
    end;

implementation

end.
