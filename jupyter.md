# Run Jupyter Lab as background service

## Jupyter configuration

Generate a config:
```
jupyter notebook --generate-config
```
Open it `$HOME/.jupyter/jupyter_notebook_config.py` and insert the modify it accordingly (port, token/hashed password):

## Run as a system service
Create the service file:
```
sudo vi /etc/systemd/system/jupyter.service
```

or copy a template and edit
```
sudo cp /data/users/Public/dzanaga/eoenv/jupyter.service /etc/systemd/system/jupyter.service
```

content:

```
[Unit]
Description=Jupyter Lab Server

[Service]
Type=simple
ExecStart=/home/dzanaga/miniconda3/bin/jupyter lab --port 9090
WorkingDirectory=/home/dzanaga/repos
User=dzanaga
Group=vito
RestartSec=10
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start the service:
```
sudo systemctl enable jupyter.service
sudo systemctl start jupyter.service
```
check it's running:
```
sudo systemctl | grep jupyter.service
```
and in more detail:
```
sudo systemctl status -l jupyter.service
```
