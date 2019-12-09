# copy eoenv folder to your VM home folder, execute ./eoenv/install_conda_auto.sh
# from the home directory

cd ${HOME}

# check that USERNAME is set to your username
export USERNAME=`id -u -n`
export ENV_NAME="eo"  # This should be the name of the environment
export CONDA_ENV_YML="eoenv/environment.yml"

export HOME="/home/$USERNAME"
export MINICONDA_PATH="/home/$USERNAME/miniconda3/bin"

# Download latest miniconda and install
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b && \
    rm Miniconda3-latest-Linux-x86_64.sh

$MINICONDA_PATH/conda init

sed "s/dzanaga/${USERNAME}/g" eoenv/user_aliases_conda >> .user_aliases
source .bashrc

conda config --set channel_priority strict
conda config --add channels conda-forge

# Install Nodejs (needed for ipympl interactive plots in matplotlib)
conda install -y nodejs
pip install jupyterlab ipykernel ipympl python-language-server flake8 autopep8 \
            rmate
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install jupyter-matplotlib

# Install `eo` environment from yml file
conda env create -f ${CONDA_ENV_YML}

# Activate environment and install ipykernel for jupyter
source $(conda info --base)/etc/profile.d/conda.sh
conda activate $ENV_NAME
python -m ipykernel install --user --name $ENV_NAME --display-name "Python 3.7 ($ENV_NAME)"

# Install Jupyter Server as a system service
# MINICONDA_PATH=`which conda | xargs dirname`
PORT="9090"

jupyter notebook --generate-config  # generate config file

echo "c.NotebookApp.password = 'sha1:0e87afb7b28b:eeff20d53c6bd5c48fbd893888280fdaa54a7888'" >> ~/.jupyter/jupyter_notebook_config.py

printf """[Unit]
Description=Jupyter Lab Server

[Service]
Type=simple
ExecStart=${MINICONDA_PATH}/jupyter lab --port ${PORT} --no-browser
WorkingDirectory=${HOME}
User=`id -u -n`
Group=`id -g -n`
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
""" >> jupyter.service

sudo mv jupyter.service /etc/systemd/system/jupyter.service

sudo systemctl enable jupyter.service
sudo systemctl start jupyter.service
