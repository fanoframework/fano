{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2020 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit SessionConsts;

interface

{$MODE OBJFPC}
{$H+}

const

    FANO_COOKIE_NAME = 'FANOSESSID';

resourcestring

    rsSessionExpired = 'Session is expired. Id : %s';
    rsSessionInvalid = 'Session is invalid';

implementation

end.
