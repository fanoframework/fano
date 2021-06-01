#------------------------------------------------------------
# Fano Web Framework (https://fanoframework.github.io)
#
# @link      https://github.com/fanoframework/fano-cli
# @copyright Copyright (c) 2018 - 2021 Zamrony P. Juhara
# @license   https://github.com/fanoframework/fano-cli/blob/master/LICENSE (MIT)
#-------------------------------------------------------------
#!/bin/bash

#------------------------------------------------------
# Build script for Linux
#------------------------------------------------------

if [[ -z "${FANO_DIR}" ]]; then
export FANO_DIR="../"
fi

if [[ -z "${UNIT_OUTPUT_DIR}" ]]; then
    export UNIT_OUTPUT_DIR="bin/unit"
fi

if [[ -z "${EXEC_OUTPUT_DIR}" ]]; then
    export EXEC_OUTPUT_DIR="bin"
fi

if [[ -z "${EXEC_OUTPUT_NAME}" ]]; then
    export EXEC_OUTPUT_NAME="testrunner"
fi

fpc @testrunner.cfg testrunner.pas
