{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ValidationRulesIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ValidatorIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * manage validation rule
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IValidationRules = interface
        ['{3D126C2E-C04B-457D-ACC7-5DE785AADD72}']


        (*!------------------------------------------------
         * Add rule and its validator
         *-------------------------------------------------
         * @param key name of field in GET, POST request input data
         * @return current validation rules
         *-------------------------------------------------*)
        function addRule(const key : shortstring; const validator : IValidator) : IValidationRules;
    end;

implementation

end.
