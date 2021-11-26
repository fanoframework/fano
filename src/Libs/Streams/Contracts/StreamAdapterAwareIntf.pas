{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterAwareIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * return stream adapter instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStreamAdapterAware = interface
        ['{7C2EA47A-9746-4EB6-B66E-B21FB8BB9529}']

        (*!------------------------------------------------
         * get stream
         *-----------------------------------------------
         * @return stream
         *-----------------------------------------------*)
        function data() : IStreamAdapter;
    end;

implementation

end.
