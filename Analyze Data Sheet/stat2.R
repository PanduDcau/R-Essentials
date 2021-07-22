library(datasets)
str(iris)

panel.cor<-function(x,y)
{
  usr<-par("usr");
  on.exit(par(usr))
  par(usr=c(0,1,0,1))
  
  r<-round(cor(x,y),digits = 2)
  txt<-paste0("R =",r)
  cex.cor<-0.8/strwidth(txt)
  text(0.5,0.5,txt,cex=cex.cor*r)
}

upper.panel<-function(x,y)
{
  points(x,y,pch=19,col=c("blue","green","red"))[iris$Species]
  r<-round(cor(x,y),digits = 2)
  txt<-paste0("R= ",r)
  usr<-par("usr");
  on.exit(par(usr))
  par(usr=c(0,1,0,1))
  text(0.5,0.9,txt)
}

pairs(iris[,1:4],lower.panel = panel.cor,upper.panel = upper.panel)

