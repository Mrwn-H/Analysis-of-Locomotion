# EPFL BIOENG-404: Analysis and modeling of locomotion

This is the code for the NeuroRestore project.


## Repository Structure

```
├── README.md
├── main.py
├── requirements.pip
├── data # contains train/test data for every maturity and frequency
│   ├── 1month
│   │   ├── 1d
│   │   │   ├── asset_price_GBM_sim.csv
│   │   │   ├── asset_price_mixed_sim.csv
│   │   │   ├── asset_price_price_sim.csv
│   │   │   ├── option_price_GBM_sim.csv
│   │   │   ├── option_price_mixed_sim.csv
│   │   │   └── option_price_SABR_sim.csv
│   │   ├── 2d
│   │   ├── 3d
│   │   └── 5d
│   └── 3month
│       └── ...
│── model # pretrained model parameters
│   ├── v1
│   ├── ...
│   ├── v9
│   │   ├── actor_weight.pt
│   │   ├── critic_1_weight.pt
│   │   ├── critic_2_weight.pt
│   │   ├── price_stat.json # need this for state normalization
│   │   └── results.csv # results stored as csv file
│   ├── hypparams.json
│   └── report.txt
│
│── notebooks # contains notebooks to reproduce results and generate data
│   ├── performance_test.ipynb
│   ├── simulation.ipynb
│   └── README.md
│
└── src # DDPG agent, StockTradingEnv source code
    ├── README.md
    ├── agent.py
    ├── buffer.py
    ├── env.py
    ├── hyperparam_tuning.py
    ├── network.py
    └── simulation.py
```

## Code description

---

### `Functions`

A folder containing various functions

---

### `Functions/computePCA`

DESCRIPTION

---

## Authors

- Marwan

- Loic Pachoud

- Alexei Ermochkine

- Nicolas
