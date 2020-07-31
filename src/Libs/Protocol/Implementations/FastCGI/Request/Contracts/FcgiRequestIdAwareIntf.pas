{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRequestIdAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * return request id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiRequestIdAware = interface
        ['{9718C418-55F4-4435-B575-965389D836A4}']

        (*!------------------------------------------------
         * get request id
         *-----------------------------------------------
         * @return request id
         *-----------------------------------------------*)
        function getRequestId() : word;
    end;

implementation

end.
