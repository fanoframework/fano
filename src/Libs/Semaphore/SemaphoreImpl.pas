{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SemaphoreImpl;

interface

{$MODE OBJFPC}

type

    (*!------------------------------------------------
     * counting semaphore implementation
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSemaphore = class
    private
        fCount : longint;
        fAvailEvent : PRTLEvent;
    public
        constructor create(const count : longint);
        destructor destroy(); override;
        procedure acquire();
        procedure release();
    end;

implementation

    constructor TSemaphore.create(const count : longint);
    begin
        fCount := count;
        fAvailEvent := RTLEventCreate();
    end;

    destructor TSemaphore.destroy();
    begin
        RTLEventDestroy(fAvailEvent);
        inherited destroy();
    end;

    procedure TSemaphore.acquire();
    begin
        if (InterLockedDecrement(fCount) < 0) then
        begin
            RTLEventWaitFor(fAvailEvent);
        end;
    end;

    procedure TSemaphore.release();
    begin
        if (InterLockedIncrement(fCount) > 0) then
        begin
            RTLEventSetEvent(fAvailEvent);
        end;

    end;

end.
