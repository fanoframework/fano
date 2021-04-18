{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit JwtAlgIntf;

interface

{$MODE OBJFPC}
{$H+}

type

    (*!------------------------------------------------
     * base interface for any JWT algorithm class
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    IJwtAlg = interface
        ['{CC564C04-A606-4DDB-A28F-7765AEB9D70F}']

        (*!------------------------------------------------
         * get JWT algorithm name
         *-------------------------------------------------
         * @return string name of algorithm
         *-------------------------------------------------*)
        function name() : shortstring;

    end;

implementation

end.
