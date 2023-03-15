{*!
 * Fano Web Framework (https://fanoframework.github.io)
 *
 * @link      https://github.com/fanoframework/fano
 * @copyright Copyright (c) 2018 - 2022 Zamrony P. Juhara
 * @license   https://github.com/fanoframework/fano/blob/master/LICENSE (MIT)
 *}

unit LogLevelTypes;

interface

type

    TLogLevelType = (
        logEmergency,
        logAlert,
        logCritical,
        logError,
        logWarning,
        logDebug,
        logInfo,
        logNotice
    );

    TLogLevelTypes = set of TLogLevelType;

implementation

end.
