{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ValidatorIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyListIntf,
    RequestIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * validate input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IValidator = interface
        ['{CEC67097-2D57-4278-BE8F-7B77EAB614FB}']

        (*!------------------------------------------------
         * Validate data
         *-------------------------------------------------
         * @param fieldName name of field
         * @param dataToValidate input data
         * @param request request object
         * @return true if data is valid otherwise false
         *-------------------------------------------------*)
        function isValid(
            const fieldName : shortstring;
            const dataToValidate : IReadOnlyList;
            const request : IRequest
        ) : boolean;

        (*!------------------------------------------------
         * Get validation error message
         *-------------------------------------------------
         * @param key name of filed that is being validated
         * @return validation error message
         *-------------------------------------------------*)
        function errorMessage(const key : shortstring) : string;
    end;

implementation



end.
