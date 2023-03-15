{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SameValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    ConfirmedValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate data that must be equal to other field.
     * This is alias name for TConfirmedValidator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TSameValidator = TConfirmedValidator;

implementation
end.
