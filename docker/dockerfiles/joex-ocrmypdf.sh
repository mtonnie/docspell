#!/bin/sh
#wrapper script for ocrmypdf to check and install the related tesseract data package before running ocrmypdf command

sleep 2s
args=$@
lang=$(echo $args | sed -n "s/^.*-l\s*\(\S*\)\s*.*$/\1/p")
echo $lang
if ! [[ "$lang" == "eng" ]]; then
  pkg="tesseract-ocr-data-$lang"
  echo $pkg
  if [[ "$lang" == "jpn" ]]; then
    if [[ ! -f /usr/share/tessdata/jpn.traineddata ]]; then
       cd /usr/share/tessdata
       wget https://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/master/jpn.traineddata
    fi
    if [[ ! -f /usr/share/tessdata/jpn_vert.traineddata ]]; then
       cd /usr/share/tessdata
       wget https://raw.gi://raw.githubusercontent.com/tesseract-ocr/tessdata_fast/master/jpn_vert.traineddata
    fi
  else
    apk info -e $pkg
    if [[ $? -eq 1 ]]; then
      apk add --no-cache $pkg
    fi
  fi
  ocrmypdf $args
fi
