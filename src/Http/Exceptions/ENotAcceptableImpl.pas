{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ENotAcceptableImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when server content
     * negotiation cannot find content conform client request.
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ENotAcceptable = class(EHttpException)
    public
        constructor create(
            const aErrorMsg : string;
            const respHeaders : string = ''
        );

    end;

implementation

    constructor ENotAcceptable.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(406, 'Not Acceptable', aErrorMsg, respHeaders);
    end;

end.
