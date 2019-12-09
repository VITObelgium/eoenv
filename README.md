# Install Miniconda3 on your MEP VM

This script will install an Anaconda python distribution (Miniconda flavor - only the base packages will be present in the `base` environment)
on your MEP VM.

Together with Miniconda it will install a conda environment named `eo` with the packages specified in the `environment.yml` which includes the main libraries needed for geospatial analysis `(GDAL, geopandas, rasterio, ...)` 

Finally it will install `JupyterLab` together with `ipympl` for interactive plotting and start a Jupyter server on (default) port 9090 running in the background of your MEP VM.

To access the server browse to `localhost:9090` on your VM (or open an SSH tunnel from your local client and enable remote access)

If on Windows, you can use the [SSH Tunnel](https://www.microsoft.com/store/productId/9NR7P38PKLT4) utility available on the Microsoft Store.

## Installation

From your VM terminal:
```
cd ~
git clone https://git.vito.be/scm/lclu/eoenv.git

bash eoenv/install.sh
```

Once the installation is completed you should be able to open jupyter at `localhost:9090`

The default password is `jupyter`. 

To verify the anaconda installation, open a *new* terminal, you should see `(base)` on the left of the line prompt. Furthermore running `which conda` should return the path to the `conda` binary. 

To activate the `eo` environment, run `conda activate eo`.

### Interactive plotting

In a notbook cell, before importing `matplotlib` execute `%matplotlib widget`.

When exporting notebooks to html the interactive plots will not be rendered, for that purpose use
`%matplotlib inline`