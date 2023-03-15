{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit CommonStaticFilesMiddlewareFactoryImpl;

interface

{$MODE OBJFPC}

uses

    StaticFilesMiddlewareFactoryImpl;

type

    (*!------------------------------------------------
     * factory class for TStaticFilesMiddleware
     * with some predefined common types such as
     * JavaScripts, Cascade Stylesheet, Images, Documents
     *--------------------------------------------------
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-------------------------------------------------*)
    TCommonStaticFilesMiddlewareFactory = class(TStaticFilesMiddlewareFactory)
    private
        procedure registerCommonTypes();
    public
        constructor create();
    end;

implementation


    constructor TCommonStaticFilesMiddlewareFactory.create();
    begin
        inherited create();
        registerCommonTypes();
    end;

    (*!------------------------------------------------
     * register some predefined common types such as
     * JavaScripts, Cascade Stylesheet, Images, Documents
     *--------------------------------------------------
     * @link https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types
     *-------------------------------------------------*)
    procedure TCommonStaticFilesMiddlewareFactory.registerCommonTypes();
    begin
        addMimeType('css', 'text/css');
        addMimeType('csv', 'text/csv');
        addMimeType('eot', 'application/vnd.ms-fontobject');
        addMimeType('htm', 'text/html');
        addMimeType('html', 'text/html');
        addMimeType('json', 'application/json');
        addMimeType('js', 'text/javascript');
        addMimeType('txt', 'text/plain');
        addMimeType('xml', 'application/xml');

        addMimeType('pdf', 'application/pdf');

        addMimeType('jpg', 'image/jpeg');
        addMimeType('jpeg', 'image/jpeg');
        addMimeType('png', 'image/png');
        addMimeType('svg', 'image/svg+xml');
        addMimeType('gif', 'image/gif');
        addMimeType('ico', 'image/vnd.microsoft.icon');
        addMimeType('webp', 'image/webp');

        addMimeType('ttf', 'font/ttf');
        addMimeType('woff', 'font/woff');
        addMimeType('woff2', 'font/woff2');
    end;

end.
