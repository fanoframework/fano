{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ESessionInvalidImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SysUtils;

type


    (*!------------------------------------------------
     * Exception that is raised when valid session
     * cannot be found in storage
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ESessionInvalid = class(Exception);

implementation

end.
