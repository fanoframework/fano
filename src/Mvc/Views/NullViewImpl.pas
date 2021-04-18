{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullViewImpl;

interface

{$MODE OBJFPC}

uses

    ResponseIntf,
    ViewIntf,
    ViewParametersIntf,
    InjectableObjectImpl;

type

    (*!-----------------------------------------------
     * view that display nothing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    TNullView = class(TInjectableObject, IView)
    public
        (*!------------------------------------------------
         * render view
         *------------------------------------------------
         * @param viewParams view parameters
         * @param response response instance
         * @return response
         *-----------------------------------------------*)
        function render(
            const viewParams : IViewParameters;
            const response : IResponse
        ) : IResponse;
    end;

implementation

    (*!------------------------------------------------
     * render view
     *------------------------------------------------
     * @param viewParams view parameters
     * @param response response instance
     * @return response
     *-----------------------------------------------*)
    function TNullView.render(
        const viewParams : IViewParameters;
        const response : IResponse
    ) : IResponse;
    begin
        //intentionally does nothing
        result := response;
    end;

end.
