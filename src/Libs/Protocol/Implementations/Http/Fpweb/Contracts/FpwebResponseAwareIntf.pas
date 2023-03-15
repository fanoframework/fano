{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpwebResponseAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    fphttpserver;

type

    (*!------------------------------------------------
     * interface for any class having maintain TFpHttpServer
     * response instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFpwebResponseAware = interface
        ['{77982C22-3661-472C-ABEC-3905DEDF67FB}']

        (*!------------------------------------------------
         * get TFpHttpServer response connection
         *-----------------------------------------------
         * @return connection
         *-----------------------------------------------*)
        function getResponse() : TFPHTTPConnectionResponse;

        (*!------------------------------------------------
         * set TFpHttpServer response connection
         *-----------------------------------------------*)
        procedure setResponse(aresponse : TFPHTTPConnectionResponse);

        property response : TFPHTTPConnectionResponse read getResponse write setResponse;
    end;

implementation

end.
