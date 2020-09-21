{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit MhdSvrConfigTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    TMhdSvrConfig = record
        host : string;
        port : word;
        documentRoot : string;
        serverName : string;
        serverSoftware : string;
        serverSignature : string;
        serverAdmin : string;
        timeout : longword;

        //set to true if using https
        useTLS : boolean;
        //SSL certificate key file path
        tlsKey : string;
        //SSL certificate file path
        tlsCert : string;
    end;

implementation

end.
