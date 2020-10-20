{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit TokenGeneratorIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    fpjson;

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * authenticate credential
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    ITokenGenerator = interface
        ['{5E8A84EF-2B68-4AD4-9902-41051526132F}']

        (*!------------------------------------------------
         * generate token
         *-------------------------------------------------
         * @param payload JSON of input data
         * @return string generated token
         *-------------------------------------------------*)
        function generateToken(const payload : TJSONObject) : string;

    end;

implementation

end.
