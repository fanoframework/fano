{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ClamdAvImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    Classes,
    ssockets,
    AbstractClamdAvImpl;

type

    (*!-----------------------------------------------
     * class having capability to scan file for computer virus using
     * ClamAV daemon server over TCP socket. This is to validate uploaded file
     * Scanning is done by reading content of file and sending its content
     * to ClamAV daemon over socket.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TClamdAv = class(TAbstractClamdAv)
    private
        procedure sendFileContent(
            const socket : TSocketStream;
            const fStream : TStream
        );
    protected
        procedure doSendScanRequest(
            const socket : TSocketStream;
            const filePath : string
        ); override;

        (*!------------------------------------------------
         * reply prefix
         *-----------------------------------------------
         * @return reply prefix
         *----------------------------------------------
         * for INSTREAM
         * reply is stream: OK
         * Method implementation must return 'stream'
         *-----------------------------------------------*)
        function getReplyPrefix(const filePath : string) : string; override;
    end;

implementation

    procedure TClamdAv.sendFileContent(
        const socket : TSocketStream;
        const fStream : TStream
    );
    var command : string;
        buff : pointer;
        buffRead : longInt;
    begin
        getMem(buff, BUFF_SIZE);
        try
            fStream.seek(0, soBeginning);
            command := 'nINSTREAM'+ #10;
            socket.writeBuffer(command[1], length(command));
            repeat
                buffRead := fStream.read(buff^, BUFF_SIZE);
                socket.writeBuffer(BEtoN(buffRead), sizeof(longint));
                socket.writeBuffer(buff^, buffRead);
            until buffRead < BUFF_SIZE;
            buffRead := 0;
            socket.writeBuffer(buffRead, sizeOf(longint));
        finally
            freeMem(buff);
        end;
    end;

    procedure TClamdAv.doSendScanRequest(
        const socket : TSocketStream;
        const filePath : string
    );
    var
        fstream : TFileStream;
    begin
        fstream := TFileStream.Create(filepath, fmOpenRead);
        try
            sendFileContent(socket, fstream);
        finally
            fstream.free();
        end;
    end;

    (*!------------------------------------------------
     * reply prefix
     *-----------------------------------------------
     * @return reply prefix
     *----------------------------------------------
     * for INSTREAM
     * reply is stream: OK
     * Method implementation must return 'stream'
     *-----------------------------------------------*)
    function TClamdAv.getReplyPrefix(const filePath : string) : string;
    begin
        result := 'stream';
    end;

end.
