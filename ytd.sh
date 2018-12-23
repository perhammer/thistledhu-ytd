#!/bin/bash

# for this to work, you need at least:
# brew install imagemagick
# brew install inetutils

function ftpSteps() {
	cat << STOP
prompt off
bin
mput $*
STOP
}

function upload() {
	ftpSteps $* | gftp --netrc=.netrc_thistledhu thistledhu.net
}

function grabAndAppend() {
	local outfile="camera$1-`date "+%Y-%m-%d-%H:%M:%S"`.jpg"
	curl --netrc-file .netrc_thistledhu -o $outfile http://camera$1/image.jpg
	convert -delay 2 -loop 0 camera$1-*.jpg camera$1-ytd.gif
}

function grabAllCams() {
	for cam in `seq 1 2`; do
		grabAndAppend $cam
	done
}

grabAllCams
upload camera?-ytd.gif

