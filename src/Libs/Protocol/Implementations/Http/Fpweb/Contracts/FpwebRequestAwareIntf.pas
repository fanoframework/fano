{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FpwebRequestAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    fphttpserver;

type

    (*!------------------------------------------------
     * interface for any class having maintain TFpHttpServer
     * request instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFpwebRequestAware = interface
        ['{63AED354-05C1-4C5B-B938-C54668E4445F}']

        (*!------------------------------------------------
         * get TFpHttpServer request
         *-----------------------------------------------
         * @return request
         *-----------------------------------------------*)
        function getRequest() : TFPHTTPConnectionRequest;

        (*!------------------------------------------------
         * set TFpHttpServer request
         *-----------------------------------------------*)
        procedure setRequest(arequest : TFPHTTPConnectionRequest);

        property request : TFPHTTPConnectionRequest read getRequest write setRequest;
    end;

implementation

end.
