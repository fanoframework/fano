{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionIdGeneratorFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SessionIdGeneratorIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * create session id generator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ISessionIdGeneratorFactory = interface
        ['{17E824A6-55BA-44EB-BF83-8ABB06A9AA99}']

        (*!------------------------------------
         * build session id generator instance
         *-------------------------------------
         * @return session id generator instance
         *-------------------------------------*)
        function build() : ISessionIdGenerator;
    end;

implementation
end.
