# eccb2022_sc_funcomics
Functional analysis of single-cell transcriptomics Tutorial

## Instalation
To install the python dependencies run:

```
# install mamba (faster than conda)
pip install mamba
# create an environment with the necessary packages
mamba env create -f scanpy_env.yml
# activate the environment
conda activate scanpy
# add environment as kernel for jupyter-lab
python -m ipykernel install --user --name=scanpy --display-name='scanpy'
```

Then to start working run:
```
jupyter-lab
```

## Overview

Part I - Pau

Load, filter, integrate, etc

Part II - Daniel

1. Start /w how the single-cell field has been moving away from atlas-like datasets
for some years now, and having contrasts between conditions blah blah blah

Multi-cellular insights across conditions are replacing the identification of
diverse cell types, or sc atlases.

2. Pseudobulk MSigDB between the conditions

3. Introduce the concept of footprints

4. Enrichment /w 

5. CCC intro

6. Load R env

7. Run liana on disease alone


Part III - Robin

