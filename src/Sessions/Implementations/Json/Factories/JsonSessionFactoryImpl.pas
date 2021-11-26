{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JsonSessionFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    SessionFactoryIntf;

type

    (*!------------------------------------------------
     * factory class having capability to
     * create JsonSession object
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TJsonSessionFactory = class(TInterfacedObject, ISessionFactory)
    public
        function createSession(
            const sessName : shortstring;
            const sessId : string;
            const sessData : string
        ) : ISession;

        function createNewSession(
            const sessName : shortstring;
            const sessId : string;
            const expiredDate : TDateTime
        ) : ISession;
    end;

implementation

uses

    SysUtils,
    DateUtils,
    JsonSessionImpl;

    function TJsonSessionFactory.createSession(
        const sessName : shortstring;
        const sessId : string;
        const sessData : string
    ) : ISession;
    begin
        result := TJsonSession.create(sessName, sessId, sessData);
    end;

    function TJsonSessionFactory.createNewSession(
        const sessName : shortstring;
        const sessId : string;
        const expiredDate : TDateTime
    ) : ISession;
    begin
        result := TJsonSession.create(
            sessName,
            sessId,
            format(
                '{"expire": "%s", "sessionVars" : {}}',
                [ formatDateTime('dd-mm-yyyy hh:nn:ss', expiredDate) ]
            )
        );
    end;

end.
