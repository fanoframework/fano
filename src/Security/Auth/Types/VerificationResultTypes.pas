{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit VerificationResultTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * record that stores token verification result
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TVerificationResult = record
        verified : boolean;
        credential : string;
    end;

implementation

end.
