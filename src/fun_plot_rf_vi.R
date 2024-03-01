# To plot variable importance derived from a random forests model
plot_rf_vi <- function(csv_name, var_no, title_name=csv_name){
   var_importance <- read.csv(paste0('data/workingData/RF_vi_', csv_name, '.csv'), 
                              header = T)
   ggplot(var_importance %>% top_n(var_no, vi))+
      geom_col(aes(reorder(var_name, vi), vi),
               position = 'dodge', fill='khaki')+
      coord_flip() +
      theme_light()+
      labs(x = 'variable', y = 'importance value (impurity)',
           title = title_name)+
      theme(axis.title = element_text(size = 11),
            axis.text = element_text(size = 11),
            legend.title = element_text(size = 11),
            legend.text = element_text(size = 11),
            strip.text.y = element_text(size = 11))
}