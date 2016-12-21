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
            if [ ! -r $2 ]; then
                echo "Cannot Open File $2" 1>&2;
                exit 1;
            else
                seek_episode=$2;
            fi
            shift 2;
            ;;
        --)
            shift;
            break;
            ;;
    esac
done

for media_file in ${media_files[*]}; do

    # If We Want To Seek To A File
    # Skip Any File That Does Not Match
    if [ ! -z $seek_episode ]; then
        if [ $seek_episode = $media_file ]; then
            # We Found The File, No Need To Seak Anymore
            seek_episode='';
        else
            continue;
        fi

    fi

    echo $media_file;

    omxplayer $audio_options --blank $media_file > /dev/null;
    wait;

    # Sleeps For A Few Seconds So We Can Exit The Script With ^C
    sleep 2;
done

