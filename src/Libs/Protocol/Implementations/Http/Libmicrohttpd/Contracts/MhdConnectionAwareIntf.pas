{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MhdConnectionAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    libmicrohttpd;

type

    (*!------------------------------------------------
     * interface for any class having capability to read
     * command line parameter options
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IMhdConnectionAware = interface
        ['{0F75A1AB-404A-4759-AEF0-FAC23CB03434}']

        (*!------------------------------------------------
         * get libmicrohttpd connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getConnection() : PMHD_Connection;

        (*!------------------------------------------------
         * set libmicrohttpd connection
         *-----------------------------------------------*)
        procedure setConnection(aconnection : PMHD_Connection);

        property connection : PMHD_Connection read getConnection write setConnection;
    end;

implementation

end.
