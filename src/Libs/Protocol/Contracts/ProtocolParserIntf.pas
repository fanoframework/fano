{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ProtocolParserIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to parse
     * protocol data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IProtocolParser = interface
        ['{B4950FD9-2E60-4E11-8A32-8802AB7244CB}']

        (*!------------------------------------------------
         * parse stream
         *-----------------------------------------------*)
        function parse(const stream : IStreamAdapter) : boolean;

        (*!------------------------------------------------
         * get POST data
         *-----------------------------------------------
         * @return IStreamAdapter instance
         *-----------------------------------------------*)
        function getStdIn() : IStreamAdapter;

        (*!------------------------------------------------
         * get environment variable from request
         *-----------------------------------------------
         * @return ICGIEnvironment instance
         *-----------------------------------------------*)
        function getEnv() : ICGIEnvironment;

        (*!------------------------------------------------
         * get total expected data in bytes in buffer
         *-----------------------------------------------
         * @return number of bytes
         *-----------------------------------------------*)
        function expectedSize(const stream : IStreamAdapter) : int64;
    end;

implementation

end.
