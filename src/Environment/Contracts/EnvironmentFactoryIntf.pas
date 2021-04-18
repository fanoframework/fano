{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EnvironmentFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to create
     * CGI environment instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ICGIEnvironmentFactory = interface
        ['{43ECF7FA-A002-4465-8318-07641FBBA862}']

        function build() : ICGIEnvironment;
    end;

implementation
end.
