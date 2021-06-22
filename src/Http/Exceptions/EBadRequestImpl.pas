{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EBadRequestImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when request syntax is invalid.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EBadRequest = class(EHttpException)
    public
        constructor create(
            const aErrorMsg : string;
            const respHeaders : string = ''
        );

        constructor createFmt(
            const aErrorMsg : string;
            const args: array of const;
            const respHeaders : string = ''
        );
    end;

implementation

    constructor EBadRequest.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(400, 'Bad Request', aErrorMsg, respHeaders);
    end;

    constructor EBadRequest.createFmt(
        const aErrorMsg : string;
        const args: array of const;
        const respHeaders : string = ''
    );
    begin
        inherited createFmt(400, 'Bad Request', aErrorMsg, args, respHeaders);
    end;

end.
