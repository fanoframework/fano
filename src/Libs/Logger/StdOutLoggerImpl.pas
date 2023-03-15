{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit StdOutLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

uses

    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that output to STDOUT
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TStdOutLogger = class(TAbstractLogger)
    private
        fStdOut : text;
    public
        constructor create(var aStdOut : text); overload;
        constructor create(); overload;

        (*!--------------------------------------
         * log message
         * --------------------------------------
         * @param level type of log
         * @param msg log message
         * @param context data related to log message
         *               (if any)
         * @return current instance
         *---------------------------------------*)
        function log(
            const level : string;
            const msg : string;
            const context : ISerializeable = nil
        ) : ILogger; override;
    end;

implementation

uses

    SysUtils;

    constructor TStdOutLogger.create(var aStdOut : text);
    begin
        //need copy original stdout to internal variable
        //because our protocol implementation such as FastCgi, SCGI, uwsgi
        //will redirect stdout to its own stdout.
        //copy need to be done before stdout redirection
        fStdOut := aStdOut;
    end;

    constructor TStdOutLogger.create();
    begin
        create(StdOut);
    end;

    (*!--------------------------------------
     * log message
     * --------------------------------------
     * @param level type of log
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     *---------------------------------------*)
    function TStdOutLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    begin
        writeln(
            fStdOut,
            '[', level,'] ',
            FormatDateTime('yyyy-mm-dd hh:nn:ss', Now),
            ' ',
            msg
        );
        if (context <> nil) then
        begin
            writeln(fStdOut, '==== Start context ====');
            writeln(fStdOut, context.serialize());
            writeln(fStdOut, '==== End context ====');
        end;
        result := self;
    end;

end.
