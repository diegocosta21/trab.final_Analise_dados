library(dplyr)
library(readxl)

library(ggplot2)
library(ggthemr)
library(kableExtra)
library(ggrepel)
library(scales)

library(sf)
library(tmap)
library(rgdal)
library(raster)

library(sjPlot)
library(sjmisc)
library(sjlabelled)

library(jtools)

base<-read_excel("Dados_Homicidios_Armas.xlsx")

# Tabela com todos os dados -----------------------------------------------
base%>% 
  kbl(col.names = c("Código UF","UF","Região","Taxa de homicídio (2019)",
                    "Taxa de apreensão de armas (2019)", "IDH (2017)"),
      align=rep('c', 6),
      digits = c(2,2,3))%>%
  kable_styling(latex_options = "hold_position", position = "center")%>%
  kable_minimal()

ggthemr("flat")
# Taxa de homicípio por uf ------------------------------------------------
ggplot(base, aes(x=reorder(UF,Tx_homic_2019),Tx_homic_2019, fill=Tx_homic_2019))+
  geom_col()+
  geom_hline(yintercept = mean(base$Tx_homic_2019), color="red", size=1)+
  geom_text(aes(label = format(Tx_homic_2019, digits=3)), 
            vjust = .3, hjust = -0.1, size = 5,
            position = position_dodge(width = 1),
            color="black")+
  labs(title="Taxa de homicídio por UF (100 mil hab.)",
       x="",y="", fill="", colour="")+
  coord_flip()+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# Taxa de homicípio por região ------------------------------------------------
base%>%
  group_by(Região)%>%
  summarise(media=mean(Tx_homic_2019))%>%
  ggplot(aes(x=reorder(Região,-media),media, fill=media))+
  geom_col()+
  geom_hline(yintercept = mean(base$Tx_homic_2019), color="red", size=1)+
  geom_text(aes(label = format(media, digits=3)), 
            vjust = -.5, hjust = .6, size = 6,
            position = position_dodge(width = 1),
            color="black")+
  labs(title="Taxa de homicídio por região (100 mil hab.)", 
       x="",y="", fill="", colour="")+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# Apreensão de arma por uf ------------------------------------------------
ggplot(base, aes(x=reorder(UF,Tx_Apr_arm_2019),Tx_Apr_arm_2019, fill=Tx_Apr_arm_2019))+
  geom_col()+
  geom_hline(yintercept = mean(base$Tx_Apr_arm_2019), color="red", size=1)+
  geom_text(aes(label = format(Tx_Apr_arm_2019, digits=3)), 
            vjust = .3, hjust = -0.1, size = 5,
            position = position_dodge(width = 1),
            color="black")+
  labs(title="Taxa de apreensão de arma por UF (100 mil hab.)", 
       x="",y="", fill="", colour="")+
  coord_flip()+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold", hjust = .5),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# Apreensão de arma por região ------------------------------------------------
base%>%
  group_by(Região)%>%
  summarise(media=mean(Tx_Apr_arm_2019))%>%
  ggplot(aes(x=reorder(Região,-media),media, fill=media))+
  geom_col()+
  geom_hline(yintercept = mean(base$Tx_Apr_arm_2019), color="red", size=1)+
  geom_text(aes(label = format(media, digits=3)), 
            vjust = -.5, hjust = .6, size = 6,
            position = position_dodge(width = 1),
            color="black")+
  labs(title="Taxa de apreensão de arma por região (100 mil hab.)", 
       x="",y="", fill="", colour="")+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# -------------------------------------------------------------------------
ggthemr("fresh")

# IDH por uf ------------------------------------------------
ggplot(base, aes(x=reorder(UF,IDH_2017),IDH_2017, fill=IDH_2017))+
  geom_col()+
  geom_hline(yintercept = mean(base$IDH_2017), color="red", size=1)+
  geom_text(aes(label = format(IDH_2017, digits=3)), 
            vjust = .3, hjust = -0.1, size = 5,
            position = position_dodge(width = 1),
            color="black")+
  labs(title="IDH por UF",
       x="",y="", fill="", colour="")+
  coord_flip()+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# IDH por região ------------------------------------------------
base%>%
  group_by(Região)%>%
  summarise(media=mean(IDH_2017))%>%
  ggplot(aes(x=reorder(Região,-media),media, fill=media))+
  geom_col()+
  geom_hline(yintercept = mean(base$IDH_2017), color="red", size=1)+
  geom_text(aes(label = format(media, digits=3)), 
            vjust = -.5, hjust = .6, size = 6,
            position = position_dodge(width = 1),
            color="black")+
  labs(title="IDH por região", 
       x="",y="", fill="", colour="")+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")


