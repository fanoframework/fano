{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DevUrandomImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils,
    RandomIntf;

type

    (*!------------------------------------------------
     * class having capability to get random value
     * from /dev/urandom
     *
     * TODO: This is UNIX only, need to add conditional
     * defines for UNIX
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDevUrandom = class(TInterfacedObject, IRandom)
    public
        function randomBytes(const totalBytes : integer) : TBytes;
    end;

implementation

uses

    Classes;

    function TDevUrandom.randomBytes(const totalBytes : integer) : TBytes;
    var fstream : TFileStream;
    begin
        result := default(TBytes);
        fstream := TFileStream.create('/dev/urandom', fmOpenRead);
        try
            setLength(result, totalBytes);
            fstream.readBuffer(result[0], totalBytes);
        finally
            fstream.free();
        end;
    end;
end.
