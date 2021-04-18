{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyValuePairIntf;

interface

{$MODE OBJFPC}
{$H+}

uses

    ReadOnlyKeyValuePairIntf;

type

    (*!------------------------------------------------
     * interface for any class having capability key value
     * pair
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    IKeyValuePair = interface(IReadOnlyKeyValuePair)
        ['{28ECD547-C550-4CEF-8E8B-BFA0B1DF6CEC}']

        (*!------------------------------------------------
         * set key value pair
         *-----------------------------------------------
         * @param key name to use
         * @param val value to use
         * @return current instance
         *-----------------------------------------------*)
        function setValue(const keyName : shortstring; const val : string) : IKeyValuePair;

        (*!------------------------------------------------
         * unset key
         *-----------------------------------------------
         * @param key name to use
         * @return current instance
         * @throws EKeyNotFound exception if not set
         *-----------------------------------------------*)
        function unset(const keyName : shortstring) : IKeyValuePair;

    end;

implementation
end.
