{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (GPL 3.0)
 *}
unit EKeyNotFoundImpl;

interface

{$MODE OBJFPC}

uses

    sysutils;

type

    (*!------------------------------------------------
     * Exception that is raised when view parameters
     * can not find specified key
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    EKeyNotFound = class(Exception)
    end;

implementation

end.