{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit KeyIntValueMapImpl;

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
    TKeyIntValueMap = specialize TFPGMap<shortstring, integer>;

implementation
end.
