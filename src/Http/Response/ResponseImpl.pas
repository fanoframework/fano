{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    ResponseIntf,
    HeadersIntf,
    ResponseStreamIntf,
    CloneableIntf,
    BaseResponseImpl;

type
    (*!------------------------------------------------
     * base Http response class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TResponse = class(TBaseResponse, IDependency)
    public
        function clone() : ICloneable; override;
    end;

implementation

    function TResponse.clone() : ICloneable;
    var clonedObj : IResponse;
    begin
        clonedObj := TResponse.create(
            headers().clone() as IHeaders,
            //TODO : do we need to create new instance?
            //response stream may contain big data
            //so just pass the current stream (for now)
            //Should watch out for memory leak
            body()
        );
        //TODO : copy any property
        result := clonedObj;
    end;
end.
