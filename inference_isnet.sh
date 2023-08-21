#!/usr/bin/env bash

# do enhance(denoise)
CUDA_VISIBLE_DEVICES='0' python -m speech_enhance.tools.inference \
  -C config/inference_isnet.toml \
  -M pretrained/isnet.tar \
  -I test/in \
  -O test/isnet
