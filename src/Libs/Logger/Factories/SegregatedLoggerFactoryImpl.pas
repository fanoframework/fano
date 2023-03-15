{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}
unit SegregatedLoggerFactoryImpl;

interface

{$MODE OBJFPC}

uses

    DependencyIntf,
    DependencyContainerIntf,
    FactoryImpl;

type
    {------------------------------------------------
     factory class for TSegregatedLogger

     @author Zamrony P. Juhara <zamronypj@yahoo.com>
    -----------------------------------------------}
    TSegregatedLoggerFactory = class(TFactory, IDependencyFactory)
    private
        fEmergencyLoggerFactory : IDependencyFactory;
        fAlertLoggerFactory : IDependencyFactory;
        fCriticalLoggerFactory : IDependencyFactory;
        fErrorLoggerFactory : IDependencyFactory;
        fWarningLoggerFactory : IDependencyFactory;
        fNoticeLoggerFactory : IDependencyFactory;
        fInfoLoggerFactory : IDependencyFactory;
        fDebugLoggerFactory : IDependencyFactory;
    public
        (*!--------------------------------------
         * constructor
         * --------------------------------------
         * @param emergencyLoggerFactory factory for emergency log
         * @param alertLoggerFactory factory for alert log
         * @param criticalLoggerFactory factory for critical log
         * @param errorLoggerFactory factory for error log
         * @param warningLoggerFactory factory for warning log
         * @param noticeLoggerFactory factory for critical log
         * @param infoLoggerFactory factory for info log
         * @param debugLoggerFactory factory for debug log
         *---------------------------------------*)
        constructor create(
            const emergencyLoggerFactory : IDependencyFactory;
            const alertLoggerFactory : IDependencyFactory;
            const criticalLoggerFactory : IDependencyFactory;
            const errorLoggerFactory : IDependencyFactory;
            const warningLoggerFactory : IDependencyFactory;
            const noticeLoggerFactory : IDependencyFactory;
            const infoLoggerFactory : IDependencyFactory;
            const debugLoggerFactory : IDependencyFactory
        );

        destructor destroy(); override;

        function build(const container : IDependencyContainer) : IDependency; override;
    end;

implementation

uses

    LoggerIntf,
    SegregatedLoggerImpl;

    (*!--------------------------------------
     * constructor
     * --------------------------------------
     * @param emergencyLoggerFactory factory for emergency log
     * @param alertLoggerFactory factory for alert log
     * @param criticalLoggerFactory factory for critical log
     * @param errorLoggerFactory factory for error log
     * @param warningLoggerFactory factory for warning log
     * @param noticeLoggerFactory factory for critical log
     * @param infoLoggerFactory factory for info log
     * @param debugLoggerFactory factory for debug log
     *---------------------------------------*)
    constructor TSegregatedLoggerFactory.create(
        const emergencyLoggerFactory : IDependencyFactory;
        const alertLoggerFactory : IDependencyFactory;
        const criticalLoggerFactory : IDependencyFactory;
        const errorLoggerFactory : IDependencyFactory;
        const warningLoggerFactory : IDependencyFactory;
        const noticeLoggerFactory : IDependencyFactory;
        const infoLoggerFactory : IDependencyFactory;
        const debugLoggerFactory : IDependencyFactory
    );
    begin
        fEmergencyLoggerFactory := emergencyLoggerFactory;
        fAlertLoggerFactory := alertLoggerFactory;
        fCriticalLoggerFactory := criticalLoggerFactory;
        fErrorLoggerFactory := errorLoggerFactory;
        fWarningLoggerFactory := warningLoggerFactory;
        fNoticeLoggerFactory := noticeLoggerFactory;
        fInfoLoggerFactory := infoLoggerFactory;
        fDebugLoggerFactory := debugLoggerFactory;
    end;

    destructor TSegregatedLoggerFactory.destroy();
    begin
        fEmergencyLoggerFactory := nil;
        fAlertLoggerFactory := nil;
        fCriticalLoggerFactory := nil;
        fErrorLoggerFactory := nil;
        fWarningLoggerFactory := nil;
        fNoticeLoggerFactory := nil;
        fInfoLoggerFactory := nil;
        fDebugLoggerFactory := nil;
        inherited destroy();
    end;

    function TSegregatedLoggerFactory.build(const container : IDependencyContainer) : IDependency;
    begin
        result := TSegregatedLogger.create(
            fEmergencyLoggerFactory.build(container) as ILogger,
            fAlertLoggerFactory.build(container) as ILogger,
            fCriticalLoggerFactory.build(container) as ILogger,
            fErrorLoggerFactory.build(container) as ILogger,
            fWarningLoggerFactory.build(container) as ILogger,
            fNoticeLoggerFactory.build(container) as ILogger,
            fInfoLoggerFactory.build(container) as ILogger,
            fDebugLoggerFactory.build(container) as ILogger
        );
    end;

end.
