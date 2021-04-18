{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit UwsgiParserIntf;

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
     * uwsgi protocol binary data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IUwsgiParser = interface(IProtocolParser)
        ['{A678943F-AE7A-4A5F-BD74-505B859E9CE0}']
    end;

implementation

end.
