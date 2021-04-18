{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TermSignalImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    BaseUnix,
    Unix;

var

    //pipe handle that we use to monitor if we get SIGTERM/SIGINT signal
    terminatePipeIn, terminatePipeOut : longint;

implementation

    (*!-----------------------------------------------
     * make listen socket non blocking
     *-------------------------------------------------
     * @param listenSocket, listen socket handle
     *-----------------------------------------------*)
    procedure makeNonBlocking(fd : longint);
    var flags : longint;
    begin
        //read control flag and set listen socket to be non blocking
        flags := fpFcntl(fd, F_GETFL, 0);
        fpFcntl(fd, F_SETFl, flags or O_NONBLOCK);
    end;


    (*!-----------------------------------------------
     * signal handler that will be called when
     * SIGTERM, SIGINT and SIGQUIT is received
     *-------------------------------------------------
     * @param sig, signal id i.e, SIGTERM, SIGINT or SIGQUIT
     * @param info, information about signal
     * @param ctx, contex about signal
     *-------------------------------------------------
     * Signal handler must be ordinary procedure
     *-----------------------------------------------*)
    procedure doTerminate(sig : longint; info : PSigInfo; ctx : PSigContext); cdecl;
    var ch : char;
    begin
        //write one byte to mark termination
        ch := '.';
        fpWrite(terminatePipeOut, ch, 1);
    end;

    (*!-----------------------------------------------
     * install signal handler
     *-------------------------------------------------
     * @param aSig, signal id i.e, SIGTERM, SIGINT or SIGQUIT
     *-----------------------------------------------*)
    procedure installTerminateSignalHandler(aSig : longint);
    var oldAct, newAct : SigactionRec;
    begin
        fillChar(newAct, sizeOf(SigactionRec), #0);
        fillChar(oldAct, sizeOf(Sigactionrec), #0);
        newAct.sa_handler := @doTerminate;
        fpSigaction(aSig, @newAct, @oldAct);
    end;

    procedure makePipeNonBlocking(termPipeIn: longint; termPipeOut : longint);
    begin
        //read control flag and set pipe in to be non blocking
        makeNonBlocking(termPipeIn);

        //read control flag and set pipe out to be non blocking
        makeNonBlocking(termPipeOut);
    end;

initialization

    //setup non blocking pipe to use for signal handler.
    //Need to be done before install handler to prevent race condition
    assignPipe(terminatePipeIn, terminatePipeOut);
    makePipeNonBlocking(terminatePipeIn, terminatePipeOut);

    //install signal handler after pipe setup
    installTerminateSignalHandler(SIGTERM);
    installTerminateSignalHandler(SIGINT);
    installTerminateSignalHandler(SIGQUIT);

finalization

    fpClose(terminatePipeIn);
    fpClose(terminatePipeOut);

end.
