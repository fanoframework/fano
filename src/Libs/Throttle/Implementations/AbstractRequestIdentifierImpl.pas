{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit AbstractRequestIdentifierImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    RequestIdentifierIntf,
    RequestIntf;

type

    (*!------------------------------------------------
     * abstract request identifier implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TAbstractRequestIdentifier = class abstract (TInterfacedObject, IRequestIdentifier)
    public
        (*!------------------------------------------------
         * get identifier from request
         *-----------------------------------------------
         * @param request request object
         * @return identifier string
         *-----------------------------------------------*)
        function getId(const request : IRequest) : shortstring; virtual; abstract;
    end;

implementation

end.
