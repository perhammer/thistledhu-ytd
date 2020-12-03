#!/bin/bash

# for this to work, you need at least:
# brew install imagemagick
# brew install inetutils

NETRC_FILE=".netrc_thistledhu"
FRAME_DELAY_TICKS=40 # there are 100 ticks/second
ANIMATION_LOOP_COUNT=0 # 0 = loop forever

function ftpSteps() {
	cat << STOP
bin
mput $*
STOP
}

function upload() {
	ftpSteps $* | gftp -i --netrc=$NETRC_FILE thistledhu.net
}

function grabAndAppend() {
	local outfile="camera$1-`date +%Y-%m-%d-%H:%M:%S`.jpg"
	local infiles="camera$1-`date +%Y`-*.jpg"
	local renderfile="camera$1-`date +%Y`-ytd.gif"
	curl -s -S --netrc-file $NETRC_FILE -o $outfile http://camera$1/image.jpg
	convert -delay $FRAME_DELAY_TICKS -loop $ANIMATION_LOOP_COUNT $infiles $renderfile
	ln -sf $renderfile camera$1-ytd.gif
	ffmpeg -i $renderfile -movflags faststart -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -y camera$1-ytd.mp4
}

function grabAllCams() {
	for cam in `seq 1 2`; do
		grabAndAppend $cam
	done
}

grabAllCams
#upload camera?-ytd.gif
upload camera?-ytd.mp4

echo "Ran at `date +%Y-%m-%d-%H:%M:%S`" >> ytd.log

