{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ThrottleRequestIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    RateTypes;

type

    (*!------------------------------------------------
     * interface for HTTP request with additional rate
     * limiting data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IThrottleRequest = interface(IRequest)
        ['{763D916C-EDD8-4873-A5AD-7749D014AC1D}']

        (*!------------------------------------------------
         * get rate limit status
         *-------------------------------------------------
         * @return limit status of current request
         *------------------------------------------------*)
        function getLimitStatus() : TLimitStatus;
        property limitStatus : TLimitStatus read getLimitStatus;
    end;

implementation
end.
