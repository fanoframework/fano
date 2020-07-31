{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ESessionExpiredImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils;

type

    (*!------------------------------------------------
     * Exception that is raised when session has expired
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ESessionExpired = class(Exception);

implementation

end.
