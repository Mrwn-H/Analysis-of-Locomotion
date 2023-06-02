# EPFL BIOENG-404: Analysis and modeling of locomotion

This is the code for the NeuroRestore project.

## IMPORTANT: place of data in code

To make sure all code runs well, the datasets have to be placed in a particular way, described bellow. Please replicate the `data` folder as bellow, placed at the same level as main.m :

```
Analysis-of-Locomtion
├── data 
│   ├── Healthy Dataset
│   │   ├── 01
│   │   │   ├── 1_AML01_2kmh.mat
│   │   │   ├── (...)
│   │   ├── 02
│   │   │   ├── 1_AML02_2kmh.mat
│   │   │   ├── (...)
│   ├── SCI Human
│   │   ├── DM002_TDM_1kmh_NoEES.mat
│   │   ├── (...)
├── Functions
│   ├── (...)
├── main.m
├── neural_net.m
├── (...)
```
## Code description

---

### `main.m`

---

### `neural_net.m`

A script to define, train and save a neural network.

---

### `test_model_onSCI.m`

A script to load a model and test its predictions on the SCI dataset by visualising the 3D animation of the locomotion.

---

### `Functions`

A folder containing various functions

---

### `Functions/computePCA.m`

DESCRIPTION

---


## Authors

- Marwan Haioun

- Loic Pachoud

- Alexei Ermochkine

- Nicolas Nouel
