{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterCollectionIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * manage multiple stream adapter instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStreamAdapterCollection = interface
        ['{76E3045A-8F25-4F93-B2A5-75B972EB2235}']

        (*!------------------------------------------------
         * add stream
         *-----------------------------------------------
         * @return current stream collection
         *-----------------------------------------------*)
        function add(const stream : IStreamAdapter) : IStreamAdapterCollection;
    end;

implementation

end.
