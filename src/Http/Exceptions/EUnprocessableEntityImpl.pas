{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EUnprocessableEntityImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when well-formed request
     * contain semantic error
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EUnprocessableEntity = class(EHttpException)
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

    constructor EUnprocessableEntity.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(422, 'Unprocessable Entity', aErrorMsg, respHeaders);
    end;

    constructor EUnprocessableEntity.createFmt(
        const aErrorMsg : string;
        const args: array of const;
        const respHeaders : string = ''
    );
    begin
        inherited createFmt(422, 'Unprocessable Entity', aErrorMsg, args, respHeaders);
    end;

end.
