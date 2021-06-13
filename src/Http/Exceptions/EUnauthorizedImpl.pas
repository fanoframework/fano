{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EUnauthorizedImpl;

interface

{$MODE OBJFPC}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when client must
     * authenticate first.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EUnauthorized = class(EHttpException)
    public
        constructor create(
            const aErrorMsg : string;
            const respHeaders : string = ''
        );
    end;

implementation

    constructor EUnauthorized.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(401, 'Unauthorized', aErrorMsg, respHeaders);
    end;

end.
