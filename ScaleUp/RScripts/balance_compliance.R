library(dplyr)
library(tidyr)
library(stargazer)
library(stringr)
library(broom)

df = readRDS('../DB/scaleup_casefiles.RDS') %>%
      select(-num_actores, -observaciones)

df_seg = read.csv('../DB/scaleup_operation.csv') %>%
        setNames(nm = recode(names(.), 'a.o' = 'anio',
                             'expediente' = 'exp')) %>%
        mutate(p_actor = as.numeric(as.character(p_actor)))

## Take up table

format_strings = function(x){
  num = format(round(x*100, 2), digits = 2, nsmall = 2)
  ifelse(x == 0, '-', num)
}

take_up = df_seg %>% 
          mutate(t_Group = recode(tratamiento, `1` = 'Treatment', `0` = 'Control')) %>%
          filter(!(tratamiento == 0 & dummy_calculadora_partes == 1),
                 !(tratamiento == 0 & dummy_registro_partes == 1)) %>%
          group_by(t_Group) %>%
          summarise(t_Assignment = n(),
                    t_Plaintiff = sum(calcu_p_actora)/n(),
                    t_Defendant = sum(calcu_p_dem)/n(),
                    t_Both = sum(calcu_p_actora*calcu_p_dem)/n(),
                    s_Plaintiff = sum(registro_p_actora)/n(),
                    s_Defendant = sum(registro_p_dem2)/n(),
                    s_Both = sum(registro_p_actora*registro_p_dem2)/n()) %>%
          mutate_at(vars(-t_Group, -t_Assignment), format_strings) %>%
          setNames(nm = str_sub(names(.), start = 3L))

stargazer(take_up, out = '../../Paper/Tables/Compliance_2.tex', header = F, summary = F, digits = 2, rownames = F)

## Balance table

format_strings_balance = function(x){
  format(round(x, 2), digits = 2, nsmall = 2)
}

covariates = c('gen', 
               'trabajador_base', 
               'horas_sem', 
               'abogado_pub', 
               'codem', 
               'reinst',
               'indem', 
               'rec20',
               'sal_caidos',
               'hextra',
               'sarimssinf',
               'antig',
               'p_actor',
               'p_ractor',
               'p_dem', 
               'p_rdem')

balance_conditioning = df %>% 
          right_join(df_seg) %>%
          filter((tratamiento == 1 & calculadoras_partes > 0) | tratamiento == 0) %>%
          select(tratamiento, one_of(covariates)) %>%
          gather(var, valor, -tratamiento) %>% 
          group_by(var) %>%
          do(tidy(t.test(valor ~ tratamiento, data = .))) %>%
          select(var, estimate1, estimate2, p.value) %>%
          setNames(nm = c('Variable', 'Control', 'Treatment (conditional)', 'P-value (conditional)')) %>%
          ungroup() %>%
          mutate(Variable = recode(Variable, 'gen' = 'Woman',
                                    'trabajador_base' = 'At-Will Worker',
                                    'horas_sem' = 'Weekly Hours',
                                    'abogado_pub' = 'Public Lawyer',
                                    'codem' = 'Co-defendant',
                                    'reinst' = 'Reinstatement',
                                    'indem' = 'Severance Pay',
                                    'rec20' = '20 Days',
                                    'sal_caidos' = 'Lost Wages',
                                    'hextra' = 'Overtime',
                                    'sarimssinf' = 'Social Security',
                                    'antig' = 'Tenure',
                                    'p_actor' = 'Employee present',
                                    'p_dem' = 'Firm present',
                                    'p_ractor' = 'Employee Lawyer present',
                                    'p_rdem' = 'Firm Lawyer present')) %>%
          mutate_at(vars(-Variable), format_strings_balance)

balance_overall = df %>% 
  right_join(df_seg) %>%
  select(tratamiento, one_of(covariates)) %>%
  gather(var, valor, -tratamiento) %>% 
  group_by(var) %>%
  do(tidy(t.test(valor ~ tratamiento, data = .))) %>%
  select(var, estimate1, estimate2, p.value) %>% 
  setNames(nm = c('Variable', 'Control', 'Treatment', 'P-value')) %>%
  ungroup() %>%
  mutate(Variable = recode(Variable, 'gen' = 'Woman',
                           'trabajador_base' = 'At-Will Worker',
                           'horas_sem' = 'Weekly Hours',
                           'abogado_pub' = 'Public Lawyer',
                           'codem' = 'Co-defendant',
                           'reinst' = 'Reinstatement',
                           'indem' = 'Severance Pay',
                           'rec20' = '20 Days',
                           'sal_caidos' = 'Lost Wages',
                           'hextra' = 'Overtime',
                           'sarimssinf' = 'Social Security',
                           'antig' = 'Tenure',
                           'p_actor' = 'Employee present',
                           'p_dem' = 'Firm present',
                           'p_ractor' = 'Employee Lawyer present',
                           'p_rdem' = 'Firm Lawyer present')) %>%
  mutate_at(vars(-Variable), format_strings_balance)

balance = left_join(balance_overall, balance_conditioning)

stargazer(balance, out = '../../Paper/Tables/balance_2.tex', header = F, summary = F, digits = 2, rownames = F)
