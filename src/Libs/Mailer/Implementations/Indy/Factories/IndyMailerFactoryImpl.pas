{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit IndyMailerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    AbstractMailerFactoryImpl,
    MailerConfigTypes;

type

    (*!------------------------------------------------
     * factory class for TIndyMailer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TIndyMailerFactory = class(TAbstractMailerFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    IndyMailerImpl;

    function TIndyMailerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TIndyMailer.create(fMailerConfig);
    end;

end.
