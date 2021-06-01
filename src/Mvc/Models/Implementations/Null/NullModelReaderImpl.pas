{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit NullModelReaderImpl;

interface

{$MODE OBJFPC}

uses

    ModelParamsIntf,
    ModelResultSetIntf,
    ModelReaderIntf,
    InjectableObjectImpl;

type

    (*!------------------------------------------------
     * null model reader implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TNullModelReader = class(TInjectableObject, IModelReader)
    private
        fNullResultSet : IModelResultSet;
    public
        constructor create();
        destructor destroy(); override;

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

uses

    NullModelResultSetImpl;

    constructor TNullModelReader.create();
    begin
        fNullResultSet := TNullModelResultSet.create();
    end;

    destructor TNullModelReader.destroy();
    begin
        fNullResultSet := nil;
        inherited destroy();
    end;

    (*!----------------------------------------------
     * read data from storage
     *-----------------------------------------------
     * @param params parameter for search/filtering
     * @return model data
     *-----------------------------------------------*)
    function TNullModelReader.read(const params : IModelParams = nil) : IModelResultSet;
    begin
        //intentionally does nothing
        result := fNullResultSet;
    end;

    (*!----------------------------------------------
     * return data instance after read() is execute
     *-----------------------------------------------
     * @return model data
     *-----------------------------------------------*)
    function TNullModelReader.data() : IModelResultSet;
    begin
        //intentionally does nothing
        result := fNullResultSet;
    end;

end.
