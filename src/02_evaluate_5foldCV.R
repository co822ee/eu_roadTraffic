test_dfRoad1 <- lapply(paste0('data/workingData/', 'RF_result_all_all_finalv2resNoXY_eu_fold', 1:5, 'defaultRoad1.csv'),
                       function(filename) read.csv(filename))
test_dfRoad2 <- lapply(paste0('data/workingData/', 'RF_result_all_all_finalv2resNoXY_eu_fold', 1:5, 'defaultRoad2.csv'),
                       function(filename) read.csv(filename))
test_dfRoad3 <- lapply(paste0('data/workingData/', 'RF_result_all_all_finalv2resNoXY_eu_fold', 1:5, 'defaultRoad3.csv'),
                       function(filename) read.csv(filename))
test_dfRoad4 <- lapply(paste0('data/workingData/', 'RF_result_all_all_finalv2resNoXY_eu_fold', 1:5, 'defaultRoad4.csv'),
                       function(filename) read.csv(filename))


test_dfRoad1 <- lapply(test_dfRoad1, function(fold_df){
  outdf <- fold_df %>% filter(df_type=='test')
  outdf
}) %>% do.call(rbind, .)
test_dfRoad2 <- lapply(test_dfRoad2, function(fold_df){
  outdf <- fold_df %>% filter(df_type=='test')
  outdf
}) %>% do.call(rbind, .)
test_dfRoad3 <- lapply(test_dfRoad3, function(fold_df){
  outdf <- fold_df %>% filter(df_type=='test')
  outdf
}) %>% do.call(rbind, .)

test_dfRoad4 <- lapply(test_dfRoad4, function(fold_df){
  outdf <- fold_df %>% filter(df_type=='test')
  outdf
}) %>% do.call(rbind, .)

test_df <- rbind(test_dfRoad2, test_dfRoad1, test_dfRoad3, test_dfRoad4)


# Model performance
error_df <- round(data.frame(error_matrix(test_df$obs, test_df$rf)), 3)[c(1,2,7),]
error_df <- data.frame(t(data.frame(error_df)))
error_df <- cbind(error_df, round(cor(test_df$obs, test_df$rf)^2, 3))
colnames(error_df) <- c('RMSE','RRMSE','MSE-R2','R2')
error_df <- cbind(n=nrow(test_df), error_df)
error_df

# Model performance (road type)
lapply(unique(test_df$road_tag), function(roadtype){
  sub_df <- test_df[test_df$road_tag==roadtype,]
  error_df <- round(data.frame(error_matrix(sub_df$obs, sub_df$rf)), 3)[c(1,2,7),]
  error_df <- data.frame(t(data.frame(error_df)))
  error_df <- cbind(error_df, round(cor(sub_df$obs, sub_df$rf)^2, 2))
  colnames(error_df) <- c('RMSE','RRMSE','MSE-R2','R2')
  error_df <- cbind(n=nrow(sub_df), error_df, road_tag=roadtype)
  error_df
}) %>% do.call(rbind, .)

