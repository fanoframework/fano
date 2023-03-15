{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyValueTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * Data type to store key value pair
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKeyValue = record
        key : shortstring;
        value : string;
    end;
    PKeyValue = ^TKeyValue;

    TArrayOfKeyValue = array of TKeyValue;

    function NewKeyValue(const key : shortstring; value : string) : PKeyValue;
    procedure DisposeKeyValue(keyVal : PKeyValue);

implementation

    function NewKeyValue(const key : shortstring; value : string) : PKeyValue;
    begin
        new(result);
        result^.key := key;
        result^.value := value;
    end;

    procedure DisposeKeyValue(keyVal : PKeyValue);
    begin
        dispose(keyVal);
    end;

end.
