{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RequestIdentifierIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIntf,
    RateTypes;

type

    (*!------------------------------------------------
     * interface for any class having capability
     * to retrieve identifier from request object
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IRequestIdentifier = interface
        ['{DC654300-7B97-4AA5-AF76-A21CBE67FDF6}']

        (*!------------------------------------------------
         * get identifier from request
         *-----------------------------------------------
         * @param request request object
         * @return identifier string
         *-----------------------------------------------*)
        function getId(const request : IRequest) : shortstring;

        (*!------------------------------------------------
         * property alias of get identifier from request
         *-----------------------------------------------*)
        property id[const request : IRequest] : shortstring read getId; default;
    end;

implementation

end.
