# Overview

Modelling of road traffic noise and air pollution exposure for health studies requires detailed information on annual average daily traffic (AADT) flows on all roads. Europe-wide estimates on AADT are not publicly available, and thus, we aimed to fill this gap by building a model framework to estimate Europe-wide AADT. We collected open-source observations on AADT, and we built separate random forest (RF) models for different road types defined in OpenStreetMap. Predictors offered were population-, road-, and topology-related variables, collected from open-source data.

Here we publish the model framework with a subset of data (N=200) for test. 
The scripts for the model framework and validation can be found in `src/`.

Spatial maps of traffic estimates summed across various buffer sizes are freely available on Google Earth Engine (GEE) for academic use, as detailed in the [Output section](#output-section).

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


## Output 
<a name="output-section"></a>
### Spatial maps of traffic estimates in various buffer sizes (50m-5km)

We pubish spatial maps of the sum of the on-road AADT estimates within various circular buffer sizes (50 m, 100 m, 200 m, 300 m, 400 m, 500 m, 700 m, 1 km, 2 km, 5 km).

The spatial maps are stored as a multi-band image on Google Earth Engine (GEE), with each band labeled as aadt_[buffer in meters].


* [Asset on GEE](https://code.earthengine.google.com/?asset=projects/ee-airview/assets/aadt)


* [A GEE example code for visualization](https://code.earthengine.google.com/87bea25eaf6c3e13390cce851c129826)
```js
var map = ee.Image("projects/ee-airview/assets/aadt");
var palette = ["000000", "#0000cd","#69a3cf","#7cb8de","#e2eb71", 
               "#ebb671", "#e3702d", "#fa0000"];
Map.setCenter(7.5277, 51.754, 6)
Map.addLayer(map.select("aadt_50"), 
            {min:50000, max:500000, palette: palette}, "sum of AADT within 50 m")
            
Map.addLayer(map.select("aadt_500"), 
            {min:0, max:10000000, palette: palette}, "sum of AADT within 500 m")
```





## Citation
Shen, Y., de Hoogh, K., Schmitz, O., Gulliver, J., Vienneau, D., Vermeulen, R., Hoek, G., Karssenberg, D., 2024. Europe-wide high-spatial resolution air pollution models are improved by including traffic flow estimates on all roads. Atmos. Environ. 335, 120719. https://doi.org/10.1016/j.atmosenv.2024.120719

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.15113807.svg)](https://zenodo.org/records/15113807)


## License

This project is licensed under the terms of the [MIT License](/LICENSE).

