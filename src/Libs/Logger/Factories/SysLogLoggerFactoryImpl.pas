{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit SysLogLoggerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TSysLogLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TSysLogLoggerFactory = class(TFactory, IDependencyFactory)
    private
        fPrefix : string;
        fOption : integer;
        fFacility : integer;
    public
        constructor create();
        function prefix(const aprefix : string) : TSysLogLoggerFactory;
        function option(const opt : integer) : TSysLogLoggerFactory;
        function facility(const fac : integer) : TSysLogLoggerFactory;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    SysLogLoggerImpl;

    constructor TSysLogLoggerFactory.create();
    begin
        inherited create();
        fPrefix := '';
        fOption := -1;
        fFacility := -1;
    end;

    function TSysLogLoggerFactory.prefix(const aprefix : string) : TSysLogLoggerFactory;
    begin
        fPrefix := aprefix;
        result := self;
    end;

    function TSysLogLoggerFactory.option(const opt : integer) : TSysLogLoggerFactory;
    begin
        fOption := opt;
        result := self;
    end;

    function TSysLogLoggerFactory.facility(const fac : integer) : TSysLogLoggerFactory;
    begin
        fFacility := fac;
        result := self;
    end;

    function TSysLogLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TSysLogLogger.create(fPrefix, fOption, fFacility);
    end;

end.
