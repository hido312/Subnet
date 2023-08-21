#!/usr/bin/env bash

#############################################
## -- SET STAGE
if test "$#" -eq 1; then
  stage=$(($1))
  stop_stage=$(($1))
elif test "$#" -eq 2; then
  stage=$(($1))
  stop_stage=$(($2))
else
  stage=0
  stop_stage=10
fi


# #############################################
# ## -- DATA PREPROCESS
# ##    corpus data will be under ${data_dir}/${corpus_name}, should be read only for exp
# ##    train data(features, index) will be under ${data_dir}/${train_data_dir}
# cur_dir=$(pwd)
# data_dir=../../../data/
# corpus_name=data
# train_data_dir=train_data_dns
# exp_id=$(pwd | xargs basename)
# spkr_id=$(pwd | xargs dirname | xargs basename)
# corpus_id=${spkr_id}_${exp_id}


# #############################################
# ## -- PREPARE FILES
# if [ ! -d ${corpus_name}  ]; then
#   ln -s ${data_dir} ${corpus_name}
# fi

# if [ ! -d ${train_data_dir} ]; then
#   cpfs_cur_dir=${cur_dir/nas/cpfs}
#   cpfs_data_dir=${cpfs_cur_dir}/${data_dir}
#   mkdir -p ${cpfs_data_dir}/${train_data_dir}
#   ln -s ${cpfs_data_dir}/${train_data_dir} ${train_data_dir}
# fi


#############################################
## -- STAGE 0 : DATA MIXING
##    generate list of clean/noise for training, dir of synthesic noisy-clean pair for val
if [ ${stage} -le 0 ] && [ ${stop_stage} -ge 0 ]; then
  # gen lst
  python -m speech_enhance.tools.gen_lst --dataset_dir ${corpus_name}/DNS-Challenge/DNS-Challenge-master/datasets_16k/clean/ --output_lst ${train_data_dir}/clean.txt
  python -m speech_enhance.tools.gen_lst --dataset_dir ${corpus_name}/DNS-Challenge/DNS-Challenge-master/datasets_16k/noise/ --output_lst ${train_data_dir}/noise.txt
  cat ${corpus_name}/rir/simulated_rirs_16k/*/rir_list ${corpus_name}/rir/RIRS_NOISES/real_rirs_isotropic_noises/rir_list | awk -F ' ' '{print "data/rir/"$5}'  > ${train_data_dir}/rir.txt
  perl -pi -e 's#data/rir#data/rir_16k#g' ${train_data_dir}/rir.txt
  
  # just use the book wav as interspeech2020
  grep book train_data_fsn_dns_master/clean.txt > train_data_fsn_dns_master/clean_book.txt

  test_set=${corpus_name}/DNS-Challenge/DNS-Challenge-interspeech2020-master/datasets/test_set
  if [ ! -d ${test_set} ]; then
    echo "please prepare the ${test_set} from https://github.com/microsoft/DNS-Challenge/tree/interspeech2020/master/datasets/test_set"
    exit
  fi
fi


#############################################
## -- STAGE 1 : TRAIN
if [ ${stage} -le 1 ] && [ ${stop_stage} -ge 1 ]; then
  # CUDA_VISIBLE_DEVICES='0,1' python -m speech_enhance.tools.train -C config/train.toml -N 2
  CUDA_VISIBLE_DEVICES='0' python -m speech_enhance.tools.train -C config/train.toml -N 1
fi


#############################################
## -- STAGE 2 : TEST
if [ ${stage} -le 2 ] && [ ${stop_stage} -ge 2 ]; then
  input_dir="test/input"
  output_dir="test/output"

  CUDA_VISIBLE_DEVICES=0  \
  python -m speech_enhance.tools.inference \
    -C config/inference.toml \
    -M logs/FullSubNet/train/checkpoints/best_model.tar \
    -I ${input_dir} \
    -O ${output_dir}
  
  # # norm volume to -6db
  # for f in `ls ${output_dir}/*.wav | grep -v norm`; do
  #   echo $f
  #   fid=`basename $f .wav`
  #   fo=`dirname $f`/${fid}_norm-6db.wav
  #   echo $fo
  #   sox $f -b16 $fo rate -v -b 99.7 24k norm -6
  # done
fi
