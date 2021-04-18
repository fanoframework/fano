{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Ipv6ValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    ValidatorIntf,
    RequestIntf,
    BaseValidatorImpl;

type

    (*!------------------------------------------------
     * class having capability to validate if data
     * matched IP Address (IPv6)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TIpv6Validator = class(TBaseValidator)
    protected
        (*!------------------------------------------------
         * actual data validation
         *-------------------------------------------------
         * @param dataToValidate input data
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValidData(
            const dataToValidate : string;
            const dataCollection : IReadOnlyList;
            const request : IRequest
        ) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create();
    end;

implementation

uses

    SysUtils,
    sockets;

resourcestring

    sErrFieldMustBeIpv6 = 'Field %s must be valid IP Address (IPv6)';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TIpv6Validator.create();
    begin
        inherited create(sErrFieldMustBeIpv6);
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     * @link https://lists.freepascal.org/pipermail/fpc-pascal/2016-July/048523.html
     *-------------------------------------------------*)
    function TIpv6Validator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var tmpAddress : string;
    begin
        tmpAddress := HostAddrToStr6(StrToHostAddr6(dataToValidate));
        result := (tmpAddress = dataToValidate);
    end;
end.
