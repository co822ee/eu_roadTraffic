# To create fold with stratification indicated
create_fold <- function(data_df, seed=123, strt_group, 
                        nfold=5, m_var='m'){
   # data_df: the dataset you want to split for training and testing
   # seed: 123
   # strt_group: groups for stratification
   #f# subset cross-validation data (n-fold cross-validation)
   #f# stratified by station types, climate zones for single-year modelling
   #f# stratified by station types, climate zones
   #                   and availability over time for multiple-year modelling
   
   #f# leave-location-out cv for multiple-year modelling
   data_df2 <- data_df
   
   
   set.seed(seed)
   data_df2$index <- 1:nrow(data_df2)
   
   index_tmp <- vector("list", length=nfold)
   
   for(i_fold in seq_along(index_tmp)){
      # print(paste0("fold: ", i_fold))
      if(i_fold==1){
         train_sub <- stratified(data_df2, strt_group, 1-(1/nfold))
         test_sub <- data_df2[-train_sub$index, ]
         index_tmp[[i_fold]] <- test_sub$index
         # nrow(data_df2) %>% print()
         fold_ratio_left <- 1-(1/nfold)
         index_used <- test_sub$index
         length(index_used)
      }else{
         if(i_fold!=nfold){
            # data_df2[-(index_used),]$index%in%train_sub$index %>% all()
            # test_sub2 <- stratified(train_sub, strt_group, 0.2/0.8)
            fold_ratio <- (1/nfold)/fold_ratio_left
            
            test_sub2 <- stratified(data_df2[-(index_used),], strt_group, fold_ratio)
            index_used <- c(test_sub2$index, index_used)
            train_sub2 <- data_df2[-index_used, ]
            index_tmp[[i_fold]] <- test_sub2$index
            
            fold_ratio_left <- 1-(rep(1/nfold, i_fold) %>% sum)
            
         }else{
            test_sub2 <- data_df2[-(index_used),]
            index_tmp[[i_fold]] <- test_sub2$index
         }
         
         any(duplicated(index_used))
         length(index_used)
      } 
   }
   # Indices in all folds are unique
   sapply(index_tmp, length)
   index_df <- lapply(seq_along(index_tmp), function(index_group){
      data.frame(index=index_tmp[[index_group]], nfold=index_group)
   })
   sapply(index_df, dim)
   index_df <- do.call(rbind, index_df)
   data_df2 <- inner_join(data_df2, index_df, by="index")
   
   # return data_df2
   return(data_df2)
}

