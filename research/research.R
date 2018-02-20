tmp <- df_bse_pyramid %>% filter(barrio=="Mendillorri" & year==2015)

ggplot(tmp, aes(x = age_category, y = n, fill = sex)) + 
  geom_bar(data=subset(tmp,sex=="H"), stat="identity",aes(x = age_category, y = n)) + 
  geom_bar(data=subset(tmp,sex=="M"), stat="identity", aes(x = age_category,y = n * -1)) + 

  coord_flip() + 
  scale_fill_brewer(palette = "Set1") + 
  theme_bw() +
  labs(x="", y="Numero de personas")



##########33

tmp1 <- tmp %>% filter(sex=="H") %>% arrange(age_category)

tmp2 <- tmp %>% filter(sex=="M") %>% arrange(age_category)

ggplot() + 
  geom_bar(data=tmp1, stat="identity",aes(x = age_category, y = n)) + 
  geom_bar(data=tmp2, stat="identity", aes(x = age_category,y = n * -1)) + 
  
  coord_flip() + 
  scale_fill_brewer(palette = "Set1") + 
  theme_bw() +
  labs(x="", y="Numero de personas")

####

ggplot(tmp1, aes(x=age_category, y=n)) +
  geom_bar(stat="identity") + coord_flip()



####

tmp3 <- tmp %>% arrange(age_category, sex)

ggplot(tmp3, aes(x = age_category, y = n, fill = sex)) + 
  geom_bar(data=subset(tmp3,sex=="H"), stat="identity",aes(x = age_category, y = n)) + 
  geom_bar(data=subset(tmp3,sex=="M"), stat="identity", aes(x = age_category,y = n * -1)) + 
  
  coord_flip() + 
  scale_fill_brewer(palette = "Set1") + 
  theme_bw() +
  labs(x="", y="Numero de personas")



####

lims = max(tmp3$n)
ggplot(data=tmp3) +
  geom_bar(aes(age_category,n,group=sex,fill=sex), stat = "identity",subset(tmp3,tmp3$sex=="M")) +
  geom_bar(aes(age_category,-n,group=sex,fill=sex), stat = "identity",subset(tmp3,tmp3$sex=="H")) +
  coord_flip()