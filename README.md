
# FullSubNet+ / Inter-SubNet

### 1. FullSubNet+

**"[FullSubNet+: Channel Attention FullSubNet with Complex Spectrograms for Speech Enhancement](https://arxiv.org/abs/2203.12188)"**,  accepted by ICASSP 2022.

📜[[Full Paper](https://arxiv.org/abs/2203.12188)] ▶[[Demo](https://hit-thusz-rookiecj.github.io/fullsubnet-plus.github.io/)] 💿[[Checkpoint](https://drive.google.com/file/d/1UJSt1G0P_aXry-u79LLU_l9tCnNa2u7C/view)]

16kHz, 3분 짜리 음원 한 번에 Inference 가능 (RTX4090 24GiB 기준)

<br/>

### 2. Inter-SubNet

**"[Inter-SubNet: Speech Enhancement with Subband Interaction](https://arxiv.org/abs/2305.05599)"**,  accepted by ICASSP 2023.

📜[[Full Paper](https://arxiv.org/abs/2305.05599)] ▶[[Demo](https://rookiejunchen.github.io/Inter-SubNet_demo/)] 💿[[Checkpoint](https://drive.google.com/file/d/1j9jdXRxPhXLE93XlYppCQtcOqMOJNjdt/view?usp=share_link)]

16kHz, 2분 짜리 음원 한 번에 Inference 가능 (RTX4090 24GiB 기준)

<br/>

## Requirements

- Linux or macOS 

- python>=3.6

- Anaconda or Miniconda

- NVIDIA GPU + CUDA CuDNN (CPU can also be supported)



### Environment && Installation

Install Anaconda or Miniconda, and then install conda and pip packages:

```shell
# Create conda environment
conda create --name speech_enhance python=3.6
conda activate speech_enhance

# Install conda packages
# conda install pytorch torchvision torchaudio cudatoolkit=10.2 -c pytorch
pip3 install torch==1.8.2 torchvision==0.9.2 torchaudio==0.8.2 --extra-index-url https://download.pytorch.org/whl/lts/1.8/cu111
conda install tensorboard joblib matplotlib

# Install pip packages
pip install Cython
pip install librosa pesq pypesq pystoi tqdm toml colorful mir_eval torch_complex

# (Optional) If you want to load "mp3" format audio in your dataset
conda install -c conda-forge ffmpeg
```



### Quick Usage
Download the [FullSubnet pre-trained checkpoint](https://drive.google.com/file/d/1UJSt1G0P_aXry-u79LLU_l9tCnNa2u7C/view) at './pretraind', and input commands:
Download the [InterSubnet pre-trained checkpoint](https://drive.google.com/file/d/1j9jdXRxPhXLE93XlYppCQtcOqMOJNjdt/view?usp=share_link) at './pretraind', and input commands:

```shell
conda activate speech_enhance

# Full-Subnet Inferencer
bash infer_fsnet.sh

# Inter-Subnet Inferencer
bash infer_isnet.sh
```

<br/> 

## Start Up

### Clone

```shell
git clone https://github.com/RookieJunChen/Inter-SubNet.git
cd Inter-SubNet
```



### Data preparation

#### Train data

Please prepare your data in the data dir as like:

- data/DNS-Challenge/DNS-Challenge-interspeech2020-master/
- data/DNS-Challenge/DNS-Challenge-master/

and set the train dir in the script `run.sh`.

Then:

```shell
source activate speech_enhance
bash run.sh 0   # peprare training list or meta file
```

#### Test data

Please prepare your test cases dir like: `data/test_cases_<name>`, and set the test dir in the script `run.sh`.



### Training

First, you need to modify the various configurations in `config/train.toml` for training.

Then you can run training:

```shell
source activate speech_enhance
bash run.sh 1   
```



### Inference

After training, you can enhance noisy speech.  Before inference, you first need to modify the configuration in `config/inference.toml`.

You can also run inference:

```shell
source activate speech_enhance
bash run.sh 2
```

Or you can just use `inference.sh`:

```shell
source activate speech_enhance
bash inference.sh
```





### Eval

Calculating objective metrics (SI_SDR, STOI, WB_PESQ, NB_PESQ, etc.) :

```shell
bash metrics.sh
```

For test set without reference, you can obtain subjective scores (DNS_MOS and  NISQA, etc) through [DNSMOS](https://github.com/RookieJunChen/dns_mos_calculate) and [NISQA](https://github.com/RookieJunChen/my_NISQA).




## Citation
If you find our work useful in your research, please consider citing:
```
@inproceedings{chen2023inter,
  title={Inter-Subnet: Speech Enhancement with Subband Interaction},
  author={Chen, Jun and Rao, Wei and Wang, Zilin and Lin, Jiuxin and Wu, Zhiyong and Wang, Yannan and Shang, Shidong and Meng, Helen},
  booktitle={ICASSP 2023-2023 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)},
  pages={1--5},
  year={2023},
  organization={IEEE}
}
```
