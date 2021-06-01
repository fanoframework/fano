{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ViewPartialIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ViewParametersIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * read template file and replace its content with value
     * and output to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IViewPartial = interface
        ['{220077B3-F4A1-4EEB-91FF-AB3E3A2E85F7}']

        (*!------------------------------------------------
         * read template file, parse and replace its variable
         * and output to string
         *-----------------------------------------------
         * @param templatePath file path of template
         * @param viewParams instance contains view parameters
         * @return string which all variables replaced with value from
         *        view parameters
         *-----------------------------------------------*)
        function partial(
            const templatePath : string;
            const viewParams : IViewParameters
        ) : string;
    end;

implementation
end.
