{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare helper function aliases that is included in fano.pas unit
 * This file is provided so we can use fano framework
 * by using only one uses to simplify things.
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

{$H+}

    (*!------------------------------------------------
     * read file to string
     *-----------------------------------------------
     * @param filepath file to load
     * @returns contents of file as string
     *-----------------------------------------------*)
    function readFile(const filepath : string) : string; inline;

    (*!------------------------------------------------
     * join array of string with a delimiter
     *-----------------------------------------------
     * @param delimiter string to separate each
     * @param values array of string to join
     *-----------------------------------------------*)
    function join(const delimiter : string; const values : array of string) : string;

    (*!------------------------------------------------
     * generate slug
     *-----------------------------------------------
     * @param originalStr input string
     * @return slug
     *-----------------------------------------------*)
    function slug(const originalStr : string) : string; inline;
