{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestValidatorIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    ValidationResultTypes;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * validate input data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IRequestValidator = interface
        ['{6CB55A49-DD2F-48C3-A95C-58808E11BFAB}']

        (*!------------------------------------------------
         * Validate data from request
         *-------------------------------------------------
         * @param request request instance to validate
         * @return validation result
         *-------------------------------------------------*)
        function validate(const request : IRequest) : TValidationResult;

        (*!------------------------------------------------
         * get last validation status result
         *-------------------------------------------------
         * @return validation result
         *-------------------------------------------------
         * This mechanism is provided to allow application doing
         * validation in middleware before controller is executed
         * and then get validation result in controller/route handler
         * with assumption that it is same request validator
         * instance that is shared between middleware and
         * controller/route handler.
         * IRequestValidator implementation must maintain
         * state of last validate() call result.
         *-------------------------------------------------*)
        function lastValidationResult() : TValidationResult;
    end;

implementation



end.
