#!/bin/bash

. cmd.sh
. path.sh

rm on_other*.wav
# Traverse through ALL files
for line in $(find ~/thesis/kaldi/egs/wsj/s5/export/corpora5/LDC94S13C -maxdepth 14 -type d); do
  # Traverse through and find files with .wv extension
  nd=`echo $line | sed 's/kaldi\/egs\/wsj\/s5\/export\/corpora5/databases\/transcripts\/online/'`
  mkdir -p $nd
  for file in "$line"/*; do
    # Convert to 16-bit 8kHz mono waveform
    if [[ $file =~ .*\.wv2$ ]]; then
      ftest=`echo $file | sed 's/\/\(.*\)..\.wv2/\100.txt/' | sed 's/.*\///'`
      fout="$nd/$ftest"
      if [ ! -f "$fout" ]; then
        echo "creating file $fout"
        touch $fout
      fi
      ~/Downloads/sph2pipe_v2.5/sph2pipe $file "on_other1.wav" > /dev/null 2>&1
      ffmpeg -hide_banner -loglevel panic -y -i "on_other1.wav" -acodec pcm_s16le -ac 1 -ar 8000 "on_other2.wav"
      # Run through ASR + append to output.txt file
      online2-wav-nnet3-latgen-faster --online=true \
        --do-endpointing=false \
        --frame-subsampling-factor=3 \
        --config=exp/tdnn_7b_chain_online/conf/online.conf \
        --max-active=7000 \
        --beam=15.0 \
        --lattice-beam=6.0 \
        --acoustic-scale=1.0 \
        --word-symbol-table=exp/tdnn_7b_chain_online/graph_pp/words.txt \
        exp/tdnn_7b_chain_online/final.mdl \
        exp/tdnn_7b_chain_online/graph_pp/HCLG.fst \
        'ark:echo utterance-id1 utterance-id1|' \
        'scp,p:echo utterance-id1 on_other2.wav |' \
        'ark:|~/thesis/kaldi/src/latbin/lattice-best-path --acoustic-scale=0.1 ark,t:- ark,t:- | ~/thesis/kaldi/egs/aspire/s5/utils/int2sym.pl -f 2- exp/tdnn_7b_chain_online/graph_pp/words.txt | cut -d " " -f2- >> "'$fout'"'
      # Delete wav file
      rm on_other*.wav
    fi
  done
done
echo "COMPLETE"
