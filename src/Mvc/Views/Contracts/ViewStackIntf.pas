{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewStackIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf,
    ViewPushIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * pushed template strings and render as concatenated
     * template
     *-------------------------------------------------
     * This is inspired by Laravel Blade @stack directive
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IViewStack = interface
        ['{6B173B11-3851-44AA-819E-28D060C7AD05}']

        (*!------------------------------------------------
         * concat all templates and rendered them as string
         *-----------------------------------------------
         * @param stackName name of stack
         * @param viewParams instance contains view parameters
         * @return string which all variables replaced with value from
         *        view parameters
         *-----------------------------------------------*)
        function stack(
            const stackName : string;
            const viewParams : IViewParameters
        ) : string;

        (*!------------------------------------------------
         * get instance of IViewPush related to this
         *-----------------------------------------------
         * @return IViewPush instance
         *-----------------------------------------------*)
        function getPusher() : IViewPush;
        property pusher : IViewPush read getPusher;
    end;

implementation
end.
