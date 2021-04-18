{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ClientBrowserIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * get client browser identifier
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IClientBrowser = interface
        ['{322490CD-125E-43AB-8167-EA28EAB9D964}']

        function isBrowser(const browserName : shortstring) : boolean;
        property browser[const browserName : shortstring] : boolean read isBrowser;
    end;

implementation
end.
