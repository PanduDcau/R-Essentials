super<-function(a)

  {
  c<-runif(a,min=10,max=20)
  
if(a>5)
{
  summary(c)
}
  else
  {
    print("Length is below than 5")
  }
  
}

