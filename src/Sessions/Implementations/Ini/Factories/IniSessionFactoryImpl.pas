{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IniSessionFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    SessionFactoryIntf;

type

    (*!------------------------------------------------
     * factory class having capability to
     * create TIniSession object
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIniSessionFactory = class(TInterfacedObject, ISessionFactory)
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
    IniSessionImpl;

    function TIniSessionFactory.createSession(
        const sessName : shortstring;
        const sessId : string;
        const sessData : string
    ) : ISession;
    begin
        result := TIniSession.create(sessName, sessId, sessData);
    end;

    function TIniSessionFactory.createNewSession(
        const sessName : shortstring;
        const sessId : string;
        const expiredDate : TDateTime
    ) : ISession;
    begin
        result := TIniSession.create(
            sessName,
            sessId,
            format(
                '[expiry]' + LineEnding +
                'expire=%s' + LineEnding +
                '[sessionVars]' + LineEnding,
                [ sessId, formatDateTime('dd-mm-yyyy hh:nn:ss', expiredDate) ]
            )
        );
    end;

end.
