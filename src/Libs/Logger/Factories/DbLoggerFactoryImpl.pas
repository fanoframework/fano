{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit DbLoggerFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TDbLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TDbLoggerFactory = class(TFactory, IDependencyFactory)
    private
        fRdbmsSvcName : string;
        fTableName : string;
        fLevelField : string;
        fMsgField : string;
        fCreatedAtField : string;
        fContextField : string;
    public
        constructor create();
        function rdbmsSvcName(const ardbmsSvcName : string) : TDbLoggerFactory;
        function tableName(const atablename : string) : TDbLoggerFactory;
        function levelField(const aLevelField : string) : TDbLoggerFactory;
        function msgField(const aMsgField : string) : TDbLoggerFactory;
        function createdAtField(const aCreatedAtField : string) : TDbLoggerFactory;
        function contextField(const aContextField : string) : TDbLoggerFactory;
        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    RdbmsIntf,
    DbLoggerImpl;

const

    DEFAULT_RDBMS_SERVICE = 'db';
    DEFAULT_TABLE_NAME = 'logs';
    DEFAULT_LEVEL_COLUMN_NAME = 'level';
    DEFAULT_MSG_COLUMN_NAME = 'msg';
    DEFAULT_CREATED_AT_COLUMN_NAME = 'created_at';
    DEFAULT_CONTEXT_COLUMN_NAME = 'context';

    constructor TDbLoggerFactory.create();
    begin
        fRdbmsSvcName := DEFAULT_RDBMS_SERVICE;
        fTableName := DEFAULT_TABLE_NAME;
        fLevelField := DEFAULT_LEVEL_COLUMN_NAME;
        fMsgField := DEFAULT_MSG_COLUMN_NAME;
        fCreatedAtField := DEFAULT_CREATED_AT_COLUMN_NAME;
        fContextField := DEFAULT_CONTEXT_COLUMN_NAME;
    end;

    function TDbLoggerFactory.rdbmsSvcName(const ardbmsSvcName : string) : TDbLoggerFactory;
    begin
        fRdbmsSvcName := ardbmsSvcName;
        result := self
    end;

    function TDbLoggerFactory.tableName(const atablename : string) : TDbLoggerFactory;
    begin
        fTableName := atablename;
        result := self
    end;

    function TDbLoggerFactory.levelField(const aLevelField : string) : TDbLoggerFactory;
    begin
        fLevelField := aLevelField;
        result := self
    end;

    function TDbLoggerFactory.msgField(const aMsgField : string) : TDbLoggerFactory;
    begin
        fMsgField := aMsgField;
        result := self
    end;

    function TDbLoggerFactory.createdAtField(const aCreatedAtField : string) : TDbLoggerFactory;
    begin
        fCreatedAtField := aCreatedAtField;
        result := self
    end;

    function TDbLoggerFactory.contextField(const aContextField : string) : TDbLoggerFactory;
    begin
        fContextField := aContextField;
        result := self
    end;

    function TDbLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    var rdbms : IRdbms;
    begin
        rdbms := container[fRdbmsSvcName] as IRdbms;
        result := TDbLogger.create(
            rdbms,
            fTableName,
            fLevelField,
            fMsgField,
            fCreatedAtField,
            fContextField
        );
    end;

end.
