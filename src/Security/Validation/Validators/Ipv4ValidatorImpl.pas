{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Ipv4ValidatorImpl;

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
     * matched IP Address (IPV4)
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TIpv4Validator = class(TBaseValidator)
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

    sErrFieldMustBeIpv4 = 'Field %s must be valid IP Address (IPV4)';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TIpv4Validator.create();
    begin
        inherited create(sErrFieldMustBeIpv4);
    end;

    (*!------------------------------------------------
     * actual data validation
     *-------------------------------------------------
     * @param dataToValidate input data
     * @return true if data is valid otherwise false
     * @link https://lists.freepascal.org/pipermail/fpc-pascal/2016-July/048523.html
     *-------------------------------------------------*)
    function TIpv4Validator.isValidData(
        const dataToValidate : string;
        const dataCollection : IReadOnlyList;
        const request : IRequest
    ) : boolean;
    var tmpAddress : string;
    begin
        tmpAddress := HostAddrToStr(StrToHostAddr(dataToValidate));
        result := (tmpAddress = dataToValidate);
    end;
end.
