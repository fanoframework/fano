{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EHeaderNotSetImpl;

interface

{$MODE OBJFPC}

uses

    EUnprocessableEntityImpl;

type

    (*!------------------------------------------------
     * Exception that is raised when header is not set
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    EHeaderNotSet = class(EUnprocessableEntity);

implementation

end.
