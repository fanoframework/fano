{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit RateTypes;

interface

{$MODE OBJFPC}
{$H+}

type

    TRate = record
        //number of operations allowed
        operations : integer;

        //interval in seconds
        interval : integer;
    end;

    TLimitStatus = record
        limitReached : boolean;
        limit : integer;
        remainingAttempts : integer;
        resetTimestamp : integer;
    end;

implementation

end.
