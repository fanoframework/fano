{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AntivirusIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ScanResultIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * scan for computer virus
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IAntivirus = interface
        ['{64EEC494-9B6A-4494-9466-9A58AF82C860}']

        (*!------------------------------------------------
         * setup antivirus engine
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function beginScan() : IAntivirus;

        (*!------------------------------------------------
         * scan file for virus
         *-----------------------------------------------
         * @return scan result
         *-----------------------------------------------*)
        function scanFile(const filePath : string) : IScanResult;

        (*!------------------------------------------------
         * free antivirus engine resources
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function endScan() : IAntivirus;
    end;

implementation

end.
