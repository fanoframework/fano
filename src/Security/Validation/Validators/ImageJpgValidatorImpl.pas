{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ImageJpgValidatorImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    FileFormatValidatorImpl;

type

    (*!------------------------------------------------
     * validation rule which test if file upload is indeed
     * file image JPEG
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TImageJpgValidator = class(TFileFormatValidator)
    protected
        function isValidFormat(const buffer; const buffSize : int64) : boolean; override;
    public
        (*!------------------------------------------------
         * constructor
         *-------------------------------------------------*)
        constructor create();
    end;

implementation

const

    JPEG_ID = $D8FF;

resourcestring

    sErrFieldMustBeJpegImage = 'Field %s must be JPEG image file';

    (*!------------------------------------------------
     * constructor
     *-------------------------------------------------*)
    constructor TImageJpgValidator.create();
    begin
        inherited create(sErrFieldMustBeJpegImage);
    end;

    function TImageJpgValidator.isValidFormat(const buffer; const buffSize : int64) : boolean;
    var
        words: array[byte] of word absolute buffer;
    begin
        result := (buffSize = MinBuffSize) and (words[0] = JPEG_ID);
    end;

end.