# Correlação homicidio x arma ---------------------------------------------

ggplot(base, aes(Tx_Apr_arm_2019, Tx_homic_2019, label=UF))+
  geom_point(size=2)+
  geom_vline(xintercept = mean(base$Tx_Apr_arm_2019), color="red", size=1)+
  geom_hline(yintercept = mean(base$Tx_homic_2019), color="red", size=1)+
  geom_label_repel()+
  labs(title="Associação entre homicídios e apreensão de armas", 
       x="Taxa de apreensão de armas",y="Taxa de homicídio", fill="", colour="")+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        axis.title = element_text(size = 13, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# Correlação homicidio x idh ---------------------------------------------
ggplot(base, aes(IDH_2017, Tx_homic_2019, label=UF))+
  geom_point(size=2)+
  geom_vline(xintercept = mean(base$IDH_2017), color="red", size=1)+
  geom_hline(yintercept = mean(base$Tx_homic_2019), color="red", size=1)+
  geom_label_repel()+
  labs(title="Associação entre homicídios e IDH", 
       x="IDH",y="Taxa de homicídio", fill="", colour="")+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        axis.title = element_text(size = 13, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# Correlação arma x idh ---------------------------------------------
ggplot(base, aes(IDH_2017, Tx_Apr_arm_2019, label=UF))+
  geom_point(size=2)+
  geom_vline(xintercept = mean(base$IDH_2017), color="red", size=1)+
  geom_hline(yintercept = mean(base$Tx_Apr_arm_2019), color="red", size=1)+
  geom_label_repel()+
  labs(title="Associação entre IDH e apreensão de armas", 
       x="IDH",y="Taxa de apreensão de armas", fill="", colour="")+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        axis.title = element_text(size = 13, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")


# Diferença percentual homicidios -----------------------------------------
base2<-read_excel("Dados_Homicidios_Armas.xlsx", sheet = 2)
base2$dif<-(base2$Tx_homic_2019-base2$Tx_homic_2009)/base2$Tx_homic_2009

ggplot(base2, aes(x=reorder(UF,dif),dif, fill=dif))+
  geom_col()+
  scale_y_continuous(labels = percent)+
  geom_text(aes(label = paste0(format(dif*100, digits=1),"%")), 
            vjust = .3, hjust = 0, size = 5,
            position = position_dodge(width = 1),
            color=ifelse(base2$dif>0,"black","white"))+
  labs(title="Redução percentual da taxa de mortalidade por UF (2019-2009)",
       x="",y="", fill="", colour="")+
  coord_flip()+
  theme_bw()+
  theme(title = element_text(size = 16, colour = "black", face="bold"),
        axis.text = element_text(size = 16, colour = "black"),
        legend.text = element_text(size=13, color = "black"),
        strip.text = element_text(size = 12),
        legend.position = "none")

# Mapas -------------------------------------------------------------------

br_shape <- st_read("UFEBRASIL.shp", stringsAsFactors = F)

br_shape_dados<-merge(br_shape, base, 
                      by.x="CD_GEOCODU", by.y="Cod_UF")
tmap_mode("view")
tm_basemap("OpenStreetMap")+ 
  tm_shape(br_shape_dados)+
  tm_polygons(c("Tx_homic_2019","Tx_Apr_arm_2019","IDH_2017"),
              id="NM_ESTADO", 
              style = "hclust", 
              n=4, 
              palette=list("Reds","Oranges","Blues"), 
              border.col = 1,
              title=c("Taxa de homicídio","Taxa de apreensão de armas","IDH"))+
  tm_view(view.legend.position = c("right", "bottom"))+
  tm_facets(as.layers = TRUE)+
  tm_layout(legend.title.size=1,
            legend.text.size = .9)


# Modelo ------------------------------------------------------------------
# Para mais informações, ver: https://cran.r-project.org/web/packages/jtools/vignettes/summ.html

model<-lm(formula=Tx_homic_2019 ~ Tx_Apr_arm_2019 + IDH_2017,
          data=base)

tab_model(model)

summ(model, center = TRUE)

# Coeficientes padronizados
summ(model, scale = TRUE)

# Intervalos de confiança
summ(model, confint = TRUE)

# Gráfico de efeito
effect_plot(model, pred = Tx_Apr_arm_2019, interval = TRUE, plot.points = TRUE)

# Gráfico de coeficientes
plot_summs(model)

# Resíduos
par(mfrow = c(2, 3))
plot(model,1)
plot(model,2)
plot(model,3)
plot(model,4)
plot(model,5)
plot(model,6)