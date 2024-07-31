# Simulation Database

Utility for Financial Simulation in the Maxe context.

## Persist Simulated Data

When using the Maxe simulator to generate data from `.xml` config files or parameters, the data is typically discarded afterward. As simulations are run frequently throughout the project (e.g., generating training data, optimization, and calibration), and given that simulations can be resource-intensive, a more efficient solution is to save the simulated data for later use.

This repository provides a method to simulate data with given parameters, save the corresponding simulated data into hashed folders, and record the simulation information in a MongoDB database.

## Manual

### Quick Start

#### 1. Setup MongoDB
First, set up a MongoDB service and obtain the connection string, such as:

```bash
mongodb://username:password@host:port/?directConnection=true&authSource=simulation
```

If you are a member of Prof. Yang's team and have access to the School Intranet, you can connect to my MongoDB with:

```bash
mongodb://maxe:maxe123456@10.16.12.105:27017/?directConnection=true&authSource=simulation
```

#### 2. Customize Configuration
Rename `config_template.json` to `config.json` and set the configurations as desired.

#### 3. Build Maxe
Build the Maxe Simulator on the machine where your project will run. Refer to the manual from the `Maxe` project for instructions.

It is recommended to create a symbolic link to the Simulator in `/usr/bin` to simplify calling `TheSimulator`:

```bash
sudo ln -s /abs/path/to/theSimulator /usr/bin/
```

#### 4. Call the Method
Import the methods and run them as described in the documentation.


## Database

### Machanism

* Every time the generation method is called, the data will be saved to the database with the aformentioned information automatically. 
* When you want the raw data of some given parameters, the method will search the database first, if it has already been generated, the simulation process will instead by the data stored in the database.
* Raw CSV data will be saved in the local machine instead of in the database for the sack of flexibilty and efficiency. Data could be retrived by the `file_path` attribute in the select result by `mongodb SQL query` or methods in `RawDataManager` class.  



## New Features

### 1. Data Generation
All temporary files in the Maxe simulation process are generated in memory, not on disk. This accelerates the simulation and avoids errors caused by disk write delays. Temporary visual files have randomly hashed names to prevent read/write errors associated with physical file systems.

### 2. Logging
The logger can save output throughout the project, making it easier to review your experiments later. This feature enhances convenience and ensures you have a comprehensive record of your simulation runs.

### 3. Database
The database persists the generated simulation data, ensuring that no data is wasted. This stored data can be reused in future work, such as training surrogate models or conducting simulation-based inference.
