#!/bin/bash
#
# Run script to generate HTK MFCC features, given a WAV audio file
# then given a speech/nonspeech file (extension .scp), run DiarTK
# (also known as ib_diarization_toolkit) to produce RTTM clustered
# utterances and generated speaker IDs

#Needs to be parameterized to take another argument which is for
# now hard coded as "test2.scp" 

# Needs to save results to a named folder, not hard coded diartk_output/diartk_result*

workdir=diartk_output

mkdir -p $workdir

# first generate HTK features
HCopy -T 2 -C htkconfig $1 $workdir/diartk.fea

# next run DiarTK
scripts/run.diarizeme.sh $workdir/diartk.fea test2.scp $workdir diartk_result

# print results
cat $workdir/diartk_result.out

