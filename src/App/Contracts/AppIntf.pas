{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AppIntf;

interface

{$MODE OBJFPC}

uses

    RunnableIntf;

type

    (*!------------------------------------------------
     * interface for any application
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IWebApplication = interface(IRunnable)
        ['{DE7521ED-D26F-4E97-9618-D745D38F0814}']
    end;

implementation

end.
