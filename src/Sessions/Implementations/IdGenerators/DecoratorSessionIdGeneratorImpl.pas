{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DecoratorSessionIdGeneratorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    SessionIdGeneratorIntf;

type

    (*!------------------------------------------------
     * abstract decorator class having capability to
     * generate session id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorSessionIdGenerator = class(TInterfacedObject, ISessionIdGenerator)
    protected
        fActualGenerator : ISessionIdGenerator;
    public
        constructor create(const gen : ISessionIdGenerator);
        destructor destroy(); override;

        (*!------------------------------------
         * get session id
         *-------------------------------------
         * @return session id string
         *-------------------------------------*)
        function getSessionId(const request : IRequest) : string; virtual; abstract;
    end;

implementation

    constructor TDecoratorSessionIdGenerator.create(const gen : ISessionIdGenerator);
    begin
        inherited create();
        fActualGenerator := gen;
    end;

    destructor TDecoratorSessionIdGenerator.destroy();
    begin
        fActualGenerator := nil;
        inherited destroy();
    end;

end.
