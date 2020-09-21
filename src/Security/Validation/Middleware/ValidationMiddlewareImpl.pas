{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ValidationMiddlewareImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    RequestIntf,
    ResponseIntf,
    RequestValidatorIntf,
    RouteArgsReaderIntf,
    RequestHandlerIntf,
    MiddlewareIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * basic validation class having capability to
     * validate input data from request instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TValidationMiddleware = class(TInjectableObject, IMiddleware)
    private
        fValidation : IRequestValidator;
        fStopOnValidationError : boolean;
    public
        constructor create(
            const validationInst : IRequestValidator;
            const stopOnValidationError : boolean = false
        );
        destructor destroy(); override;

        (*!---------------------------------------
         * handle request and validate request
         *----------------------------------------
         * @param request request instance
         * @param response response instance
         * @param args route arguments
         * @param canContinue return true if execution
         *        can continue to next middleware or false
         *        to stop execution
         * @return response
         *----------------------------------------
         * Status of validation result will be store
         * in request with attribute name 'validation'
         *----------------------------------------*)
        function handleRequest(
            const request : IRequest;
            const response : IResponse;
            const args : IRouteArgsReader;
            const next : IRequestHandler
        ) : IResponse;

    end;

implementation

uses

    HttpCodeResponseImpl,
    ValidationResultTypes;

    constructor TValidationMiddleware.create(
        const validationInst : IRequestValidator;
        const stopOnValidationError : boolean = false
    );
    begin
        fValidation := validationInst;
        fStopOnValidationError := stopOnValidationError;
    end;

    destructor TValidationMiddleware.destroy();
    begin
        fValidation := nil;
        inherited destroy();
    end;

    (*!---------------------------------------
     * handle request
     *----------------------------------------
     * @param request request instance
     * @param response response instance
     * @param args route arguments
     * @param next next middleware to execute
     * @return response
     *----------------------------------------*)
    function TValidationMiddleware.handleRequest(
        const request : IRequest;
        const response : IResponse;
        const args : IRouteArgsReader;
        const next : IRequestHandler
    ) : IResponse;
    var validationRes : TValidationResult;
        canContinue : boolean;
    begin
        validationRes := fValidation.validate(request);
        canContinue := (not fStopOnValidationError) or validationRes.isValid;

        if (canContinue) then
        begin
            result := next.handleRequest(request, response, args);
        end else
        begin
            result := THttpCodeResponse.create(
                500,
                //validation failed, errorMessages must has one error message at least
                validationRes.errorMessages[0].errorMessage,
                response.headers()
            );
        end;
    end;

end.
