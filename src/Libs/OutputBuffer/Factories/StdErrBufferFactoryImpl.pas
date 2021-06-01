{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit StdErrBufferFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TOutputBuffer
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdErrBufferFactory = class(TFactory, IDependencyFactory)
    public
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    StdErrBufferImpl;

    function TStdErrBufferFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TStdErrBuffer.create();
    end;

end.
