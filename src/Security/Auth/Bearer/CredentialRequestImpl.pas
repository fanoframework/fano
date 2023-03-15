{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CredentialRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    DecoratorRequestImpl;

type

    (*!------------------------------------------------
     * decorator class having capability as
     * HTTP request and add credential info in request
     * param
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TCredentialRequest = class (TDecoratorRequest)
    private
        fCredentialKey : shortstring;
        fCredentialValue : string;
    public
        constructor create(
            const request : IRequest;
            const credentialKey : shortstring;
            const credentialValue : string
        );

        (*!------------------------------------------------
         * get request query string or body data
         *-------------------------------------------------
         * @param string key name of key
         * @param string defValue default value to use if key
         *               does not exist
         * @return string value
         -------------------------------------------------
         * if key is not found in actual request and key is
         * equal to fCredentialKey then this class returns
         * value of fCredentialValue
         *------------------------------------------------*)
        function getParam(
            const key: string;
            const defValue : string = ''
        ) : string; override;

    end;

implementation

    constructor TCredentialRequest.create(
        const request : IRequest;
        const credentialKey : shortstring;
        const credentialValue : string
    );
    begin
        inherited create(request);
        fCredentialKey := credentialKey;
        fCredentialValue := credentialValue;
    end;

    (*!------------------------------------------------
     * get single query param or body param value by its name
     *-------------------------------------------------
     * @param string key name of key
     * @param string defValue default value to use if key
     *               does not exist
     * @return string value
     -------------------------------------------------
     * if key is not found in actual request and key is
     * equal to fCredentialKey then this class returns
     * value of fCredentialValue
     *------------------------------------------------*)
    function TCredentialRequest.getParam(const key: string; const defValue : string = '') : string;
    begin
        result := inherited getParam(key, defValue);
        if (result = defValue) and (key = fCredentialKey) then
        begin
            result := fCredentialValue;
        end;
    end;

end.
