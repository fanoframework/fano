{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UploadedFileCollectionFactoryIntf;

interface

{$MODE OBJFPC}

uses

    UploadedFileCollectionIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability create
     * instance of IUploadedFileCollection
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUploadedFileCollectionFactory = interface
        ['{6D82B6AB-B8B6-42F7-811C-C339082E3021}']

        function createCollection() : IUploadedFileCollection;
    end;

implementation

end.
