{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EInvalidMethodImpl;

interface

{$MODE OBJFPC}

uses

    ENotImplementedImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when HTTP method verb is invalid
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EInvalidMethod = class(ENotImplemented);

resourcestring

    sErrInvalidMethod = 'Invalid method %s';

implementation

end.
