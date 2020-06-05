{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CloseableIntf;

interface

{$MODE OBJFPC}

type

    (*!-----------------------------------------------
     * interface for any class that can close something
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ICloseable = interface
        ['{6AD60144-A445-439D-B51E-CACC700E9272}']
        function close() : boolean;
    end;

implementation

end.
