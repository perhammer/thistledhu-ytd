#!/bin/bash

# for this to work, you need at least:
# brew install imagemagick
# brew install inetutils

function ftpSteps() {
	cat << STOP
bin
mput $*
STOP
}

function upload() {
	ftpSteps $* | gftp -i --netrc=.netrc_thistledhu thistledhu.net
}

function grabAndAppend() {
	local outfile="camera$1-`date +%Y-%m-%d-%H:%M:%S`.jpg"
	local infiles="camera$1-`date +%Y`-*.jpg"
	local renderfile="camera$1-`date +%Y`-ytd.gif"
	curl -s -S --netrc-file .netrc_thistledhu -o $outfile http://camera$1/image.jpg
	convert -delay 40 -loop 0 $infiles $renderfile
	ln -sf $renderfile camera$1-ytd.gif 
}

function grabAllCams() {
	for cam in `seq 1 2`; do
		grabAndAppend $cam
	done
}

grabAllCams
upload camera?-ytd.gif

echo "Ran at `date +%Y-%m-%d-%H:%M:%S`" >> ytd.log

