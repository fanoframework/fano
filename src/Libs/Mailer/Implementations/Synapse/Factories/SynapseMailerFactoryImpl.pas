{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit SynapseMailerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    AbstractMailerFactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TSynapseMailer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *--------------------------------------------------*)
    TSynapseMailerFactory = class(TAbstractMailerFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    SynapseMailerImpl;

    function TSynapseMailerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TSynapseMailer.create(fMailerConfig);
    end;

end.
