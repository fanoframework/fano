{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit IpAddrRequestIdentifierImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    AbstractRequestIdentifierImpl;

type

    (*!------------------------------------------------
     * request identifier implementation which use client
     * IP address as identifier
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TIpAddrRequestIdentifier = class (TAbstractRequestIdentifier)
    public
        (*!------------------------------------------------
         * get identifier from request
         *-----------------------------------------------
         * @param request request object
         * @return identifier string
         *-----------------------------------------------*)
        function getId(const request : IRequest) : shortstring; override;
    end;

implementation

    (*!------------------------------------------------
     * get identifier from request
     *-----------------------------------------------
     * @param request request object
     * @return identifier string
     *-----------------------------------------------*)
    function TIpAddrRequestIdentifier.getId(const request : IRequest) : shortstring;
    begin
        result := request.env.remoteAddr();
    end;
end.
