DC<-read.csv("dc_2010_2020.csv")
DCAU<-DC %>% group_by(Gender,Identity) %>% summarise(number = n()) %>% arrange(-number)

DU<-DCAU %>% group_by(Identity) %>% mutate(countT= sum(number)) %>% group_by(Gender) %>% mutate(percentage=100*number/countT)
DU$LABEL <-paste0(round(DU$percentage,2))

g1<-ggplot(data=DU,aes(x=Gender,y=percentage,fill=Identity)) + geom_bar(width = 0.9, stat="identity",position='dodge') + 
  theme(axis.text.x = element_text(angle=90, hjust=1),legend.position='none') + 
  geom_text(aes(label=LABEL), position=position_dodge(width=0.9), vjust=-0.25,size=2.5) + 
  scale_fill_manual(values = c("olivedrab","steelblue","red","yellow","green","black","orange")) + 
  xlab('') + ylab('Percentage')

g2<-ggplot(pieC,aes(x="",y=sum,fill=Identity)) + geom_bar(stat='identity',width = 1) + 
  coord_polar(theta="y") + theme_void() + theme(axis.text.x=element_blank(),legend.position='bottom') + 
  scale_fill_manual(values = c("olivedrab","steelblue","red","yellow","green","black","orange")) + 
  geom_text(aes(y =c(20000,8000), label = paste(pieC$Gender,": ",pieC$sum)))


listDC<-as.data.frame(DC %>%  select(Alignment,Gender) %>% na.omit() %>% 
group_by(Alignment) %>% summarise(number= n()) %>% arrange(-number) %>% mutate(countT= sum(number)) %>% mutate(percentage_dc=round(100*number/countT,1)) %>% select(Alignment,percentage_dc,number))
