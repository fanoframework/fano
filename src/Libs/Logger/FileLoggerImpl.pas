{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit FileLoggerImpl;

interface

{$MODE OBJFPC}
{$H+}

(*!------------------------------------------------
 * turn on I/O checking so EInOutError will be raised
 * if file I/O operation is failed
 *-----------------------------------------------*)
{$I+}

uses

    sysutils,
    DependencyIntf,
    SerializeableIntf,
    LoggerIntf,
    AbstractLoggerImpl;

type

    (*!------------------------------------------------
     * logger class that write log to text file
     *
     * @author Zamrony P. Juhara <zamronypj@yahoo.com>
     *-----------------------------------------------*)
    TFileLogger = class(TAbstractLogger)
    private
        fAutoFlush : boolean;
        outputFile : TextFile;
        isOpen : boolean;

        (*!--------------------------------------
         * try opening file
         * --------------------------------------
         * @param filename file to open
         * @throws EInOutError
         *---------------------------------------*)
        procedure tryOpenFileOrExcept(const filename : string);

    public
        (*!--------------------------------------
         * constructor
         * --------------------------------------
         * @param filename file to store logs
         * @param autoFlush when true, log is written to disk when log() is called
         * @throws EInOutError
         *---------------------------------------*)
        constructor create(
            const filename : string;
            const autoFlush : boolean = true
        );

        (*!--------------------------------------
         * destructor
         * --------------------------------------
         * @param filename file to store logs
         *---------------------------------------*)
        destructor destroy(); override;

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


    (*!--------------------------------------
     * try opening file
     * --------------------------------------
     * @param filename file to open
     * @throws EInOutError
     *---------------------------------------*)
    procedure TFileLogger.tryOpenFileOrExcept(const filename : string);
    begin
        try
            if (fileExists(filename)) then
            begin
                append(outputFile);
            end else
            begin
                rewrite(outputFile);
            end;
        except
            on e : EInOutError do
            begin
                //original error message is not very clear
                //as it does not include file information,
                //here handle it and re raise exception with more clear message
                raise EInOutError.create(e.message + ' ' + filename);
            end;
        end;
    end;

    (*!--------------------------------------
     * constructor
     * --------------------------------------
     * @param filename file to store logs
     * @param autoFlush when true, log is written to disk when log() is called
     * @throws EInOutError
     * --------------------------------------
     * if file exists, we open file for append
     * if not then we create new. User who run
     * must have proper file permissions
     * If file can not be open, EInOutError exception
     * is raised
     *---------------------------------------*)
    constructor TFileLogger.create(
        const filename : string;
        const autoFlush : boolean = true
    );
    begin
        fAutoFlush := autoFlush;
        isOpen := false;
        assignFile(outputFile, filename);
        tryOpenFileOrExcept(filename);

        //tryOpenFileOrExcept() will throw EInOutError when
        //failed. If we get here then, I/O operation is successful
        isOpen := true;
    end;

    (*!--------------------------------------
     * destructor
     * --------------------------------------
     * close file if open
     *---------------------------------------*)
    destructor TFileLogger.destroy();
    begin
        if (isOpen) then
        begin
            //file is open succesfully, so close it properly
            closeFile(outputFile);
        end;
        inherited destroy();
    end;

    (*!--------------------------------------
     * log message
     * --------------------------------------
     * @param level type of log
     * @param msg log message
     * @param context data related to log message
     *               (if any)
     * @return current instance
     * --------------------------------------
     * Here we will flush message to file every
     * 500 call to log()
     *---------------------------------------*)
    function TFileLogger.log(
        const level : string;
        const msg : string;
        const context : ISerializeable = nil
    ) : ILogger;
    begin
        writeln(
            outputFile,
            '[', level,'] ',
            FormatDateTime('yyyy-mm-dd hh:nn:ss', Now),
            ' ',
            msg
        );
        if (context <> nil) then
        begin
            writeln(outputFile, '==== Start context ====');
            writeln(outputFile, context.serialize());
            writeln(outputFile, '==== End context ====');
        end;

        if (fAutoFlush) then
        begin
            flush(outputfile);
        end;
        result := self;
    end;

end.
