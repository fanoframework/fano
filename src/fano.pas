{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit fano;

interface

{$MODE OBJFPC}

uses

    {$INCLUDE Includes/interfaces.inc}
    {$INCLUDE Includes/implementations.inc}
    {$INCLUDE Includes/types.inc}

type
    (*!-----------------------------------------------
     * Redeclare all classes in one unit to simplify
     * using classes in application code
     *-------------------------------------------------
     * If you use this unit, then you do not need to include
     * other unit otherwise you will get compilation error
     * about duplicate identifier
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *------------------------------------------------*)

    {$INCLUDE Includes/interfaces.aliases.inc}
    {$INCLUDE Includes/implementations.aliases.inc}

implementation

end.
