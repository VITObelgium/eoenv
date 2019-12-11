# stop in case of errors
set -e

# check that USERNAME is set to your username
export USERNAME=`id -u -n`
export ENV_NAME="eo"  # This should be the name of the environment
export CONDA_ENV_YML="environment.yml"

# export HOME="/home/$USERNAME"
export MINICONDA_PREFIX="$HOME/miniconda3"
export MINICONDA_PATH="$HOME/miniconda3/bin"

export JUPYTER_PORT="9090"

# Download latest miniconda and install
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     bash Miniconda3-latest-Linux-x86_64.sh -b -p ${MINICONDA_PREFIX} && \
     rm Miniconda3-latest-Linux-x86_64.sh

$MINICONDA_PATH/conda init

# the above command will paste a block of code to .bashrc
# On the MEP, .bashrc is handles by Puppet, which means that to make
# anaconda initialization permanent we need to copy and paste that block
# to .user_aliases. This is carried out with the command below
sed "s/dzanaga/${USERNAME}/g" user_aliases_conda.sh >> ${HOME}/.user_aliases
source ${HOME}/.bashrc

# configure conda to always install first from conda-forge
# this avoids conflicts
conda config --set channel_priority strict
conda config --add channels conda-forge

# Install Nodejs (needed for ipympl interactive plots with matplotlib in jupyter)
conda install -y nodejs

# Install default packages of the base environment
pip install -r requirements.txt

# Compile jupyterlab extensions for interactive plots
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install jupyter-matplotlib

# Install `eo` environment from yml file
conda env create -f ${CONDA_ENV_YML}

# Activate environment and install ipykernel for jupyter
source $(conda info --base)/etc/profile.d/conda.sh
conda activate ${ENV_NAME}
python -m ipykernel install --user --name ${ENV_NAME} --display-name "Python 3.7 (${ENV_NAME})"

# Install Jupyter Server as a system service
# generate config file and add hashed password 'jupyter'
jupyter notebook --generate-config -y
echo "c.NotebookApp.password = 'sha1:0e87afb7b28b:eeff20d53c6bd5c48fbd893888280fdaa54a7888'" >> ~/.jupyter/jupyter_notebook_config.py

# generate system service
printf """[Unit]
Description=Jupyter Lab Server

[Service]
Type=simple
ExecStart=${MINICONDA_PATH}/jupyter lab --port ${JUPYTER_PORT} --no-browser
WorkingDirectory=${HOME}
User=`id -u -n`
Group=`id -g -n`
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
""" > jupyter.service

sudo mv jupyter.service /etc/systemd/system/jupyter.service

# Enable and start jupyter server system service
sudo systemctl enable jupyter.service
sudo systemctl start jupyter.service

# to check the it's running
# sudo systemctl status -l jupyter.service
