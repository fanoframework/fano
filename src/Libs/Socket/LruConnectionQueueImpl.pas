{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LruConnectionQueueImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    gpriorityqueue;

type

    TLruFileDesc = record
        fds : longint;
        timestamp : int64;
    end;

    TLruComparator = class
    public
        class function c(a,b: TLruFileDesc) : boolean; inline;
    end;

    TLruConnectionQueue = specialize TPriorityQueue<TLruFileDesc, TLruComparator>;

implementation

    class function TLruComparator.c(a,b: TLruFileDesc) : boolean; inline;
    begin
        //last recent used file descriptor will have bigger timestamp
        //and should have bigger priority
        result := a.timestamp > b.timestamp;
    end;

end.
