{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit UserAgentFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    RegexIntf,
    ListIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TSendmailMailer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TUserAgentFactory = class(TFactory, IDependencyFactory)
    private
        fRegex : IRegex;
        fList : IList;
    public
        function regex(const regexInst : IRegex) : TUserAgentFactory;
        function list(const listInst : IList) : TUserAgentFactory;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    RegexImpl,
    HashListImpl,
    UserAgentImpl;

    function TUserAgentFactory.regex(const regexInst : IRegex) : TUserAgentFactory;
    begin
        fRegex := regexInst;
        result := self;
    end;

    function TUserAgentFactory.list(const listInst : IList) : TUserAgentFactory;
    begin
        fList := listInst;
        result := self;
    end;

    function TUserAgentFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        if (fRegex = nil) then
        begin
            //use TRegex as default implementation
            fRegex := TRegex.create();
        end;

        if (fList = nil) then
        begin
            //use THashList as default implementation
            fList := THashList.create();
        end;

        result := TUserAgent.create(fRegex, fList);
    end;

end.
