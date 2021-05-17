{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LibuvImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RunnableIntf;

type

    TlibuvSvrConfig = record
        ip : string;
        port : word;
        useIpv6 : boolean;
        queueSize : integer;
    end;

    TLibuvSocketSvr = class(TInterfacedObkect, IRunnable, IRunnableWithDataNotif)
    private
        fConfig : TlibuvSvrConfig;

    public
        constructor create(const config : TlibuvSvrConfig);

        (*!-----------------------------------------------
         * run socket server until terminated
         *-----------------------------------------------*)
        function run() : IRunnable;

    end;

implementation

uses

    sockets,
    libuv;

type

    write_req_t = record
        req : uv_write_t;
        buf : uv_buf_t;
    end;
    pwrite_req_t = ^write_req_t;

    procedure alloc_buffer(handle : puv_handle_t; suggested_size : size_t; buf : puv_buf_t); cdecl;
    begin
        buf^.base := getmem(suggested_size);
        buf^.len := suggested_size;
    end;

    procedure free_write_req(req : puv_write_t); cdecl;
    var wr : pwrite_req_t;
    begin
        wr := pwrite_req_t(req);
        freemem(wr^.buf.base);
        freemem(wr);
    end;

    procedure echo_write(req : puv_write_t; status : integer); cdecl;
    begin
        if (status <> 0) then
        begin
            writeln(stderr, 'Write error ', uv_strerror(status));
        end;
        free_write_req(req);
    end;

    procedure echo_read(client : puv_stream_t; nread: ssize_t; const buf : puv_buf_t); cdecl;
    var req : pwrite_req_t;
    begin
        if (nread > 0) then
        begin
            req := getmem(sizeof(write_req_t));
            req^.buf := uv_buf_init(buf^.base, nread);
            uv_write(puv_write_t(req), client, @req^.buf, 1, @echo_write);
            exit();
        end;

        if (nread < 0) then
        begin
            if (nread <> UV_EOF) then
                writeln(stderr, 'Read error ', uv_err_name(nread));
            uv_close(puv_handle_t(client), nil);
        end;

        freemem(buf^.base);
    end;

    procedure on_new_connection(svr : puv_stream_t; status : integer); cdecl;
    var client : puv_tcp_t;
    begin
        if (status < 0) then
        begin
            writeln(stderr, 'New connection error ', uv_strerror(status));
            exit;
        end;

        client := getMem(sizeof(uv_tcp_t));
        uv_tcp_init(uv_default_loop(), client);
        if (uv_accept(svr, puv_stream_t(client)) = 0) then
        begin
            uv_read_start(puv_stream_t(client), @alloc_buffer, @echo_read);
        end else
        begin
            uv_close(puv_handle_t(client), nil);
        end;
    end;

    constructor TLibuvSocketSvr.create(const config : TlibuvSvrConfig);
    begin
        fConfig := config;
    end;

    (*!-----------------------------------------------
     * run socket server until terminated
     *-----------------------------------------------*)
    function TLibuvSocketSvr.run() : IRunnable;
    var
        server : uv_tcp_t;
        addr : psockaddr;
        addr4 : sockaddr_in;
        addr6 : sockaddr_in6;
        res : integer;
    begin
        result := self;
        server := default(uv_tcp_t);
        uv_tcp_init(uv_default_loop(), @server);

        if fConfig.useIpv6 then
        begin
            addr6 := default(sockaddr_in6);
            uv_ip6_addr(pansichar(fConfig.ip), fConfig.port, addr6);
            addr := psockaddr(@addr6);
        end else
        begin
            addr4 := default(sockaddr_in);
            uv_ip4_addr(pansichar(fConfig.ip), fConfig.port, addr4);
            addr := psockaddr(@addr4);
        end;

        uv_tcp_bind(@server, addr, 0);

        res := uv_listen(puv_stream_t(@server), fConfig.queueSize, @on_new_connection);

        if (res <> 0) then
        begin
            writeln(stderr, 'Listen error ', uv_strerror(res));
            exit;
        end;

        uv_run(uv_default_loop(), UV_RUN_DEFAULT);
    end;

end.
