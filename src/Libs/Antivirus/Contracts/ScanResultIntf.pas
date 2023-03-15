{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScanResultIntf;

interface

{$MODE OBJFPC}
{$H+}


type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * report antivirus scan result
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IScanResult = interface
        ['{214B66BE-0795-4F2C-9623-AD595288DC1F}']

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

end.
