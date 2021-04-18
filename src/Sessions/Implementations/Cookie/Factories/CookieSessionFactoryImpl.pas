{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CookieSessionFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIntf,
    EncrypterIntf,
    SessionFactoryIntf;

type

    (*!------------------------------------------------
     * factory class having capability to
     * create CookieSession object
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCookieSessionFactory = class(TInterfacedObject, ISessionFactory)
    private
        fActualSessFactory : ISessionFactory;
        fEncrypter : IEncrypter;
    public

        (*!------------------------------------
         * constructor
         *-------------------------------------
         * @param actualSessFactory actual session factory instance
         * @param encrypter instance data encrypter
         *-------------------------------------*)
        constructor create(
            const actualSessFactory : ISessionFactory;
            const encrypter : IEncrypter
        );

        destructor destroy(); override;

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
    CookieSessionImpl;

    (*!------------------------------------
     * constructor
     *-------------------------------------
     * @param actualSessionFactory actual session instance;
     * @param encrypter instance data encrypter
     *-------------------------------------*)
    constructor TCookieSessionFactory.create(
        const actualSessFactory : ISessionFactory;
        const encrypter : IEncrypter
    );
    begin
        fActualSessFactory := actualSessFactory;
        fEncrypter := encrypter;
    end;

    destructor TCookieSessionFactory.destroy();
    begin
        fActualSessFactory := nil;
        fEncrypter := nil;
        inherited destroy();
    end;

    function TCookieSessionFactory.createSession(
        const sessName : shortstring;
        const sessId : string;
        const sessData : string
    ) : ISession;
    begin
        result := TCookieSession.create(
            fActualSessFactory.createSession(sessName, sessId, sessData),
            fEncrypter
        );
    end;

    function TCookieSessionFactory.createNewSession(
        const sessName : shortstring;
        const sessId : string;
        const expiredDate : TDateTime
    ) : ISession;
    begin
        result := TCookieSession.create(
            fActualSessFactory.createNewSession(sessName, sessId, expiredDate),
            fEncrypter
        );
    end;

end.
