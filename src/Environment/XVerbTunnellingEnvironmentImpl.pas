{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit XVerbTunnellingEnvironmentImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    EnvironmentIntf,
    EnvironmentEnumeratorIntf,
    RequestIntf,
    VerbTunnellingEnvironmentImpl;


type

    (*!------------------------------------------------
     * class having capability to retrieve
     * CGI environment variable and override HTTP method
     * using request parameter such as _method
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TXVerbTunnellingEnvironment = class(TVerbTunnellingEnvironment)
    private
        fRequest : IRequest;
        fVerbOverrideParam : shortstring;
        function overrideMethod(const keyName : string) : string;
    public
        constructor create(
            const aEnv : ICGIEnvironment;
            const request : IRequest;
            const verbOverrideParam : shortstring
        );
        destructor destroy(); override;

        (*!-----------------------------------------
         * Retrieve an environment variable
         *------------------------------------------
         * @param key name of variable
         * @return variable value
         *------------------------------------------*)
        function env(const keyName : string) : string; override;
    end;

implementation

uses

    sysutils,
    EInvalidMethodImpl;

    procedure makeWeakRef(aInterfaceField: PInterface; const aValue: IInterface);
    begin
        PPointer(aInterfaceField)^ := Pointer(aValue);
    end;

    constructor TXVerbTunnellingEnvironment.create(
        const aEnv : ICGIEnvironment;
        const request : IRequest;
        const verbOverrideParam : shortstring
    );
    begin
        inherited create(aEnv);
        //this class instance is cross reference
        //with request instance so store reference request as weak reference to
        //avoid memory leak
        makeWeakRef(@fRequest, request);
        // fRequest := request;
        fVerbOverrideParam := verbOverrideParam;
    end;

    destructor TXVerbTunnellingEnvironment.destroy();
    begin
        fRequest := nil;
        inherited destroy();
    end;

    function TXVerbTunnellingEnvironment.overrideMethod(const keyName : string) : string;
    var allowed : boolean;
    begin
        result := trim(uppercase(fRequest.getParsedBodyParam(fVerbOverrideParam)));
        if result <> '' then
        begin
            allowed := (result = 'GET') or
                (result = 'POST') or
                (result = 'PUT') or
                (result = 'DELETE') or
                (result = 'OPTIONS') or
                (result = 'PATCH') or
                (result = 'HEAD');

            if not allowed then
            begin
                raise EInvalidMethod.createFmt(
                    sErrInvalidMethod,
                    [ result ]
                );
            end;
        end else
        begin
            result := inherited env(keyName);
        end;
    end;

    (*!-----------------------------------------
     * Retrieve an environment variable
     *------------------------------------------
     * @param key name of variable
     * @return variable value
     *------------------------------------------*)
    function TXVerbTunnellingEnvironment.env(const keyName : string) : string;
    begin
        if keyName = 'REQUEST_METHOD' then
        begin
            result := overrideMethod(keyName);
        end else
        begin
            result := inherited env(keyName);
        end;
    end;


end.
