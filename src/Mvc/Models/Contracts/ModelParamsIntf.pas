{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ModelParamsIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf;

type

    (*!------------------------------------------------
     * interface that store model parameter data
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IModelParams = interface(ISerializeable)
        ['{6CB5843D-56E3-4012-AB5B-7A354A0EE5D3}']

        function writeString(const key : shortstring; const value : string) : IModelParams;
        function writeInteger(const key : shortstring; const value : integer) : IModelParams;

        function readString(const key : shortstring) : string;
        function readInteger(const key : shortstring) : integer;
    end;

implementation

end.
