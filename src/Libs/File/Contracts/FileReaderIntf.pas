{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileReaderIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * interface for any class having capability to read
     * file content to string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFileReader = interface
        ['{18E68492-86C7-43C5-80B6-0364FCA8F235}']

        (*!------------------------------------------------
         * read file content to string
         *-----------------------------------------------
         * @param filePath path of file to be read
         * @return file content
         *-----------------------------------------------*)
        function readFile(const filePath : string) : string;
    end;

implementation

end.
