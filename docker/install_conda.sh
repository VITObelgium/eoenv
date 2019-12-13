# stop in case of errors
set -e

# check that USERNAME is set to your username
export USERNAME=`id -u -n`
export ENV_NAME="base"  # This should be the name of the environment
export CONDA_ENV_YML="environment.yml"

# export HOME="/home/$USERNAME"
export MINICONDA_PREFIX="$HOME/miniconda3"
export MINICONDA_PATH="$HOME/miniconda3/bin"

# install gcc
sudo apt-get update && sudo apt-get install -y gcc

# Download latest miniconda and install
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     bash Miniconda3-latest-Linux-x86_64.sh -b -p ${MINICONDA_PREFIX} && \
     rm Miniconda3-latest-Linux-x86_64.sh

$MINICONDA_PATH/conda init

# .bashrc cannot be source from script in ubuntu, use this workaround
sed "s/dzanaga/${USERNAME}/g" user_aliases_conda.sh >> ${HOME}/.conda_init
source ${HOME}/.conda_init

# configure conda to always install first from conda-forge
# this avoids conflicts
conda config --set channel_priority strict
conda config --add channels conda-forge

# Install `eo` libraries from yml file
conda env update -f ${CONDA_ENV_YML}


