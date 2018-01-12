#!/bin/bash
#
# Run script to generate HTK MFCC features, given a WAV audio file
# then given a speech/nonspeech file (extension .scp), run DiarTK
# (also known as ib_diarization_toolkit) to produce RTTM clustered
# utterances and generated speaker IDs

# Assumes 10ms frame size in .scp file; to change, edit line in htkconfig:
#   TARGETRATE = 100000.0


numargs=3
if [ $# -lt $numargs ]; then
    echo "Usage: run.sh ipfile scpfile outdir"
    echo ""
    echo "ipfile :  Audio input file in WAV format, extension .wav"
    echo "scpfile:  speech/nonspeech file, format:"
    echo "          segment_name=file_name[start_frame,end_frame]"
    echo "produces output in folder outdir/"
    exit
fi

filename=$(basename "$1")
basename="${filename%.*}"

workdir=$3

mkdir -p $workdir

# first generate HTK features
HCopy -T 2 -C htkconfig $1 $workdir/$basename.fea

# next run DiarTK
scripts/run.diarizeme.sh $workdir/$basename.fea $2 $workdir $basename

# print results
cat $workdir/$basename.out

