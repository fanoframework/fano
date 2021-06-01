{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EInvalidRequestImpl;

interface

{$MODE OBJFPC}

uses

    sysutils;

type

    (*!------------------------------------------------
     * Exception that is raised when request is invalid
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EInvalidRequest = class(Exception)
    end;

implementation

end.
