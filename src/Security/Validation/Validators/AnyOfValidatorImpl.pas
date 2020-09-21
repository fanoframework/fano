{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AnyOfValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    OrValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data that must be any of other validators
     * This is alias for TOrValidator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAnyOfValidator = TOrValidator;

implementation
end.
