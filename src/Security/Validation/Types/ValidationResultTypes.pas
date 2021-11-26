{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit ValidationResultTypes;

interface

{$MODE OBJFPC}
{$H+}

type
    TValidationMessage = record
        key : shortstring;
        errorMessage : string;
    end;
    TValidationMessages = array of TValidationMessage;

    TValidationResult = record
        isValid : boolean;
        errorMessages : TValidationMessages;
    end;

implementation

end.
