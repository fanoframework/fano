{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileUtils;

interface

{$MODE OBJFPC}
{$H+}


    (*!------------------------------------------------
     * file utilities function collection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)

    (*!------------------------------------------------
     * read file to string
     *-----------------------------------------------
     * @param filepath file to load
     * @returns contents of file as string
     *-----------------------------------------------*)
    function readFile(const filepath : string) : string;

implementation

uses

    FileReaderIntf,
    StringFileReaderImpl;

    (*!------------------------------------------------
     * read file to string
     *-----------------------------------------------
     * @param filepath file to load
     * @returns contents of file as string
     *-----------------------------------------------*)
    function readFile(const filepath : string) : string;
    var fileReader : IFileReader;
    begin
        fileReader := TStringFileReader.create();
        result := fileReader.readFile(filepath);
    end;
end.
