{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

(*! ---------------------------------------------
 * redeclare implementation aliases that is included in fano.pas unit
 * This file is provided so we can use fano framework
 * by using only one uses to simplify things.
 *
 * @author Zamrony P. Juhara <zamronypj@yahoo.com>
 *-----------------------------------------------*)

    (*!------------------------------------------------
     * read file to string
     *-----------------------------------------------
     * @param filepath file to load
     * @returns contents of file as string
     *-----------------------------------------------*)
    function readFile(const filepath : string) : string;
    begin
         result := FileUtils.readFile(filepath);
    end;

    (*!------------------------------------------------
     * join array of string with a delimiter
     *-----------------------------------------------
     * @param delimiter string to separate each
     * @param values array of string to join
     *-----------------------------------------------*)
    function join(const delimiter : string; const values : array of string) : string;
    begin
         result := StringUtils.join(delimiter, values);
    end;

    (*!------------------------------------------------
     * generate slug
     *-----------------------------------------------
     * replace string 'test hei$#@slug to Slug 10' to
     * 'test-hei-slug-to-slug-10'
     *-----------------------------------------------
     * @param originalStr input string
     * @return slug
     *-----------------------------------------------*)
    function slug(const originalStr : string) : string;
    begin
        result := StringUtils.slug(originalStr);
    end;
