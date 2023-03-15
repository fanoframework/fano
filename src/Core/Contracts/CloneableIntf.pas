{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit CloneableIntf;

interface

{$MODE OBJFPC}

type

    (*!-----------------------------------------------
     * interface for any class that can clone itself
     * as new instance
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    ICloneable = interface
        ['{ED9890E5-F8CA-4544-ADC7-495E6BB2650E}']
        function clone() : ICloneable;
    end;

implementation

end.
