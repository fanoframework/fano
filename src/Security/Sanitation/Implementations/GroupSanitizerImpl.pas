{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit GroupSanitizerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SanitizerIntf;

type

    TSanitizerArray = array of ISanitizer;

    (*!------------------------------------------------
     * class sanitizes using several external sanitizers
     * to allow several sanitizer to be combined as one
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TGroupSanitizer = class(TInterfacedObject, ISanitizer)
    private
        fSanitizers : TSanitizerArray;
    public

        (*!------------------------------------------------
         * constructor
         *-----------------------------------------------
         * @param sanitizers array of ISanitizer
         *-----------------------------------------------
         * the order of sanitizing is determined by order of
         * sanitizers array
         * TGroupSanitizer.create([aSanitizer, bSanitizer, .., nSanitizer]);
         *-----------------------------------------------*)
        constructor create(const sanitizers : array of ISanitizer);

        destructor destroy(); override;

        (*!------------------------------------------------
         * sanitize input string with html entities
         *-------------------------------------------------
         * @param dataToSanitize input data to sanitize
         * @return sanitized output
         *-------------------------------------------------*)
        function sanitize(const dataToSanitize : string) : string;
    end;

implementation

    function initSanitizers(const sanitizers : array of ISanitizer) : TSanitizerArray;
    var i, totSanitizers : integer;
    begin
        result := default(TSanitizerArray);
        totSanitizers := high(sanitizers) - low(sanitizers) + 1;
        setLength(result, totSanitizers);
        for i := 0 to totSanitizers - 1 do
        begin
            result[i] := sanitizers[i];
        end;
    end;

    procedure freeSanitizers(var sanitizers : TSanitizerArray);
    var i, totSanitizers : integer;
    begin
        totSanitizers := length(sanitizers);
        for i := 0 to totSanitizers - 1 do
        begin
            sanitizers[i] := nil;
        end;
        setLength(sanitizers, 0);
        sanitizers := nil;
    end;

    (*!------------------------------------------------
     * constructor
     *-----------------------------------------------
     * @param sanitizers array of ISanitizer
     *-----------------------------------------------
     * the order of sanitizing is determined by order of
     * sanitizers array
     * TGroupSanitizer.create([ASanitizer, BSanitizer]);
     *-----------------------------------------------*)
    constructor TGroupSanitizer.create(const sanitizers : array of ISanitizer);
    begin
        fSanitizers := initSanitizers(sanitizers);
    end;

    destructor TGroupSanitizer.destroy();
    begin
        freeSanitizers(fSanitizers);
        inherited destroy();
    end;

    (*!------------------------------------------------
     * sanitize input string
     *-------------------------------------------------
     * @param dataToSanitize input data to sanitize
     * @return sanitized output
     *-------------------------------------------------*)
    function TGroupSanitizer.sanitize(const dataToSanitize : string) : string;
    var i : integer;
    begin
        result := dataToSanitize;
        for i := 0 to length(fSanitizers) - 1 do
        begin
            result := fSanitizers[i].sanitize(result);
        end;
    end;

end.
