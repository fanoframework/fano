{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AppFactoryIntf;

interface

{$MODE OBJFPC}

uses

    AppIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to create
     * IWebApplication instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IWebApplicationFactory = interface
        ['{47D5B42D-6735-47E3-A789-5C51E874B368}']

        function build() : IWebApplication;
    end;

implementation

end.
