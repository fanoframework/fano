{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ResponseFactoryIntf;

interface

{$MODE OBJFPC}

uses

    EnvironmentIntf,
    ResponseIntf;

type
    (*!------------------------------------------------
     * interface for any class having capability
     * to build response instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *---------------------------------------------------*)
    IResponseFactory = interface
        ['{05A648AA-8AC1-4068-87F4-269D9A8D6C58}']
        function build(const env : ICGIEnvironment) : IResponse;
    end;

implementation

end.
