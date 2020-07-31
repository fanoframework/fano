{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdErrIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StdOutIntf;

type

    (*!------------------------------------------------
     * interface for any classes having capability to
     * write string to standard error, e.g., system STDERR,
     * FastCGI FCGI_STDERR, etc.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStdErr = interface(IStdOut)
        ['{7BFD7E4B-5078-4EA7-B816-5D4531B5AEF1}']
    end;

implementation

end.
