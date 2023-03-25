{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit HstsConfig;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * configuration for Http Strict Transport Security (RFC 6797)
     *-------------------------------------------------
     * https://www.rfc-editor.org/rfc/rfc6797
     *-------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    THtstConfig = record
        maxAge: integer;
        includeSubDomains: boolean;
    end;

implementation

end.
