{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewPushIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * push template string which later be concatenated
     *-------------------------------------------------
     * This is inspired by Laravel Blade @push directive
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IViewPush = interface
        ['{08615F0E-8816-4392-B975-72F02ECF68CF}']

        (*!------------------------------------------------
         * clear all stacked template
         *-----------------------------------------------
         * @param stackName name of stack to clear. if
         *        empty, all will be clear
         *-----------------------------------------------*)
        procedure clear(const stackName : string = '');

        (*!------------------------------------------------
         * push template string
         *-----------------------------------------------
         * @param stackName name of stack
         * @param tpl template string to concat
         * @return current instance
         *-----------------------------------------------*)
        function push(const stackName : string; const tpl : string) : IViewPush;
    end;

implementation
end.
