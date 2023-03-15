{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientOptsIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to set
     * HTTP request options before send request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpClientOpts = interface
        ['{E38B43A2-B25D-4AEF-85AB-1A153563541D}']

        (*!------------------------------------------------
         * set HTTP client options
         *-----------------------------------------------
         * @param optName option to set
         * @param optValue option value
         * @return current instance
         *-----------------------------------------------*)
        function setOpt(
            const optName : string;
            const optValue : integer
        ) : IHttpClientOpts;

        (*!------------------------------------------------
         * get HTTP client options
         *-----------------------------------------------
         * @param optName option to get
         * @return option value
         *-----------------------------------------------*)
        function getOpt(const opt : string): integer;

    end;

implementation

end.
