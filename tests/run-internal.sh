#!/usr/bin/env sh

# To be run inside trezor-user-env NixOS container
set -e

show_usage() {
    echo "Usage: run [OPTIONS] [ARGS]"
    echo ""
    echo "Options:"
    echo "  -g       Run tests with emulator graphical output"
    echo "  -f       Use specific firmware version, for example: 2.1.4., 2.3.0"
    echo "  -i       Included methods only, for example: applySettings,signTransaction"
    echo "  -e       All methods except excluded, for example: applySettings,signTransaction"
    echo "  -c       Collect coverage"
}

firmware='2.3.2'
included_methods=''
excluded_methods=''
gui_output=false
collect_coverage=false

OPTIND=1
while getopts ":i:e:f:hgc" opt; do
    case $opt in
        c)
            collect_coverage=true
        ;;
        g)
            gui_output=true
        ;;
        f)
            firmware=$OPTARG
        ;;
        i)
            included_methods=$OPTARG
        ;;
        e)
            excluded_methods=$OPTARG
        ;;
        h) # Script usage
            show_usage
            exit 0
        ;;
        \?)
            echo "invalid option" $OPTARG
            exit 1
        ;;
    esac
done
shift $((OPTIND-1))

export TESTS_FIRMWARE=$firmware
export TESTS_INCLUDED_METHODS=$included_methods
export TESTS_EXCLUDED_METHODS=$excluded_methods

echo $TESTS_FIRMWARE
echo $TESTS_INCLUDED_METHODS
echo $TESTS_EXCLUDED_METHODS

yarn jest --config jest.config.integration.js --verbose --detectOpenHandles --forceExit --coverage $collect_coverage
echo $?
