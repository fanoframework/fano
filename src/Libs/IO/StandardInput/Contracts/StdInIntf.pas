{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdInIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!------------------------------------------------
     * interface for any classes having capability to
     * read standard input to string,, e.g., system STDIN,
     * FastCGI FCGI_STDIN, etc.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStdIn = interface
        ['{D2806A1E-54D6-4830-A833-95A78ACE2F29}']

        (*!------------------------------------------------
         * set stream to write to if any
         *-----------------------------------------------
         * @param stream, stream to write to
         * @return current instance
         *-----------------------------------------------*)
        function setStream(const astream : IStreamAdapter) : IStdIn;

        function readStdIn(const contentLength : int64) : string;
    end;

implementation

end.
