{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ENotFoundImpl;

interface

{$MODE OBJFPC}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when resource is not found.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ENotFound = class(EHttpException)
    public
        constructor create(
            const aErrorMsg : string;
            const respHeaders : string = ''
        );
    end;

implementation

    constructor ENotFound.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(404, 'Not Found', aErrorMsg, respHeaders);
    end;

end.
