{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FcgiFrameParserFactoryIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    FcgiFrameParserIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to build
     * FastCGI Frame Parser
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IFcgiFrameParserFactory = interface
        ['{87FCD046-7E8D-4195-84F7-EF6D919F552D}']

        (*!------------------------------------------------
         * build frame parser instance
         *-----------------------------------------------
         * @return frame parser instance
         *-----------------------------------------------*)
        function build() : IFcgiFrameParser;
    end;

implementation

end.
