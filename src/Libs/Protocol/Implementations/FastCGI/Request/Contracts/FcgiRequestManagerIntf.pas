{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRequestManagerIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiRecordIntf,
    EnvironmentIntf,
    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to manage
     * FastCGI requests multiplexing
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiRequestManager = interface
        ['{08E7C3A3-1E4D-4166-BA91-0BCFA03923C7}']

        (*!------------------------------------------------
         * test if request identified by id exist
         *-----------------------------------------------
         * @param requestId, request id to check
         * @return true if request identified by id exist
         *-----------------------------------------------*)
        function has(const requestId : word) : boolean;

        (*!------------------------------------------------
         * test if web server is done sending request
         * to us identified by id
         *-----------------------------------------------
         * @param requestId, request id to check
         * @return true if request identified by id is complete
         *-----------------------------------------------*)
        function complete(const requestId : word) : boolean;

        (*!------------------------------------------------
         * test if web server ask to keep connection open
         *-----------------------------------------------
         * @param requestId, request id to check
         * @return true if request identified by id need to be keep open
         *-----------------------------------------------*)
        function keepConnection(const requestId : word) : boolean;

        (*!------------------------------------------------
         * get data from all FCGI_STDIN identified by request id
         *-----------------------------------------------
         * @param requestId, request id
         * @return stream instance of all FCGI_STDIN records
         *-----------------------------------------------*)
        function getStdInStream(const requestId : word) : IStreamAdapter;

        (*!------------------------------------------------
         * get CGI Environment for request identified by request id
         *-----------------------------------------------
         * @param requestId, request id
         * @return CGI environment or nil if environment not ready
         *-----------------------------------------------*)
        function getEnvironment(const requestId : word) : ICGIEnvironment;

        (*!------------------------------------------------
         * add FastCGI record to manager
         *-----------------------------------------------
         * @param rec, FastCGI record to add
         * @return id of current request
         *-----------------------------------------------*)
        function add(const rec : IFcgiRecord) : IFcgiRequestManager;

        (*!------------------------------------------------
         * remove request
         *-----------------------------------------------
         * @param requestId, request id to be removed
         * @return true of request is removed
         *-----------------------------------------------*)
        function remove(const requestId : word) : boolean;
    end;

implementation

end.
