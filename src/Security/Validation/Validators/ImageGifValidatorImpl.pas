{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ImageGifValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    FileFormatValidatorImpl;

type

    (*!------------------------------------------------
     * validation rule which test if file upload is indeed
     * file image GIF
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TImageGifValidator = class(TFileFormatValidator)
    protected
        function isValidFormat(const buffer; const buffSize : int64) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create();
    end;

implementation

uses

    SysUtils;

resourcestring

    sErrFieldMustBeGifImage = 'Field %s must be GIF image file';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TImageGifValidator.create();
    begin
        inherited create(sErrFieldMustBeGifImage);
    end;

    function TImageGifValidator.isValidFormat(const buffer; const buffSize : int64) : boolean;
    begin
        result := (buffSize = MinBuffSize) and
            (strlcomp(PAnsiChar(@buffer), 'GIF', 3) = 0);
    end;

end.
