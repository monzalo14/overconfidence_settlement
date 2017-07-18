library(readxl)
library(dplyr)
library(data.table)

## Leemos los datos nuevos

to_keep = c('fecha', 
            'tratamiento', 
            'nombre_trabajador', 
            'fecha_despido', 
            'giro', 
            'prob_ganar', 
            'cantidad_ganar',
            'salario',
            'per_salario')

tratamientos_1 = read_excel('../Raw/captacion_tratamientos_1.xlsx', sheet = 'BaseControl', skip = 3) %>%
                select(one_of(to_keep))

tratamientos_23_actores = read_excel('../Raw/base_modulo_informacion.xlsx', sheet = 'T_ACTORES')
tratamientos_23_main = read_excel('../Raw/base_modulo_informacion.xlsx', sheet = 'T_MAIN')

tratamientos_23 = left_join(tratamientos_23_actores, tratamientos_23_main)

rm(tratamientos_23_actores, tratamientos_23_main)

## Modificamos los nombres de tratamientos 1 para poder hacer el join

diccionario = read_excel('../Raw/diccionario.xlsx') %>%
              select(-definicion) %>%
              na.omit()

setnames(tratamientos_1, old = diccionario$nombre_1, new = diccionario$nombre_2) 

## Creamos salario diario para cada dataset

tratamientos_1 = tratamientos_1 %>%
                  mutate(sueldo_per = recode(as.character(sueldo_per),
                                             '1' = '1', '2' = '7', '3' = '15', '4' = '30'),
                         sueldo_per = as.numeric(sueldo_per),
                         salario_diario = sueldo/sueldo_per)

tratamientos_23 = tratamientos_23 %>%
                  mutate(sueldo_per = recode(as.character(sueldo_per),
                                             'Diario' = '1', 'Semanal' = '7',
                                             'Quincenal' = '15', 'Mensual' = '30'),
                         sueldo_per = as.numeric(sueldo_per),
                         salario_diario = sueldo/sueldo_per,
                         grupo_tratamiento = as.character(grupo_tratamiento)) 

df = bind_rows(tratamientos_1, tratamientos_23) %>%
    filter(!is.na(nombre_actor)) %>%
    mutate(prob_ganar = replace(prob_ganar, prob_ganar == 0, NA),
           cantidad_ganar = replace(cantidad_ganar, cantidad_ganar == 0, NA)) 

write.csv(df, '../DB/treatment_data.csv', na = '', row.names = F)
