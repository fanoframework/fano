{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit EncrypterIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to
     * encrypt string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IEncrypter = interface
        ['{0655F1C5-687C-4E84-B291-7F3E124D19D5}']

        (*!------------------------------------------------
         * encrypt string
         *-----------------------------------------------
         * @param originalStr original string
         * @return encrypted string
         *-----------------------------------------------*)
        function encrypt(const originalStr : string) : string;

    end;

implementation

end.
