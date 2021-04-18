{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit DecrypterIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * decrypt string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IDecrypter = interface
        ['{6E566A5C-E6AC-45CD-85E0-AE0A2DE2279D}']

        (*!------------------------------------------------
         * decrypt string
         *-----------------------------------------------
         * @param encryptedStr encrypted string
         * @return original string
         *-----------------------------------------------*)
        function decrypt(const encryptedStr : string) : string;

    end;

implementation

end.
