#!/bin/bash
# Required To Expand possible_extentions
shopt -s extglob

# Globs That Match Nothing Expand To Null Strings
# So, When No Media Files Match possible_extentions,
# Then We Get An Empty Array
shopt -s nullglob

# Extentions of Files To Play
# Seperate With Pipes
# ex: mp4|avi
possible_extentions='@(mp4|avi)';

# The Files To Play
# May Be Overwritten By Options
media_files=(*.$possible_extentions);

audio_options='--adev local';

opts=`getopt --quiet --options f:,H,r,R,s: --long file:,hdmi,resume,reverse,start: -- "$@"`
if [ $? -ne 0 ]; then
    echo "Error: Bad Argument" 1>&2;
    exit 1;
fi
eval set -- "$opts";

# Episode To Seek To In Playlist
# Used By Both -r|--resume And -s|--start episodeNumber.ext
seek_episode='';

# Flag To Reverse media_files Array
# Used Since Reverse Must Be Processed Last
# As Other Options May Overwrite The Array
is_reverse_session=false;

# Read In A Playlist File Into media_files
read_in_file()
{
    # Reset media_files So We Can Overwrite it
    unset media_files
    media_files=();

    file=$1;
    while read line;do
        # Append To The Array
        # Space After line To Seperate Elements
        media_files+=$line' ';
    done < $file
}

reverse_media_files()
{
    local reversed_media_files=();
    for element in ${media_files[@]}; do
        reversed_media_files=( $element ${reversed_media_files[@]} );
    done
    media_files=( ${reversed_media_files[@]} );
}

while true; do
    case "$1" in
        -f|--file)
            read_in_file $2;
            shift 2;
            ;;
        -H|--hdmi)
            audio_options='--adev hdmi';
            shift;
            ;;
        -r|--resume)
            if [ -r 'last.txt' ]; then
                seek_episode="$(<last.txt)";
            else
                echo "Error, Cannot Read Last Episode" 1>&2;
                exit 1;
            fi
            shift;
            ;;
        -R|--reverse)
            is_reverse_session=true;
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

# Should Be The Final Thing We Do Before Playing
# Reverse Must Be Processed Last
# As Other Options May Overwrite The Array
if [ "$is_reverse_session" = true ]; then
    reverse_media_files;
fi

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

    # Save Current Episode For Resuming Later
    echo $media_file > last.txt;

    omxplayer $audio_options --blank $media_file > /dev/null;
    wait;

    # Sleeps For A Few Seconds So We Can Exit The Script With ^C
    sleep 2;
done

if [ -e last.txt ]; then
    rm last.txt;
fi

