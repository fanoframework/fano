{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit GroupViewImpl;

interface

{$MODE OBJFPC}

uses

    ResponseIntf,
    ViewIntf,
    ViewParametersIntf,
    InjectableObjectImpl;

type

    TViewArray = array of IView;

    (*!-----------------------------------------------
     * view that is compose from multiple views
     * similar to TCompositeView but can have more than two
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    TGroupView = class(TInjectableObject, IView)
    private
        fViews : TViewArray;
    public

        (*!------------------------------------------------
         * constructor
         *------------------------------------------------
         * @param array of IView viewArr
         *-----------------------------------------------*)
        constructor create(const viewArr : array of IView);

        (*!------------------------------------------------
         * destructor
         *-----------------------------------------------*)
        destructor destroy(); override;

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

    function initViews(const views : array of IView) : TViewArray;
    var i : integer;
    begin
        result := default(TViewArray);
        setLength(result, high(views) - low(views) + 1);
        for i := low(views) to high(views) do
        begin
            result[i] := views[i];
        end;
    end;

    procedure freeViews(var views : TViewArray);
    var i : integer;
    begin
        for i := 0 to length(views) - 1 do
        begin
            views[i] := nil;
        end;
        setLength(views, 0);
        views := nil;
    end;

    (*!------------------------------------------------
     * constructor
     *------------------------------------------------
     * @param IView firstViewInst first view
     * @param IView secondViewInst second view
     *-----------------------------------------------*)
    constructor TGroupView.create(const viewArr : array of IView);
    begin
        fViews := initViews(viewArr);
    end;

    (*!------------------------------------------------
     * destructor
     *-----------------------------------------------*)
    destructor TGroupView.destroy();
    begin
        freeViews(fViews);
        inherited destroy();
    end;

    (*!------------------------------------------------
     * render view
     *------------------------------------------------
     * @param viewParams view parameters
     * @param response response instance
     * @return response
     *-----------------------------------------------*)
    function TGroupView.render(
        const viewParams : IViewParameters;
        const response : IResponse
    ) : IResponse;
    var i : integer;
    begin
        result := response;
        for i := 0 to length(fViews) - 1 do
        begin
            result := fViews[i].render(viewParams, result);
        end;
    end;

end.
