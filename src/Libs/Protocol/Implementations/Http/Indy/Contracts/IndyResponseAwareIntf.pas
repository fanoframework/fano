{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IndyResponseAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    IdBaseComponent,
    IdComponent,
    IdTCPServer,
    IdCustomHTTPServer;

type

    (*!------------------------------------------------
     * interface for any class having maintain TIdHTTPServer
     * response instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IIndyResponseAware = interface
        ['{92EB633E-DAB9-43E4-8DF5-92C15EECEDAA}']

        (*!------------------------------------------------
         * get TIdHTTPServer response connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getResponse() : TIdHTTPResponseInfo;

        (*!------------------------------------------------
         * set TIdHTTPServer response connection
         *-----------------------------------------------*)
        procedure setResponse(aresponse: TIdHTTPResponseInfo);

        property response: TIdHTTPResponseInfo read getResponse write setResponse;
    end;

implementation

end.
