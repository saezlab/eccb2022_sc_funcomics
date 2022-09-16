# eccb2022_sc_funcomics
Functional analysis of single-cell transcriptomics Tutorial

## Part1

### Instalation
To install the python dependencies run:

```
# install mamba (faster than conda)
pip install mamba
# create an environment with the necessary packages
mamba env create -f scanpy_env.yml --name scanpy
# activate the environment
conda activate scanpy
# add environment as kernel for jupyter-lab
python -m ipykernel install --user --name=scanpy --display-name='scanpy'
```

Then to start working run:
```
jupyter-lab
```

## Part2

### Installation
```
mamba create -n seurat -c conda-forge -c bioconda r-seurat=4*
```

Then to start working run:
```
rstudio
```


## Overview

