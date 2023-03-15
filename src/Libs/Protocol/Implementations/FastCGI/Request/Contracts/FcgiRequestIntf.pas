{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiRequestIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!-----------------------------------------------
     * Interface for any class having capability to hold
     * FastCGI request
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiRequest = interface
        ['{32C2BC0A-AF97-4EA0-A205-71F1FF05BFD5}']

        (*!------------------------------------------------
        * get current request id
        *-----------------------------------------------
        * @return id of current request
        *-----------------------------------------------*)
        function id() : word;
    end;

implementation

end.
