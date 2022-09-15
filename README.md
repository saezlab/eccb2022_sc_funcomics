# eccb2022_sc_funcomics
Functional analysis of single-cell transcriptomics Tutorial


## Instalation
To install the python dependancies run:
```
pip install mamba
mamba env create -f scanpy_env.yml
conda activate scanpy
python -m ipykernel install --user --name=scanpy --display-name='scanpy'
```

Then to start working run:
```
jupyter-lab
```