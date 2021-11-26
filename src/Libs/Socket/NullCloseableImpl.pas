{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullCloseableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CloseableIntf,
    StreamIdIntf;

type

    (*!-----------------------------------------------
     * dummy implementation that can be close socket and
     * remove from monitoring
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullCloseable = class(TInterfacedObject, ICloseable, IStreamId)
    private
        fHandle : longint;
    public
        constructor create(const ahandle: longint);
        function close() : boolean;
        function getId() : shortstring;
    end;

implementation

uses

    SysUtils;

    constructor TNullCloseable.create(const ahandle: longint);
    begin
        fHandle := aHandle;
    end;

    function TNullCloseable.close() : boolean;
    begin
        result := true;
    end;

    function TNullCloseable.getId() : shortstring;
    begin
        result := intToHex(fHandle, 16);
    end;
end.
