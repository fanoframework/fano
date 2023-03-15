{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiBeginRequestIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf,
    StreamAdapterAwareIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to hold
     * FastCGI Begin Requesr record
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiBeginRequest = interface
        ['{150FA66C-E4AB-4703-A591-0917D7E763A4}']

        (*!------------------------------------------------
         * get status whether to keep connection or leave open
         *-----------------------------------------------
         * @return true if we should connection open, otherwise close
          *-----------------------------------------------*)
        function keepConnection() : boolean;

        (*!------------------------------------------------
         * get request role
         *-----------------------------------------------
         * @return role such as FCGI_RESPONDER, FCGI_FILTER or FCGI_AUTHORIZER
         *-----------------------------------------------*)
        function role() : byte;

    end;

implementation

end.
