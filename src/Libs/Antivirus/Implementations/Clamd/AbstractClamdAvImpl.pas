{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractClamdAvImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ssockets,
    AntivirusIntf,
    ScanResultIntf;

const

    BUFF_SIZE = 2 * 1024;

type

    (*!-----------------------------------------------
     * abstract class having capability to scan file for computer virus using
     * ClamAV daemon server over TCP socket. This is to validate uploaded file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractClamdAv = class abstract (TInterfacedObject, IAntivirus, IScanResult)
    private
        fUseUnixDomainSocket : boolean;
        fUnixSock : string;
        fHost : string;
        fPort : word;
        fClean : boolean;
        fVirusName : string;
        function sendScanRequest(const filePath : string) : string;
        procedure raiseSockReadExcept();
        function readReply(const socket : TSocketStream) : string;
        procedure interpretReply(const prefix : string; const reply : string);
    protected
        procedure doSendScanRequest(
            const socket : TSocketStream;
            const filePath : string
        ); virtual; abstract;

        (*!------------------------------------------------
         * reply prefix
         *-----------------------------------------------
         * @return reply prefix
         *----------------------------------------------
         * for SCAN /path/to/file
         * reply is /path/to/file: OK
         * for INSTREAM
         * reply is stream: OK
         * Method implementation must return '/path/to/file'
         * or 'stream'
         *-----------------------------------------------*)
        function getReplyPrefix(const filePath : string) : string; virtual; abstract;

    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param host hostname or ip where clamav daemon listen
         * @param port port where clamav daemon listen
         *-----------------------------------------------*)
        constructor create(const host : string; const port : word); overload;

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param unixSock unix domain socket file where daemon listen
         *-----------------------------------------------*)
        constructor create(const unixSock : string); overload;

        (*!------------------------------------------------
         * setup antivirus engine
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function beginScan() : IAntivirus;

        (*!------------------------------------------------
         * scan file for virus
         *-----------------------------------------------
         * @param filepath absolute path of file need to be scanned
         * @return scan result
         *-----------------------------------------------
         * For example if filepath is /path/to/file
         *
         * On clean scan, clamav daemon returns string
         * /path/to/file: OK
         *
         * On infected, clamav daemon returns string
         * /path/to/file: virusName FOUND
         *-----------------------------------------------*)
        function scanFile(const filePath : string) : IScanResult;

        (*!------------------------------------------------
         * free antivirus engine resources
         *-----------------------------------------------
         * @return current instance
         *-----------------------------------------------*)
        function endScan() : IAntivirus;

        (*!------------------------------------------------
         * test if the last scan is cleaned
         *-----------------------------------------------
         * @return true if cleaned
         *-----------------------------------------------*)
        function isCleaned() : boolean;

        (*!------------------------------------------------
         * return name of virus if virus detected
         *------------------------------------------------
         * @return name of virus or empty string if clean
         *-----------------------------------------------*)
        function virusName() : string;

    end;

implementation

uses

    sockets,
    errors,
    strutils,
    SocketConsts,
    ESockErrorImpl;

    constructor TAbstractClamdAv.create(const host : string; const port : word);
    begin
        fHost := host;
        fPort := port;
        fUseUnixDomainSocket := false;
    end;

    constructor TAbstractClamdAv.create(const unixSock : string);
    begin
        fUnixSock := unixSock;
        fUseUnixDomainSocket := true;
    end;

    (*!------------------------------------------------
     * setup antivirus engine
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TAbstractClamdAv.beginScan() : IAntivirus;
    begin
        //intentionally does nothing
        result := self;
    end;

    (*!------------------------------------------------
     * free antivirus engine resources
     *-----------------------------------------------
     * @return current instance
     *-----------------------------------------------*)
    function TAbstractClamdAv.endScan() : IAntivirus;
    begin
        //intentionally does nothing
        result := self;
    end;

    function TAbstractClamdAv.sendScanRequest(const filePath : string) : string;
    var
        socket : TSocketStream;
    begin
        if fUseUnixDomainSocket then
        begin
            socket := TUnixSocket.create(fUnixSock);
        end else
        begin
            socket := TInetSocket.create(fHost, fPort);
        end;

        try
            doSendScanRequest(socket, filePath);
            result := readReply(socket);
        finally
            socket.free();
        end;
    end;

    procedure TAbstractClamdAv.interpretReply(const prefix : string; const reply : string);
    var
        scanStatusPos : integer;
        lenReplyPrefix : integer;
    begin
        fVirusName := '';
        scanStatusPos := rpos('OK', reply);
        fClean := (scanStatusPos <> 0);
        if not fClean then
        begin
            //length of prefix + ': '
            lenReplyPrefix := length(prefix) + 2;
            scanStatusPos := rpos(' FOUND', reply);
            fVirusName := copy(reply, lenReplyPrefix + 1, scanStatusPos - lenReplyPrefix);
        end;
    end;


    (*!------------------------------------------------
     * scan file for virus
     *-----------------------------------------------
     * @param filepath absolute path of file need to be scanned
     * @return scan result
     *-----------------------------------------------
     * For example if filepath is /path/to/file
     * with SCAN command
     * On clean scan, clamav daemon returns string
     * /path/to/file: OK
     *
     * On infected, clamav daemon returns string
     * /path/to/file: virusName FOUND
     *
     * with INSTREAM command
     * On clean scan, clamav daemon returns string
     * stream: OK
     *
     * On infected, clamav daemon returns string
     * stream: virusName FOUND
     *-----------------------------------------------*)
    function TAbstractClamdAv.scanFile(const filePath : string) : IScanResult;
    begin
        interpretReply(getReplyPrefix(filePath), sendScanRequest(filePath));
        result := self;
    end;

    (*!------------------------------------------------
     * test if the last scan is cleaned
     *-----------------------------------------------
     * @return true if cleaned
     *-----------------------------------------------*)
    function TAbstractClamdAv.isCleaned() : boolean;
    begin
        //intentionally does nothing and always assumed cleaned
        result := fClean;
    end;

    (*!------------------------------------------------
     * return name of virus if virus detected
     *------------------------------------------------
     * @return name of virus or empty string if clean
     *-----------------------------------------------*)
    function TAbstractClamdAv.virusName() : string;
    begin
        result := fVirusName;
    end;

    procedure TAbstractClamdAv.raiseSockReadExcept();
    var
        errCode : longint;
    begin
        errCode := socketError();
        raise ESockError.createFmt(rsSocketReadFailed, errCode, strError(errCode));
    end;

    function TAbstractClamdAv.readReply(const socket : TSocketStream) : string;
    var buff : string;
        buffRead : integer;
    begin
        result := '';
        setLength(buff, BUFF_SIZE);
        repeat
            buffRead := socket.read(buff[1], BUFF_SIZE);
            if buffRead > 0 then
            begin
                //TODO: improve by avoiding string concatenation and copy
                result := result + copy(buff, 1, buffRead);
            end;
        until (buffRead <= 0);

        if (buffRead < 0) then
        begin
            raiseSockReadExcept();
        end;
    end;

end.
