{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorModelParamsImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ModelParamsIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * decorator model parameter data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorModelParams = class (TInjectableObject, IModelParams)
    protected
        fActualParams : IModelParams;
    public
        constructor create(const actualParam : IModelParams);
        destructor destroy(); override;

        function writeString(const key : shortstring; const value : string) : IModelParams; virtual;
        function writeInteger(const key : shortstring; const value : integer) : IModelParams; virtual;

        function readString(const key : shortstring) : string; virtual;
        function readInteger(const key : shortstring) : integer; virtual;

        function serialize() : string; virtual;
    end;

implementation

    constructor TDecoratorModelParams.create(const actualParam : IModelParams);
    begin
        fActualParams := actualParam;
    end;

    destructor TDecoratorModelParams.destroy();
    begin
        fActualParams := nil;
        inherited destroy();
    end;

    function TDecoratorModelParams.writeString(const key : shortstring; const value : string) : IModelParams;
    begin
        fActualParams.writeString(key, value);
        result := self;
    end;

    function TDecoratorModelParams.writeInteger(const key : shortstring; const value : integer) : IModelParams;
    begin
        fActualParams.writeInteger(key, value);
        result := self;
    end;

    function TDecoratorModelParams.readString(const key : shortstring) : string;
    begin
        result := fActualParams.readString(key);
    end;

    function TDecoratorModelParams.readInteger(const key : shortstring) : integer;
    begin
        result := fActualParams.readInteger(key);
    end;

    function TDecoratorModelParams.serialize() : string;
    begin
        result := fActualParams.serialize();
    end;

end.
