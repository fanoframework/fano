{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CircularDepAvoidFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf;

type

    (*!------------------------------------------------
     * internal decorator factory class that add test for
     * circular dependency when creating a service.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCircularDepAvoidFactory = class(TInterfacedObject, IDependencyFactory)
    private
        //internal variable that marks
        //if service is currently being created
        fConstructing : boolean;

        //service name currently being created
        fServiceName : shortstring;

        //factory for service name currently being created
        fActualFactory : IDependencyFactory;
    public
        constructor create(
            const serviceName : shortstring;
            const actualFactory : IDependencyFactory
        );
        destructor destroy(); override;

        (*!---------------------------------------------------
         * build class instance
         *----------------------------------------------------
         * @param container dependency container instance
         *---------------------------------------------------*)
        function build(const container : IDependencyContainer) : IDependency;
    end;

implementation

uses

    ECircularDependencyImpl;

resourcestring

    sErrCircularDependency = 'Circular dependency when creating service "%s"';

    constructor TCircularDepAvoidFactory.create(
        const serviceName : shortstring;
        const actualFactory : IDependencyFactory
    );
    begin
        fServiceName := serviceName;
        fActualFactory := actualFactory;
        fConstructing := false;
    end;

    destructor TCircularDepAvoidFactory.destroy();
    begin
        fActualFactory := nil;
        fConstructing := false;
        inherited destroy();
    end;

    (*!---------------------------------------------------
     * build class instance
     *----------------------------------------------------
     * @param container dependency container instance
     *---------------------------------------------------*)
    function TCircularDepAvoidFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        if fConstructing then
        begin
            //circular dependency detected
            raise ECircularDependency.createFmt(
                sErrCircularDependency,
                [ fServiceName ]
            );
        end;

        fConstructing := true;
        try
            result := fActualFactory.build(container);
        finally
            fConstructing := false;
        end;
    end;
end.
