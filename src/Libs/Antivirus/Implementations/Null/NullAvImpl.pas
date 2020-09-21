{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullAvImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AntivirusIntf,
    ScanResultIntf;

type

    (*!-----------------------------------------------
     * dummy class having capability to scan file for computer virus.
     * This is to disable antivirus validation in form file upload
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullAv = class(TInterfacedObject, IAntivirus, IScanResult)
    public
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

        (*!------------------------------------------------
         * test if the last scan is cleaned
         *-----------------------------------------------
         * @return true if cleaned
         *-----------------------------------------------*)
        function isCleaned() : boolean;

        (*!------------------------------------------------
         * return name of virus if virus detected
         *------------------------------------------------
         * @return name of virus or empty string if clean
         *-----------------------------------------------*)
        function virusName() : string;

    end;

implementation


    (*!------------------------------------------------
     * setup antivirus engine
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TNullAv.beginScan() : IAntivirus;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * free antivirus engine resources
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TNullAv.endScan() : IAntivirus;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * scan file for virus
     *-----------------------------------------------
     * @return scan result
     *-----------------------------------------------*)
    function TNullAv.scanFile(const filePath : string) : IScanResult;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * test if the last scan is cleaned
     *-----------------------------------------------
     * @return true if cleaned
     *-----------------------------------------------*)
    function TNullAv.isCleaned() : boolean;
    begin
        //intentionally does nothing and always assumed cleaned
        result := true;
    end;

    (*!------------------------------------------------
     * return name of virus if virus detected
     *------------------------------------------------
     * @return name of virus or empty string if clean
     *-----------------------------------------------*)
    function TNullAv.virusName() : string;
    begin
        result := '';
    end;

end.
