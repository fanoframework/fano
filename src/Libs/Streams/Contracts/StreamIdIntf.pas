{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StreamIdIntf;

interface

{$MODE OBJFPC}
{$H+}


type

    (*!-----------------------------------------------
     * Interface for any class having capability to
     * return object id
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IStreamId = interface
        ['{5241F697-5800-4F85-B51E-20D68868E498}']

        (*!------------------------------------------------
        * get object id
        *-----------------------------------------------
        * @return id of object
        *-----------------------------------------------*)
        function getId() : shortstring;

    end;

implementation

end.
