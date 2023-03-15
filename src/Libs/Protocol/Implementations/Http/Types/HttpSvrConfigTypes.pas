{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpSvrConfigTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    THttpSvrConfig = record
        host : string;
        port : word;
        documentRoot : string;
        serverName : string;
        serverSoftware : string;
        serverSignature : string;
        serverAdmin : string;
        timeout : longword;
        //use IPv6
        useIPv6 : boolean;
        //use IPv6 = true and dualStack =true, support IPv4 and IPv6
        //use IPv6 = true and dualStack =false, IPv6 only
        dualStack : boolean;

        //set to true if using https
        useTLS : boolean;
        //SSL certificate key file path
        tlsKey : string;
        //SSL certificate file path
        tlsCert : string;

        threaded : boolean;
        threadPoolSize : integer;

        mimeTypesFile : string;
    end;

implementation

end.
