{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DependencyListIntf;

interface

{$MODE OBJFPC}

uses

    ListIntf;

type

    {------------------------------------------------
     interface for any class having capability to
     dependencies
     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    IDependencyList = interface(IList)
        ['{BBDB53E2-D4DF-4FD0-86D4-2291124236B1}']
    end;

implementation
end.
