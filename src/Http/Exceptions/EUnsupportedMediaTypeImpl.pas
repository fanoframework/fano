{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EUnsupportedMediaTypeImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    EHttpExceptionImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when server reject media
     * format because it can not support
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EUnsupportedMediaType = class(EHttpException)
    public
        constructor create(
            const aErrorMsg : string;
            const respHeaders : string = ''
        );

    end;

implementation

    constructor EUnsupportedMediaType.create(
        const aErrorMsg : string;
        const respHeaders : string = ''
    );
    begin
        inherited create(415, 'Unsupported Media Type', aErrorMsg, respHeaders);
    end;

end.
