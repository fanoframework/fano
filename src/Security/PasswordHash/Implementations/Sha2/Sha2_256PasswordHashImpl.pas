{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit Sha2_256PasswordHashImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    AbstractSha2PasswordHashImpl;

type

    (*!------------------------------------------------
     * SHA2 256 password hash
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TSha2_256PasswordHash = class (TAbstractSHA2PasswordHash)
    public

        (*!------------------------------------------------
         * generate password hash
         *-----------------------------------------------
         * @param plainPassw input password
         * @return password hash
         *-----------------------------------------------*)
        function hash(const plainPassw : string) : string; override;

    end;

implementation

uses
    Classes,
    SysUtils,
    HlpIHash,
    HlpHashFactory,
    HlpIHashInfo;

    (*!------------------------------------------------
     * generate password hash
     *-----------------------------------------------
     * @param plainPassw input password
     * @return password hash
     *-----------------------------------------------*)
    function TSha2_256PasswordHash.hash(const plainPassw : string) : string;
    var
        hashInst: IHash;
    begin
        hashInst := THashFactory.TCrypto.CreateSHA2_256();
        result := hashInst.ComputeString(plainPassw, TEncoding.UTF8).toString();
    end;

end.
