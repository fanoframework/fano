{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HeadersFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    (*!------------------------------------------------
     * THeaders factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    THeadersFactory = class(TFactory, IDependencyFactory)
    public
        {*!----------------------------------------
         * build instance
         *-----------------------------------------
         * @param container dependency container instance
         * @return instance of IDependency interface
         *------------------------------------------*}
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    HeadersImpl,
    HashListImpl;

    {*!----------------------------------------
     * build instance
     *-----------------------------------------
     * @param container dependency container instance
     * @return instance of IDependency interface
     *------------------------------------------*}
    function THeadersFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        //create headers instance and one default header Content-Type
        result := (THeaders.create(
            THashList.create()
        )).setHeader('Content-Type', 'text/html') as IDependency;
    end;

end.
