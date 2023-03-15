{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiFrameParserFactoryImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    InjectableObjectImpl,
    FcgiFrameParserIntf,
    FcgiFrameParserFactoryIntf,
    FcgiBaseParserFactoryImpl;

type

    (*!-----------------------------------------------
     * FastCGI Frame Parser Factory
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFcgiFrameParserFactory = class (TFcgiBaseParserFactory)
    public
        (*!------------------------------------------------
         * build frame parser instance
         *-----------------------------------------------
         * @return frame parser instance
         *-----------------------------------------------*)
        function build() : IFcgiFrameParser; override;
    end;

implementation

uses

    MemAllocatorImpl,
    FcgiFrameParserImpl;

    (*!------------------------------------------------
     * build frame parser instance
     *-----------------------------------------------
     * @return frame parser instance
     *-----------------------------------------------*)
    function TFcgiFrameParserFactory.build() : IFcgiFrameParser;
    var mem : TMemAllocator;
    begin
        mem := TMemAllocator.create();
        result := TFcgiFrameParser.create(createRecordFactories(), mem, mem);
    end;

end.
