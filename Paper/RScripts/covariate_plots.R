# Cargamos los datos

source('multiplot.R')

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
log_fun <- function(x){log(1 + (as.numeric(x)))}

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
      filter(junta == '7') %>%
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

df <- rbind(hd, pilot)%>%
      mutate_at(vars(one_of(factores)), factores_fun) %>%
      mutate_at(vars(one_of(continuas)), log_fun)

plot_titles_cont <- c('Wage', 'Tenure', 'Weekly working hours', 'Severance Pay', '20 days', 'Overtime')


plot_covariates_cont <- function(var, plot_title){
  ggplot(df, aes_string(var, color = 'hd', linetype = 'hd')) +
    geom_line(stat = 'density', size = 1) +
    scale_y_continuous(labels = scales::percent_format()) +
    labs(title = plot_title, x = '', y = 'Percent') +
    guides(color = F, linetype = F) +
    theme_classic()
}

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

aux_factor <- function(x){as.numeric(as.character(x))}
aux_nas <- function(x){
x[is.na(x)] <- '0'
x
}

df %>%
  select(one_of(factores)) %>% 
  mutate_at(vars(-hd), aux_factor) %>%
  mutate_all(aux_nas) %>%
  gather(key = var, value = valor, -hd) %>% 
  group_by(hd, var, valor) %>%
  summarise(suma = n()) %>%
  ungroup() %>%
  group_by(var, hd) %>%
  mutate(freq = suma/sum(suma)) %>%
  ungroup() %>%
  mutate_at(vars(hd, valor), factores_fun) -> prop

ggplot() +
  geom_bar(data = prop,
           aes(x = var, 
               y = freq,
               fill = valor,
               group = hd), 
           stat = 'identity',
           position = 'dodge',
           color = 'black') +
  scale_x_discrete(labels = c('abogado_pub' = 'Public Lawyer',
                              'codem' = 'Co-defendant',
                              'gen' = 'Gender', 
                              'indem' = 'Severance Pay',
                              'reinst' = 'Reinstatement',
                              'sarimssinf' = 'Social Security',
                              'trabajador_base' = 'At-will worker')) +
  scale_y_continuous(labels = scales::percent_format()) +
  labs(y = 'Percent', x = 'Variable') +
  theme_classic()


