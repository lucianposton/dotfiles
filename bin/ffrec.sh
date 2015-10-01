#!/bin/sh
 
# this bit came from youtube.com/watch?v=_XDa1ahl7fw
INFO=$(xwininfo)
WIN_GEO=$(echo $INFO | grep -oEe 'geometry [0-9]+x[0-9]+' | grep -oEe '[0-9]+x[0-9]+')
WIN_XY=$(echo $INFO | grep -oEe 'Corners:\s+\+[0-9]+\+[0-9]+' | grep -oEe '[0-9]+\+[0-9]+' | sed -e 's/\+/,/' )

# http://trac.ffmpeg.org/wiki/Capture/Desktop

#AUDIO_INPUT="-f alsa -i hw:0,0 -ac 2"
AUDIO_INPUT="-f pulse -i default -ac 2"

#AUDIO_CODEC="-acodec pcm_s16le" # uncompressed?
AUDIO_CODEC="-acodec flac"

VIDEO_INPUT="-f x11grab -r 30 -s $WIN_GEO -i :0.0+$WIN_XY"

#VIDEO_CODEC="-vcodec libx264 -crf 0 -preset ultrafast" # uncompressed?
VIDEO_CODEC="-vcodec libx264 -qp 0 -preset ultrafast" # lossless?

EXTRA_OPTS="-async 100"
EXTRA_OPTS="$EXTRA_OPTS -threads 2"

# seems to make it laggier
#schedtool -I -e \
#echo "
    ffmpeg \
        $AUDIO_INPUT $VIDEO_INPUT \
        $AUDIO_CODEC $VIDEO_CODEC \
        $EXTRA_OPTS \
        -y screencap-$(date +%Y%m%d-%H%M%S).mkv
#    "

# losslessly encode again at slower preset for smaller size:
#ffmpeg -i capture.mkv -c:v libx264 -qp 0 -preset veryslow capture_smaller.mkv
