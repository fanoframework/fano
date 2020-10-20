{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HttpClientHandleAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * return handle
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IHttpClientHandleAware = interface
        ['{4AEA0C02-13C0-4D90-BB6E-865CBDF42D75}']

        (*!------------------------------------------------
         * get handle
         *-----------------------------------------------
         * @return handle
         *-----------------------------------------------*)
        function handle(): pointer;
    end;

implementation

end.
