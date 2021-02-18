{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterCollectionFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterCollectionIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * create stream adapter collection instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStreamAdapterCollectionFactory = interface
        ['{AC04976A-02A7-46A1-8FFF-789CDFFB6800}']

        (*!------------------------------------------------
         * create stream collection
         *-----------------------------------------------
         * @return stream collection
         *-----------------------------------------------*)
        function build() : IStreamAdapterCollection;
    end;

implementation

end.
