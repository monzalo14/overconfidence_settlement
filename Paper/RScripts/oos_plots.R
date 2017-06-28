# Scatter plots de predicciones
# Continuas
source('aux_oos_plots.R')
#load(modelos)
#load(datos)

# Usamos la lista de nombres de modelos continuos para generar la lista de gráficas y sus títulos

outcomes = c('caducidad', 'convenio', 'desiste', 'laudo_gana', 'laudo_pierde')
cont_modelname_list = c(paste0('duracion_', outcomes), 'liqtotal_laudo_gana', 'liqtotal_convenio')
cont_variablename_list = c(rep('liqtotal', 2), rep('duracion', 5)) 
cont_title_list = c('Expiry', 'Settlement', 'Drop', 'Winning Court Ruling', 'Losing Court Ruling', 'Settlement', 'Winning Court Ruling')
names(cont_title_list) = cont_modelname_list
names(cont_variablename_list) = cont_modelname_list
names(cont_modelname_list) = cont_modelname_list

# Generamos listas de gráricas, para duración y liqtotal
# duracion_plot_list <- lapply(cont_modelname_list[1:5]),
#                     FUN = function(x){
#                       plot_oos_fit_r2(data_list[[x]], cont_modelname_list[x], cont_variablename_list[x])})

# liqtotal_plot_list <- lapply(cont_modelname_list[6:7]),
#                     FUN = function(x){
#                       plot_oos_fit_r2(data_list[[x]], cont_modelname_list[x], cont_variablename_list[x])})


# Clasificadores

accuracy_data = data.frame(model = c('Settlement',
                                     'Drop',
                                     'Expiry',
                                     'Won Court Ruling',
                                     'Lost Court Ruling'),
                           accuracy = c(0.61,
                                        0.78,
                                        0.93,
                                        0.67,
                                        0.69))

ggplot(accuracy_data, aes(model, accuracy)) +
  geom_bar(stat = 'identity') +
  labs(title = 'Accuracy Rate',
       y = '',
       x = '') +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_classic() +
  theme(axis.text.x = element_text(size = 8))

ggsave(filename = '../Figuras/oos_fit_categorical.png')
