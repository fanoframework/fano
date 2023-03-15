{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ServiceProviderIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf;

type

    {*------------------------------------------------
     * interface for any class having capability to
     * register one or more service factories
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------}
    IServiceProvider = interface
        ['{F8FE93DD-29A1-406C-8A54-1EC3D9AEFD95}']

        (*!--------------------------------------------------------
         * register all services
         *---------------------------------------------------------
         * @param container service container
         *---------------------------------------------------------*)
        procedure register(const container : IDependencyContainer);
    end;

implementation

end.
