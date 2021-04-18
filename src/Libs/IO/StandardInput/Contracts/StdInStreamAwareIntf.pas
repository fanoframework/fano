{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdInStreamAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability return
     * StdIn stream

     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStdInStreamAware = interface
        ['{E7AA86D2-940B-47F3-9922-4F1F663FDFB6}']

        (*!------------------------------------------------
         * get StdIn stream
         *-----------------------------------------------
         * @return stdIn stream, stream contains parsed POST-ed data
         *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter;

    end;

implementation

end.
