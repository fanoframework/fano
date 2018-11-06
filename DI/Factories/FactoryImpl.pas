{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (GPL 3.0)
 *}
unit FactoryImpl;

interface

{$MODE OBJFPC}

uses
    DependencyIntf,
    DependencyContainerIntf;

type
    {------------------------------------------------
     base class for any class having capability to create
     other object

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TFactory = class(TInterfacedObject, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; virtual; abstract;
    end;

implementation

end.
