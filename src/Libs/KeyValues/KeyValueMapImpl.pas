{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyValueMapImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    fgl;

type

    (*!------------------------------------------------
     * basic class having capability to store key value
     * pair
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TKeyValueMap = specialize TFPGMap<shortstring, string>;

implementation
end.
