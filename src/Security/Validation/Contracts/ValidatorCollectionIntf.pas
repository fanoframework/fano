{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ValidatorCollectionIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestValidatorIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * manage request validator instances
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)
    IValidatorCollection = interface
        ['{D842D49C-09AF-4842-8712-B6C12AFB5C5B}']

        (*!------------------------------------------------
         * Add request validator to collection
         *-------------------------------------------------
         * @param name name of request validator
         * @param validator request validator instance to add
         * @return current validator collection
         *-------------------------------------------------*)
        function add(const name : shortstring; const validator : IRequestValidator) : IValidatorCollection;

        (*!------------------------------------------------
         * get request validator by name
         *-------------------------------------------------
         * @param name name of request validator
         * @return request validator instance
         *-------------------------------------------------*)
        function get(const name : shortstring) : IRequestValidator;
    end;

implementation

end.
