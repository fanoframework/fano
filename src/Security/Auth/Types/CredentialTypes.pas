{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CredentialTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    TCredential = record
        username : string;
        password : string;

        //additional user-related data
        salt : string;
        data : pointer;
    end;

    TCredentials = array of TCredential;

implementation

end.
