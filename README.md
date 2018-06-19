# Omxplaylist
A simple shell script for playing media files in sequential order with omxplayer.

# INSTALLATION
    sudo wget 'https://raw.githubusercontent.com/eeibevan/omxplaylist/master/omxplaylist' \
      -O /usr/local/bin/omxplaylist
    sudo chmod +x /usr/local/bin/omxplaylist
Requires omxplayer in order to play the media files. It may already be installed, but if it is not, it may be installed this way

    sudo apt-get update
    sudo apt-get -y install omxplayer

# DESCRIPTION
**omxplaylist** is a command-line script that plays media files like a playlist without a GUI.
By default omxplaylist will play all mp3, mp4, or avi files in the current directory.
You may override this behavor by creating a playlist file.

    omxplaylist [OPTIONS]

# OPTIONS
    -f, --file FILE          Reads the list of files to play from a file.
                             Each entry the file should be seperated by newlines
                             
    -n, --no-last-record     Do not store a record of the last file played (last.txt)
    
    -H, --hdmi               Sets omxplayer to output audio through HDMI
    
    -L, --local              Sets omxplayer to output audio through the headphone jack
    
    -r, --resume             Resumes playback of the playlist where it was last stopped.
                             Last file is read from last.txt

    -R, --reverse            Plays the playlist backwards

    -s, --start MEDIA_FILE   Starts playback on MEDIA_FILE, rather than the beginning

    -S, --silent             Suppresses output
