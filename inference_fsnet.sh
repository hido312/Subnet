#!/usr/bin/env bash

# do enhance(denoise)
CUDA_VISIBLE_DEVICES='0' python -m speech_enhance.tools.inference \
  -C config/inference_fsnet.toml \
  -M pretrained/fsnet.tar \
  -I test/in \
  -O test/fsnet
