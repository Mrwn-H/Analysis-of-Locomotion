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

Inptuts: dataset, gait events

Output: PCA coefficient, score, explained_ratio 

Function that compute PCA over given dataset

---

### `Functions/getEvents.m`

Input: kinematic_Data, sampling time, data info (healthy or SCI)

Output: Left Gait Event, Right Gait Event

Function that compute kinematically gait events 

---

### `Functions/getAllEvents.m`

Function that calls getEvents in order to apply it to the whole dataset:

---

### `Functions/getEnv.m`

Inputs: Emg signal, and a boolean (if plotting is needed)

Output: Processed signal

Function that apply a low-pass filter, who rectify the signal and envevelope it

---

### `Functions/geKinematicParams`

Inputs: Dataset, Gait Events

Output: Kinematic parameters for PCA analysis

Function that compute kinematic parameters 

---

### `Functions/geVelocityParams`

Inputs: Dataset, Gait Events

Output: Kinetics parameters for PCA analysis

Function that that compute kinetic parameters 


## Authors

- Marwan Haioun

- Loic Pachoud

- Alexei Ermochkine

- Nicolas Nouel
