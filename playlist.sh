#!/bin/bash

opts=`getopt --quiet --options H,r,s: --long hdmi,resume,start: -- "$@"`
if [ $? -ne 0 ]; then
    echo "Error: Bad Argument" 1>&2;
    exit 1;
fi
eval set -- "$opts";


while true; do
    case "$1" in
        -H|hdmi)
            echo "HDMI";
            shift;
            ;;
        -r|--resume)
            echo "Resume";
            shift;
            ;;
        -s|--start)
            echo "Start and $2";
            shift 2;
            ;;
        --)
            shift;
            break;
            ;;
    esac
done

