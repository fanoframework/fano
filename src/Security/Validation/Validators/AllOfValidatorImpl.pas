{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AllOfValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    CompositeValidatorImpl;

type

    (*!------------------------------------------------
     * basic class having capability to
     * validate several validator with AND boolean operator.
     * This is alias name for TCompositeValidator
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TAllOfValidator = TCompositeValidator;

implementation
end.