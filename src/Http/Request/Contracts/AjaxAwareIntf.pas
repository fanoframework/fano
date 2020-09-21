{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AjaxAwareIntf;

interface

{$MODE OBJFPC}

type

    (*!------------------------------------------------
     * interface for any class having capability as
     * to test if HTTP request is AJAX request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IAjaxAware = interface
        ['{40E50D4E-60F7-4763-B975-ACDDBA4C365C}']

        (*!------------------------------------------------
         * test if current request is coming from AJAX request
         *-------------------------------------------------
         * @return true if ajax request false otherwise
         *------------------------------------------------*)
        function isXhr() : boolean;
    end;

implementation
end.
