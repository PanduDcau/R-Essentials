growth=c(2.63,2.58,2.60,2.48,2.26,2.38,2.26);
seatemp=c(29.68,29.87,30.16,30.22,30.48,30.65,30.90);
boxplot(growth)
plot(seatemp,growth,xlab="Sea Tempreature(Celcius)",ylab="Milimeter Per Year",pch=16);
cor.test(seatemp,growth)
cor(seatemp,growth,method="pearson")
abline(lm(growth~seatemp))

data("cats")
ratone< data("cats")
bwt=cats[,2]
hwt<-cats[,3]
plot(x=bwt,y=hwt,col="blue", main = "Cats Weight Vs Heart Rate",xlab = "Cats Body Weight",ylab = "Cats Height",pch=16,cex=1.3)
lm(hwt~bwt,data=cats)

cor.test(bwt,hwt);
par(mfrow=c(2,2))
plot(lm(bwt~hwt,data=cats))

lm.out=lm(bwt~hwt,data=cats)
par(mfrow=c(1,1))
plot(cooks.distance(lm.out))

x0=data.frame(bwt=c(2.52))
predict.lm(lm.out,x0,interval = "prediction",cof.level=0.95)

datasets::iris
iran<-datasets::iris
sepal<-iran[,2]
sepalw<-iran[,3]
petal<-iran[,4]
petaw<-iran[,5]

