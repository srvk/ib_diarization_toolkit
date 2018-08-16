#!/bin/bash
#
# Run script to generate HTK MFCC features, given a WAV audio file
# then given a speech/nonspeech file (extension .rttm), run DiarTK
# (also known as ib_diarization_toolkit) to produce RTTM clustered
# utterances and generated speaker IDs

# Assumes 10ms frame size in .scp file; to change, edit line in htkconfig:
#   TARGETRATE = 100000.0


numargs=3
if [ $# -lt $numargs ]; then
    echo "Usage: run-rttm.sh ipfile rttmfile outdir"
    echo ""
    echo "ipfile  :  Audio input file in WAV format, extension .wav"
    echo "rttmfile:  speech/nonspeech file, format:"
    echo "           Type file chan tbeg tdur ortho stype name conf Slat"
    echo "produces output in folder outdir/"
    exit
fi

filename=$(basename "$1")
basename="${filename%.*}"

workdir=$3

mkdir -p $workdir

featfile=$workdir/$basename.fea
scpfile=$workdir/$basename.scp

# first-first convert RTTM to DiarTK's version of a .scp file
# SCP format:
#   <basename>_<start>_<end>=<filename>[start,end]
# RTTM format:
#   Type file chan tbeg tdur ortho stype name conf Slat
# math: convert RTTM seconds to HTK (10ms default) frames = multiply by 100
# assume we process every line in RTTM, don't look for standard symbols in certain columns
cat $2 | awk -v base="$basename" -v feats="$featfile" '{begg=$4*100;endd=($4+$5)*100; print base "_" begg "_" endd "="feats "[" begg "," endd "]"}' > $scpfile

# first generate HTK features
HCopy -T 2 -C htkconfig $1 $featfile

# next run DiarTK
scripts/run.diarizeme.sh $featfile $scpfile $workdir $basename

# print results
cat $workdir/$basename.out

