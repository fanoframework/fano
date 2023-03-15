{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ModelReaderIntf;

interface

{$MODE OBJFPC}

uses

    ModelParamsIntf,
    ModelResultSetIntf;

type

    (*!------------------------------------------------
     * interface for model that can retrieve data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IModelReader = interface
        ['{8066B3EE-A1F6-4971-8545-1BC741333986}']

        (*!----------------------------------------------
         * read data from storage
         *-----------------------------------------------
         * @param params parameter for search/filtering
         * @return model data
         *-----------------------------------------------*)
        function read(const params : IModelParams = nil) : IModelResultSet;

        (*!----------------------------------------------
         * return data instance after read() is execute
         *-----------------------------------------------
         * @return model data
         *-----------------------------------------------*)
        function data() : IModelResultSet;
    end;

implementation

end.
