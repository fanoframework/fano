{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit ContainerFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyContainerIntf;

type

    {------------------------------------------------
     interface for any class having capability to
     create IDependencyContainer instance

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    IContainerFactory = interface
        ['{280DEBEF-40D1-441F-BEE9-B7901CCDB8AD}']

        {*!----------------------------------------
         * build instance
         *-----------------------------------------
         * @param container dependency container instance
         * @return instance of IDependency interface
         *------------------------------------------*}
        function build() : IDependencyContainer;
    end;

implementation

end.
