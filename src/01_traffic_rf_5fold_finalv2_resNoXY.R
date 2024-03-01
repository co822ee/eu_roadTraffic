# Call the library
source('src/fun_call_lib.R')
nfold <- 5
cluster_no <- 5
cl <- parallel::makeCluster(cluster_no)
doParallel::registerDoParallel(cl)
foreach(fold = 1:nfold)  %dopar%  {
   library(caret)
   library(dplyr)
   source('src/fun_call_lib.R')
   set.seed(123)
   nfold <- 5

   
   ch2 <- read.csv("data/raw/shared_dataN200.csv")
   exc_names <- c('system.index','.geo', 'year','cntr','aadt','method',
                  'road_tag', 'X', 'Y')
   pred_names <- names(ch2)[!names(ch2)%in%exc_names]
   
   source('src/fun_create_fold.R')
   ch2 <- create_fold(ch2, seed=123, nfold=nfold, strt_group=c('cntr','road_tag','area_type'))
   csv_name <- paste0('all_finalv2resNoXY_eu_fold', fold) 
   test_df <- ch2[ch2$nfold==fold,]
   train_df <- ch2[-test_df$index, ]
   
   
   x_varname = names(train_df %>% dplyr::select(all_of(pred_names)))
   print("RF predictors:")
   print(x_varname)
   
   train_dfRoad1 <- train_df %>% filter(road_tag=='highway')
   train_dfRoad2 <- train_df %>% filter(road_tag=='primary')
   train_dfRoad3 <- train_df %>% filter(road_tag=='localA')
   train_dfRoad4 <- train_df %>% filter(road_tag=='residential')
   
   
   test_dfRoad1 <- test_df %>% filter(road_tag=='highway')
   test_dfRoad2 <- test_df %>% filter(road_tag=='primary')
   test_dfRoad3 <- test_df %>% filter(road_tag=='localA')
   test_dfRoad4 <- test_df %>% filter(road_tag=='residential')
   
   source("src/fun_opt_rf.R")
   tuneRF_b=F
   rf_resultRoad1 <- opt_rf(train_dfRoad1, test_dfRoad1,
                            y_varname='aadt',
                            x_varname = x_varname,
                            paste0(csv_name, 'defaultRoad1'), 0, tuneRF_b,#hyper_gridRoad1
                            outputselect = c("index","rf", "obs", "res",'df_type','cntr', 'X','Y', 'road_tag', 'area_type'))[[1]] %>%
      filter(df_type=='train') %>%
      dplyr::select(-df_type)
   rf_resultRoad2 <- opt_rf(train_dfRoad2, test_dfRoad2,
                            y_varname='aadt',
                            x_varname = x_varname,
                            paste0(csv_name, 'defaultRoad2'), 0, tuneRF_b,
                            outputselect = c("index","rf", "obs", "res",'df_type','cntr', 'X','Y', 'road_tag', 'area_type'))[[1]] %>%
      filter(df_type=='train') %>%
      dplyr::select(-df_type)
   rf_resultRoad3 <- opt_rf(train_dfRoad3, test_dfRoad3,
                            y_varname='aadt',
                            x_varname = x_varname,
                            paste0(csv_name, 'defaultRoad3'), 0, tuneRF_b,
                            outputselect = c("index","rf", "obs", "res",'df_type','cntr', 'X','Y', 'road_tag', 'area_type'))[[1]] %>%
      filter(df_type=='train') %>%
      dplyr::select(-df_type)
   rf_resultRoad4 <- opt_rf(train_dfRoad4, test_dfRoad4,
                            y_varname='aadt',
                            x_varname = x_varname,
                            paste0(csv_name, 'defaultRoad4'), 0, tuneRF_b,
                            outputselect = c("index","rf", "obs", "res",'df_type','cntr', 'X','Y', 'road_tag', 'area_type'))[[1]] %>%
      filter(df_type=='train') %>%
      dplyr::select(-df_type)
   
   source("src/fun_plot_rf_vi.R")
   # The variable importance is rather very similar
   plot_rf_vi(paste0(csv_name, 'defaultRoad1'), var_no = 20)
   plot_rf_vi(paste0(csv_name, 'defaultRoad2'), var_no = 20)
   plot_rf_vi(paste0(csv_name, 'defaultRoad3'), var_no = 20)
   plot_rf_vi(paste0(csv_name, 'defaultRoad4'), var_no = 20)
   
}
stopCluster(cl)
gc()
