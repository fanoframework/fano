{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ScgiParserIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    EnvironmentIntf,
    StreamAdapterIntf,
    ProtocolParserIntf;

type

    (*!-----------------------------------------------
     * Interface for any class having capability to parse
     * SCGI string
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IScgiParser = interface(IProtocolParser)
        ['{D0607EED-62DE-4D37-B9BB-A83ECD66032E}']
    end;

implementation

end.
