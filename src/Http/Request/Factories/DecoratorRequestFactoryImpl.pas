{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecoratorRequestFactoryImpl;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    StdInIntf,
    RequestIntf,
    RequestFactoryIntf;

type
    (*!------------------------------------------------
     * basic decorator request factory class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TDecoratorRequestFactory = class (TInterfacedObject, IRequestFactory)
    protected
        fActualRequestFactory : IRequestFactory;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------
         * @param IRequestFactory actual request factory
         *------------------------------------------------*)
        constructor create(const actualRequestFactory : IRequestFactory);

        (*!------------------------------------------------
         * build instance of IRequest
         *-------------------------------------------------
         * by default it just delegate task to actual factory
         * inherited class may want  to modify this
         *-------------------------------------------------
         * @param ICGIEnvironment CGI environment instance
         * @param IStdIn Standard input instance
         * @return IRequest newly created instance
         *------------------------------------------------*)
        function build(
            const env : ICGIEnvironment;
            const stdIn : IStdIn
        ) : IRequest; virtual;
    end;

implementation

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------
     * @param IRequestFactory actual request factory
     *------------------------------------------------*)
    constructor TDecoratorRequestFactory.create(const actualRequestFactory : IRequestFactory);
    begin
        inherited create();
        fActualRequestFactory := actualRequestFactory;
    end;

    (*!------------------------------------------------
     * build instance of IRequest
     *-------------------------------------------------
     * by default it just delegate task to actual factory
     * inherited class may want  to modify this
     *-------------------------------------------------
     * @param ICGIEnvironment CGI environment instance
     * @param IStdIn Standard input instance
     * @return IRequest newly created instance
     *------------------------------------------------*)
    function TDecoratorRequestFactory.build(
        const env : ICGIEnvironment;
        const stdIn : IStdIn
    ) : IRequest;
    begin
        result := fActualRequestFactory.build(env, stdIn);
    end;

end.
