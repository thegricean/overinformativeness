reshapeData <- function(d)
{
  d$Trial1 = paste(d$Utterance0,d$TargetColor0,d$OtherColor0,d$Slider00,d$Slider10, d$Slider20,d$Slider30,d$Slider40,d$Slider50,d$Slider60,d$Slider70, d$Slider80,d$Slider90,d$Slider100)
  d$Trial2 = paste(d$Utterance1,d$TargetColor1,d$OtherColor1,d$Slider01,d$Slider11, d$Slider21,d$Slider31,d$Slider41,d$Slider51,d$Slider61,d$Slider71, d$Slider81,d$Slider91,d$Slider101)  
  d$Trial3 = paste(d$Utterance2,d$TargetColor2,d$OtherColor2,d$Slider02,d$Slider12, d$Slider22,d$Slider32,d$Slider42,d$Slider52,d$Slider62,d$Slider72, d$Slider82,d$Slider92,d$Slider102)
  d$Trial4 = paste(d$Utterance3,d$TargetColor3,d$OtherColor3,d$Slider03,d$Slider13, d$Slider23,d$Slider33,d$Slider43,d$Slider53,d$Slider63,d$Slider73, d$Slider83,d$Slider93,d$Slider103)  
  d$Trial5 = paste(d$Utterance4,d$TargetColor4,d$OtherColor4,d$Slider04,d$Slider14, d$Slider24,d$Slider34,d$Slider44,d$Slider54,d$Slider64,d$Slider74, d$Slider84,d$Slider94,d$Slider104)
  d$Trial6 = paste(d$Utterance5,d$TargetColor5,d$OtherColor5,d$Slider05,d$Slider15, d$Slider25,d$Slider35,d$Slider45,d$Slider55,d$Slider65,d$Slider75, d$Slider85,d$Slider95,d$Slider105)  
  d$Trial7 = paste(d$Utterance6,d$TargetColor6,d$OtherColor6,d$Slider06,d$Slider16, d$Slider26,d$Slider36,d$Slider46,d$Slider56,d$Slider66,d$Slider76, d$Slider86,d$Slider96,d$Slider106)
  d$Trial8 = paste(d$Utterance7,d$TargetColor7,d$OtherColor7,d$Slider07,d$Slider17, d$Slider27,d$Slider37,d$Slider47,d$Slider57,d$Slider67,d$Slider77, d$Slider87,d$Slider97,d$Slider107)   
  d$Trial9 = paste(d$Utterance8,d$TargetColor8,d$OtherColor8,d$Slider08,d$Slider18, d$Slider28,d$Slider38,d$Slider48,d$Slider58,d$Slider68,d$Slider78, d$Slider88,d$Slider98,d$Slider108)  
  d$Trial10 = paste(d$Utterance9,d$TargetColor9,d$OtherColor9,d$Slider09,d$Slider19, d$Slider29,d$Slider39,d$Slider49,d$Slider59,d$Slider69,d$Slider79, d$Slider89,d$Slider99,d$Slider109)
  d$Trial11 = paste(d$Utterance10,d$TargetColor10,d$OtherColor10,d$Slider010,d$Slider110, d$Slider210,d$Slider310,d$Slider410,d$Slider510,d$Slider610,d$Slider710, d$Slider810,d$Slider910,d$Slider1010)  
  
  return(d) 
} 

getGender <- function(dd) {
  genders = data.frame(Name = c("Alex", "Ben", "Calvin", "Dan", "Ted", "Max","Ann", "Liz", "Diane","Amy", "Marie", "Jane"), Gender = c(rep("male",6),rep("female",6)))
  row.names(genders) = genders$Name
  for (i in seq(0, 23)) {
    dd[,paste("Gender",i,sep="")] = genders[as.character(dd[,paste("Speaker",i,sep="")]),]$Gender
  }
  return(dd)
}

getQUD <- function(qud) {
  #print(qud)
  if (length(grep("How many", qud)) > 0) {
    return("HowMany?")
  } else {
    if (length(grep("all", qud)) > 0) {
      return("All?")
    } else {
      if (length(grep("Are any", qud)) > 0) {
        return("Any?")
      } else {
        return("ERROR!")
      }
    }
  }
}

myCenter <- function(x) {
  if (is.numeric(x)) { return(x - mean(x)) }
  if (is.factor(x)) {
    x <- as.numeric(x)
    return(x - mean(x))
  }
  if (is.data.frame(x) || is.matrix(x)) {
    m <- matrix(nrow=nrow(x), ncol=ncol(x))
    colnames(m) <- paste("c", colnames(x), sep="")
    for (i in 1:ncol(x)) {
      if (is.factor(x[,i])) {
        y <- as.numeric(x[,i])
        m[,i] <- y - mean(y, na.rm=T)
      }
      if (is.numeric(x[,i])) {
        m[,i] <- x[,i] - mean(x[,i], na.rm=T)
      }
    }
    return(as.data.frame(m))
  }
}

se <- function(x)
{
  y <- x[!is.na(x)] # remove the missing values, if any
  sqrt(var(as.vector(y))/length(y))
}

zscore <- function(x){
  ## Returns z-scored values
  x.mean <- mean(x)
  x.sd <- sd(x)
  
  x.z <- (x-x.mean)/x.sd
  
  return(x.z)
}

zscoreByGroup <- function(x, groups){ 
  #Compute zscores within groups
  out <- rep(NA, length(x))
  
  for(i in unique(groups)){
    out[groups == i] <- zscore(x[groups == i])
  }
  return(out)
}

## for bootstrapping 95% confidence intervals
library(bootstrap)
theta <- function(x,xdata,na.rm=T) {mean(xdata[x],na.rm=na.rm)}
ci.low <- function(x,na.rm=T) {
  mean(x,na.rm=na.rm) - quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.025,na.rm=na.rm)}
ci.high <- function(x,na.rm=T) {
  quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.975,na.rm=na.rm) - mean(x,na.rm=na.rm)}