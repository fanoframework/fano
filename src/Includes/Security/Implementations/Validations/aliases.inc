{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * alias for implementation in security
 * that is included in implementations.aliases.inc
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

EInvalidValidator = EInvalidValidatorImpl.EInvalidValidator;
TValidation = ValidationImpl.TValidation;
TValidationFactory = ValidationFactoryImpl.TValidationFactory;
TValidationCollection = ValidationCollectionImpl.TValidationCollection;

TValidationMessage = ValidationResultTypes.TValidationMessage;
TValidationMessages = ValidationResultTypes.TValidationMessages;
TValidationResult = ValidationResultTypes.TValidationResult;

{$INCLUDE validators.aliases.inc}

TValidationMiddleware = ValidationMiddlewareImpl.TValidationMiddleware;
TValidationMiddlewareWithHandler = ValidationMiddlewareWithHandlerImpl.TValidationMiddlewareWithHandler;
TValidationCollectionMiddlewareWithHandler = ValidationCollectionMiddlewareWithHandlerImpl.TValidationCollectionMiddlewareWithHandler;
