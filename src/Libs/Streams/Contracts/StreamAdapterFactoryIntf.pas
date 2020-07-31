{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamAdapterFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    StreamAdapterIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * create stream adapter instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStreamAdapterFactory = interface
        ['{48866E39-920B-4179-B080-19D4AB0F7700}']

        (*!------------------------------------------------
         * create stream
         *-----------------------------------------------
         * @return stream
         *-----------------------------------------------*)
        function build() : IStreamAdapter;
    end;

implementation

end.
