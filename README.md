# Overview

Modelling of road traffic noise and air pollution exposure for health studies requires detailed information on annual average daily traffic (AADT) flows on all roads. Europe-wide estimates on AADT are not publicly available, and thus, we aimed to fill this gap by building a model framework to estimate Europe-wide AADT. We collected open-source observations on AADT, and we built separate random forest (RF) models for different road types defined in OpenStreetMap. Predictors offered were population-, road-, and topology-related variables, collected from open-source data.

Here we publish the model framework with a subset of data (N=200) for test. 
The scripts for the model framework and validation can be found in `src/`.

## Project Structure


* read-only (RO): not edited by either code or researcher
* human-writeable (HW): edited by the researcher only.
* project-generated (PG): folders generated when running the code; these folders can be deleted or emptied and will be completely reconstituted as the project is run.

```
.
├── .gitignore
├── CITATION.cff
├── LICENSE
├── README.md
├── requirements.txt
├── data               <- All project data, ignored by git
│   ├── processed      <- The final, canonical data sets for modeling. (PG)
│   ├── workingData    <- data generated during model development. (PG)
│   ├── raw            <- The original, immutable data dump. (RO)
│   └── temp           <- Intermediate data that has been transformed. (PG)
└── src                  <- Source code for this project (HW)

```

## Data `data/`

* `./data/raw/shared_dataN200.csv` contains a subset of data points with observed AADT counts and derived predictor variables.
* Folder `./data/workingData/` contains all csv files generated during model development process.


## source code `src/`

* `01_traffic_rf_5fold_finalv2_resNoXY.R` builds random forests model with 5-fold CV setting.
* `02_evaluate_5foldCV.R` evaluates the 5-fold CV result.
* `fun_...` are ancillary scripts.

## Add a citation file

## License

This project is licensed under the terms of the [MIT License](/LICENSE).
