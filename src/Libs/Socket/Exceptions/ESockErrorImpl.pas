{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ESockErrorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils;

type

    ESockError = class(Exception)
    private
        fSocketErrMsg : string;
        fSocketErrCode : longint;
    public
        constructor create(const errCode : longint; const errMsg : string); overload;
        constructor createFmt(const msgFmt : string; const errCode : longint; const errMsg : string); overload;

        property errCode : longint read fSocketErrCode;
        property errMsg : string read fSocketErrMsg;
    end;

implementation

    constructor ESockError.create(const errCode : longint; const errMsg : string);
    begin
        inherited create(errMsg);
        fSocketErrCode := errCode;
        fSocketErrMsg := errMsg;
    end;

    constructor ESockError.createFmt(const msgFmt : string; const errCode : longint; const errMsg : string);
    begin
        inherited createFmt(msgFmt, [errMsg, errCode]);
        fSocketErrCode := errCode;
        fSocketErrMsg := errMsg;
    end;

end.
