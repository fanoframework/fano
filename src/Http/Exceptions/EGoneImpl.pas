{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EGoneImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when requested resource
     * no longer available and there is no forwarding address.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EGone = class(EHttpException)
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

    constructor EGone.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(410, 'Gone', aErrorMsg, respHeaders);
    end;

    constructor EGone.createFmt(
        const aErrorMsg : string;
        const args: array of const;
        const respHeaders : string = ''
    );
    begin
        inherited createFmt(410, 'Gone', aErrorMsg, args, respHeaders);
    end;

end.
