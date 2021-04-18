{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TokenVerifierIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    VerificationResultTypes;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * verify token validity
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ITokenVerifier = interface
        ['{CADB73EB-A604-4177-8C95-21B03367D371}']

        (*!------------------------------------------------
         * verify token
         *-------------------------------------------------
         * @param token token to verify
         * @return boolean true if token is verified
         *-------------------------------------------------*)
        function verify(const token : string) : TVerificationResult;

        (*!------------------------------------------------
         * set additional data for token verification (if any)
         *-------------------------------------------------
         * @param key name of data to set
         * @param metaData data to set
         *-------------------------------------------------*)
        procedure setData(const key : shortstring; const metaData : string);

        (*!------------------------------------------------
         * get additional data for token verification (if any)
         *-------------------------------------------------
         * @param key name of data to query
         * @@return meta data for key
         *-------------------------------------------------*)
        function getData(const key : shortstring) : string;

        (*!------------------------------------------------
         * test if contain meta data
         *-------------------------------------------------
         * @param key name of data to query
         * @return boolean true if contain key
         *-------------------------------------------------*)
        function has(const key : shortstring) : boolean;

        (*!------------------------------------------------
         * property for token verification meta data
         *-------------------------------------------------
         * @param key name of data to set
         *-------------------------------------------------*)
        property data[const key : shortstring] : string read getData write setData; default;
    end;

implementation

end.
