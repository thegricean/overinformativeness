setwd("/Users/titlis/cogsci/conferences_talks/_2016/3_aberdeen/graphs")
library(latex2exp)

states = data.frame(State=c(0,1,2),Probability=c(1/3,1/3,1/3))
ggplot(states, aes(x=State,y=Probability)) +
  geom_bar(stat="identity") +
  xlab("Meaning")
ggsave("uniform_prior.pdf",height=3,width=3)

literal = data.frame(State=rep(c(0,1,2),4),Message=rep(c("green","black","big","small"),each=3),Probability=c(.5,.5,0,0,0,1,0,1,0,.5,0,.5),Label=c("0","1","2"))

ggplot(literal, aes(x=State,y=Probability)) +
  #geom_rect(aes(xmin=-Inf,xmax=0.5,ymin=0,ymax=Inf),fill="yellow",alpha=.1) +  
  #geom_rect(aes(xmin=0.5,xmax=3.5,ymin=0,ymax=Inf),fill="green",alpha=.1) +    
  #geom_rect(aes(xmin=3.5,xmax=Inf,ymin=0,ymax=Inf),fill="orange",alpha=.1) +    
  geom_bar(stat="identity") +
#  facet_wrap(~Message) +
  #scale_y_continuous(limits=c(0,0.35)) +
  scale_x_continuous(name="Object") + #,labels=c(TeX("$\\neg \\exists}$"),"",TeX("$\\exists  \\neg \\forall}$"),"",TeX('$\\forall$'))) +
  #geom_text(aes(label=Label,y=0.34),size=3) 
  facet_wrap(~Message)
ggsave("lit_listener.pdf",height=3.5,width=4)


literal_noisy = data.frame(State=rep(c(0,1,2),2),Message=rep(c("big","black"),each=3),Probability=c(1/3,2/3,1/3,.001,.001,.998),Label=c("0","1","2"))

ggplot(literal_noisy, aes(x=State,y=Probability)) +
  #geom_rect(aes(xmin=-Inf,xmax=0.5,ymin=0,ymax=Inf),fill="yellow",alpha=.1) +  
  #geom_rect(aes(xmin=0.5,xmax=3.5,ymin=0,ymax=Inf),fill="green",alpha=.1) +    
  #geom_rect(aes(xmin=3.5,xmax=Inf,ymin=0,ymax=Inf),fill="orange",alpha=.1) +    
  geom_bar(stat="identity") +
  #  facet_wrap(~Message) +
  #scale_y_continuous(limits=c(0,0.35)) +
  scale_x_continuous(name="Object",breaks=c(0,1,2),labels=c("i","i","i")) + #,labels=c(TeX("$\\neg \\exists}$"),"",TeX("$\\exists  \\neg \\forall}$"),"",TeX('$\\forall$'))) +
  #geom_text(aes(label=Label,y=0.34),size=3) 
  facet_wrap(~Message)
ggsave("lit_listener_noisy.pdf",height=2.2,width=3)

literalcomplex = data.frame(State=rep(c(0,1,2),7),Message=rep(c("green","black","big","small","big green","small green","small black"),each=3),Probability=c(.5,.5,0,0,0,1,0,1,0,.5,0,.5,0,1,0,1,0,0,0,0,1),Label=c("0","1","2"))

ggplot(literalcomplex[literalcomplex$Message %in% c("big","big green","green"),], aes(x=State,y=Probability)) +
  #geom_rect(aes(xmin=-Inf,xmax=0.5,ymin=0,ymax=Inf),fill="yellow",alpha=.1) +  
  #geom_rect(aes(xmin=0.5,xmax=3.5,ymin=0,ymax=Inf),fill="green",alpha=.1) +    
  #geom_rect(aes(xmin=3.5,xmax=Inf,ymin=0,ymax=Inf),fill="orange",alpha=.1) +    
  geom_bar(stat="identity") +
  #  facet_wrap(~Message) +
  #scale_y_continuous(limits=c(0,0.35)) +
  scale_x_continuous(name="Object",breaks=c(0,1,2),labels=c("i","i","i")) + #,labels=c(TeX("$\\neg \\exists}$"),"",TeX("$\\exists  \\neg \\forall}$"),"",TeX('$\\forall$'))) +
  #geom_text(aes(label=Label,y=0.34),size=3) 
  facet_wrap(~Message)
ggsave("lit_listener_complex.pdf",height=2.2,width=3.5)



# plot lambda effect
softmax <- function(x,lambda) 
{
  return(exp(lambda*log(x))/sum(exp(lambda*log(x))))
}

speaker = data.frame(Utterance=c("big","black","green","small"),Probability=c(2/3,0,1/3,0))

ggplot(speaker, aes(x=Utterance,y=Probability)) +
  geom_bar(stat="identity")
ggsave("speaker.pdf",height=2,width=2.5)


# plot the baked in color typicality results:
d = data.frame(BananaColor=c("blue","brown","yellow"),Typicality=c(.1,.35,.9),Probability=c(.90,.35,.18))
ggplot(d, aes(x=Typicality,y=Probability,color=BananaColor)) +
  geom_point(size=4) +#stat="identity",color="black") +
#  geom_text(aes(label=Typicality)) +
  ylim(0,1) +
  xlim(0,1) +
  scale_color_manual(values=c("blue","orange4","gold"))
ggsave("bananas.pdf",height=2.5,width=5)

