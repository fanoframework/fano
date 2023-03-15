{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HtmlAjaxErrorHandlerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    AjaxAwareIntf,
    ErrorHandlerIntf,
    EnvironmentEnumeratorIntf,
    BaseErrorHandlerImpl;

type

    (*!---------------------------------------------------
     * composite error handler that display error as JSON
     * for ajax request or as html response for other
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    THtmlAjaxErrorHandler = class(TBaseErrorHandler)
    private
        ajaxDetector : IAjaxAware;
        ajaxErrorHandler : IErrorHandler;
        htmlErrorHandler : IErrorHandler;

        (*!---------------------------------------------------
         * get error handler based on AJAX or not
         *----------------------------------------------------
         * @param IErrorHandler error handler to use
         *---------------------------------------------------*)
        function getErrorHandler() : IErrorHandler;
    public
        (*!---------------------------------------------------
         * constructor
         *----------------------------------------------------
         * @param ajaxDetectorInst instance class that can detect AJAX
         * @param ajaxErrorHandler error handler for ajax request
         * @param htmlErrorHandler error handler for other request
         *---------------------------------------------------*)
        constructor create(
            const ajaxDetectorInst : IAjaxAware;
            const ajaxErrHandler : IErrorHandler;
            const htmlErrHandler : IErrorHandler
        );

        (*!---------------------------------------------------
         * destructor
         *---------------------------------------------------*)
        destructor destroy(); override;

        (*!---------------------------------------------------
         * handle exception
         *----------------------------------------------------
         * @param exc exception that is to be handled
         * @param status HTTP error status, default is HTTP error 500
         * @param msg HTTP error message
         *---------------------------------------------------*)
        function handleError(
            const env : ICGIEnvironmentEnumerator;
            const exc : Exception;
            const status : integer = 500;
            const msg : string  = 'Internal Server Error'
        ) : IErrorHandler; override;
    end;

implementation

    (*!---------------------------------------------------
     * constructor
     *----------------------------------------------------
     * @param ajaxDetectorInst instance class that can detect AJAX
     * @param ajaxErrorHandler error handler for ajax request
     * @param htmlErrorHandler error handler for other request
     *---------------------------------------------------*)
    constructor THtmlAjaxErrorHandler.create(
        const ajaxDetectorInst : IAjaxAware;
        const ajaxErrHandler : IErrorHandler;
        const htmlErrHandler : IErrorHandler
    );
    begin
        ajaxDetector := ajaxDetectorInst;
        ajaxErrorHandler := ajaxErrHandler;
        htmlErrorHandler := htmlErrHandler;
    end;

    destructor THtmlAjaxErrorHandler.destroy();
    begin
        inherited destroy();
        ajaxDetector := nil;
        ajaxErrorHandler := nil;
        htmlErrorHandler := nil;
    end;

    (*!---------------------------------------------------
     * get error handler based on AJAX or not
     *----------------------------------------------------
     * @param IErrorHandler error handler to use
     *---------------------------------------------------*)
    function THtmlAjaxErrorHandler.getErrorHandler() : IErrorHandler;
    begin
        if (ajaxDetector.isXhr()) then
        begin
            result := ajaxErrorHandler;
        end else
        begin
            result := htmlErrorHandler;
        end;
    end;

    (*!---------------------------------------------------
     * handle exception
     *----------------------------------------------------
     * @param exc exception that is to be handled
     * @param status HTTP error status, default is HTTP error 500
     * @param msg HTTP error message
     *---------------------------------------------------*)
    function THtmlAjaxErrorHandler.handleError(
        const env : ICGIEnvironmentEnumerator;
        const exc : Exception;
        const status : integer = 500;
        const msg : string  = 'Internal Server Error'
    ) : IErrorHandler;
    begin
        getErrorHandler().handleError(env, exc, status, msg);
        result := self;
    end;
end.
