{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EMethodNotAllowedImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when request method
     * not allowed. For example route is registerd for POST
     * but route is requested with GET.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EMethodNotAllowed = class(EHttpException)
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

    constructor EMethodNotAllowed.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(405, 'Method Not Allowed', aErrorMsg, respHeaders);
    end;

    constructor EMethodNotAllowed.createFmt(
        const aErrorMsg : string;
        const args: array of const;
        const respHeaders : string = ''
    );
    begin
        inherited createFmt(405, 'Method Not Allowed', aErrorMsg, args, respHeaders);
    end;
end.
