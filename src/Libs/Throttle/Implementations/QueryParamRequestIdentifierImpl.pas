{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit QueryParamRequestIdentifierImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    AbstractRequestIdentifierImpl;

type

    (*!------------------------------------------------
     * request identifier implementation which use client
     * specific query param key value as identifier
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TQueryParamRequestIdentifier = class (TAbstractRequestIdentifier)
    private
        fKey : shortstring;
    public
        constructor create(const key : shortstring);
        (*!------------------------------------------------
         * get identifier from request
         *-----------------------------------------------
         * @param request request object
         * @return identifier string
         *-----------------------------------------------*)
        function getId(const request : IRequest) : shortstring; override;
    end;

implementation

    constructor TQueryParamRequestIdentifier.create(const key : shortstring);
    begin
        fKey := key;
    end;

    (*!------------------------------------------------
     * get identifier from request
     *-----------------------------------------------
     * @param request request object
     * @return identifier string
     *-----------------------------------------------*)
    function TQueryParamRequestIdentifier.getId(const request : IRequest) : shortstring;
    begin
        result := request.getParam(fKey);
    end;
end.
