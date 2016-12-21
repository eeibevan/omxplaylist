#!/bin/bash
# Required To Expand possible_extentions
shopt -s extglob

# Extentions of Files To Play
# Seperate With Pipes
# ex: mp4|avi
possible_extentions='@(mp4|avi)';

# The Files To Play
media_files=(*.$possible_extentions);

audio_options='--adev local';

opts=`getopt --quiet --options H,r,s: --long hdmi,resume,start: -- "$@"`
if [ $? -ne 0 ]; then
    echo "Error: Bad Argument" 1>&2;
    exit 1;
fi
eval set -- "$opts";

# Stores Working Directory That (Hopefully) Contains The Videos
# Stored So Script May Be Run From Anywhere
# Slash Added At The End Because We're Accessing The Contents Of This Dir
current_dir=$(pwd)"/";

# Episode To Seek To In Playlist
# Used By Both -r|--resume And -s|--start episodeNumber.ext
seek_episode='';


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

for media_file in ${media_files[*]}; do
    echo $media_file;
    omxplayer $audio_options $media_file > /dev/null;
    wait;

    # Sleeps For A Few Seconds So We Can Exit The Script With ^C
    sleep 2;
done

