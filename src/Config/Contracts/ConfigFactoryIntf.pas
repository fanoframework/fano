{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ConfigFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf,
    ConfigIntf;

type

    (*!------------------------------------------------------------
     * interface for any class having capability to create application
     * config instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------------------*)
    IConfigFactory = interface
        ['{33E01657-A921-4C9F-8199-239E18C212AB}']


        (*!------------------------------------------------
         * build application configuration instance
         *-------------------------------------------------
         * @return newly created configuration instance
         *-------------------------------------------------*)
        function createConfig(const container : IDependencyContainer) : IAppConfiguration;
    end;

implementation
end.
