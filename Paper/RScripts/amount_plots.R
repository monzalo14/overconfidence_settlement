source('00_setup.R')

trunca99 <- function(x){
  cuantil99 <- quantile(x, .99, na.rm=T, type=1)
  x [x>cuantil99] <- cuantil99
  x
}

# Notas sobre variables en la grÃ¡fica:
# amount asked es c_total al 99%
# amount won = liqtotal al 99%
# min compensation by law = min_ley
# min compensation + fallen wages = min_ley + sueldo*duracion*365 

# Leo datasets
vars_truncadas <- c('c_total', 'liq_total')
vars <- c(vars_truncadas, 'min_ley', 'minley_salcaidos')

df <- readRDS('../DB/observaciones.RDS') %>%
  group_by(modo_termino) %>%
  mutate_each(funs(trunca99), one_of(vars_truncadas)) %>%
  mutate(minley_salcaidos = min_ley + sueldo*duracion*365)  %>%
  filter(!(modo_termino == 2 & liq_total != 0), 
         !(modo_termino == 4 & liq_total !=0)) # %>%
# mutate_each(funs(((function(x){x/1000})(.))), one_of(vars))

# Preparo los datos para tener la matriz que necesito de modos de tÃƒÂ©rmino, nombre de la variable y cantidad promedio.
df_plot <- df %>%
  select(one_of(vars), modo_termino) %>%
  gather(key = var, value = monto, -modo_termino) %>%
  filter(!is.na(modo_termino)) %>%
  group_by(modo_termino, var) %>%
  summarise(monto = mean(monto, na.rm = T)) %>%
  spread(key = modo_termino, value = monto) 

varnames <- df_plot$var

df_plot <- df_plot %>%
  select(-var) %>%
  as.matrix(.)

# Poner nombres bonitos a la matriz que vamos a graficar
rownames(df_plot) <- c('Amount asked', 'Amount won', 'Min. comp. by law', 'Min. comp. + lost wages')
colnames(df_plot) <- c('Conciliation', 'Drop', 'Court ruling', 'Expiry')
ylim <- range(df_plot)*c(1,1.25)

# Generamos los porcentajes que necesitamos de cada modo de término:
prop_mt <- df %>% count(modo_termino) %>% 
  mutate(n = n*100 / nrow(df)) %>%
  filter(!is.na(modo_termino))

prop_mt_leg <- paste0(colnames(df_plot), ' - ',
                      substr(as.character(prop_mt$n), 1, 5), '%')

# Defino las gráficas y les pongo legends

par(mar = c(6.1, 5.1, 2.1, 3.1))
barplot(df_plot, 
        beside = T, 
        ylim = ylim, 
        col = 1, 
        lwd = 1:2, 
        angle = c(0, 45, 90, 45), 
        density = c(0, 20, 20, 30), 
        cex.names = 0.7, 
        cex.axis = 0.7)
barplot(df_plot, 
        add = TRUE, 
        beside = TRUE, 
        ylim = ylim, 
        col = 1, 
        lwd = 1:2, 
        angle = c(0, 45, 90, 135), 
        density = c(0, 20, 20, 30), 
        ylab = 'Amounts (in thousands of pesos)',
        cex.lab = 0.8,
        cex.names = 0.7, 
        cex.axis = 0.7) -> ex

legend('top', legend = rownames(df_plot),
       ncol = 2, fill = TRUE, cex = 0.6, col = 1,
       angle = c(0, 45, 90, 135),
       density = c(0, 30, 35, 60),
       inset = c(0.1, -0.2))
legend('bottom', legend = prop_mt_leg, 
       ncol = 2, cex = 0.55, 
       inset = c(0, -0.6))

