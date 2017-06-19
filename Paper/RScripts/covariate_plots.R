# Cargamos los datos

source('multiplot.R')

pilot <- read.csv('../DB/calculadora.csv') %>%
        dplyr::select(sueldo = salariodiariointegrado, 
               gen = gen,
               c_antiguedad = antigedad,
               codem = codemandaimssinfo,
               horas_sem = horas,
               reinst = reinstalaciont,
               indem = indemconsttdummy,
               c_indem = indemcdinero,
               c_rec20 = c_veintedias,
               c_hextra = c_horasextras,
               trabajador_base = trabbase,
               sarimssinf = sarimssinfo,
               abogado_pub = tipodeabogadocalc) %>%
        mutate(hd = 0)

hd <- readRDS('../DB/observaciones.RDS') %>%
      dplyr::select(sueldo,
             gen,
             c_antiguedad,
             codem, 
             horas_sem,
             reinst,
             indem,
             c_indem,
             c_rec20,
             c_hextra,
             trabajador_base,
             sarimssinf, 
             abogado_pub) %>%
      mutate(hd = 1)

factores <- c('gen',
              'codem',
              'reinst',
              'indem',
              'trabajador_base',
              'sarimssinf',
              'abogado_pub', 
              'hd')

continuas <- names(pilot)[!(names(pilot) %in% factores)]

factores_fun <- function(x){as.factor(as.character(x))}

df <- rbind(pilot, hd) %>%
        mutate_at(vars(one_of(factores)), factores_fun)


plot_covariates_cont <- function(var, plot_title){
  ggplot(df) +
    geom_density(aes_string(x = var, color = 'hd', group = 'hd'), size = 1) +
    labs(title = plot_title, x = '') +
    theme_bw()
}

plot_titles_cont <- c('Wage', 'Tenure', 'Weekly working hours', 'Severance Pay', '20 days', 'Overtime')

# plots_cont <- list()

#for(i in seq(continuas)){
 # p <- plot_covariates_cont(data, continuas[i], plot_titles_cont[i])
  #plots_cont <- append(plots_cont, p)
#}

p1 <- plot_covariates_cont(continuas[1], plot_titles_cont[1])
p2 <- plot_covariates_cont(continuas[2], plot_titles_cont[2])
p3 <- plot_covariates_cont(continuas[3], plot_titles_cont[3])
p4 <- plot_covariates_cont(continuas[4], plot_titles_cont[4])
p5 <- plot_covariates_cont(continuas[5], plot_titles_cont[5])
p6 <- plot_covariates_cont(continuas[6], plot_titles_cont[6])


multiplot(p1, p2, p3, p4, p5, p6, cols = 2)

# ggsave('../Figuras/covariates_continous.png')

###################

# Categóricas

##################


plot_covariates_cat <- function(var, plot_title){
  ggplot(na.omit(df)) +
    geom_bar(aes_string(x = var, color = 'hd', group = 'hd', fill = 'hd'), size = 1) +
    labs(title = plot_title, x = '') +
    theme_bw()
}

factores <- factores[1:7]

plot_titles_cat <- c('Gender', 
                     'Suing third party', 
                     'Reinstatement',
                     'Severance pay',
                     'At-will worker',
                     'Social Security Benefits',
                     'Public lawyer')

c1 <- plot_covariates_cat(factores[1], plot_titles_cat[1])
c2 <- plot_covariates_cat(factores[2], plot_titles_cat[2])
c3 <- plot_covariates_cat(factores[3], plot_titles_cat[3])
c4 <- plot_covariates_cat(factores[4], plot_titles_cat[4])
c5 <- plot_covariates_cat(factores[5], plot_titles_cat[5])
c6 <- plot_covariates_cat(factores[6], plot_titles_cat[6])
c7 <- plot_covariates_cat(factores[7], plot_titles_cat[7])

multiplot(c1, c2, c3, c4, c5, c6, c7, cols = 2)
