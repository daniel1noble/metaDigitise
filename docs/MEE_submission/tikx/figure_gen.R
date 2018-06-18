

png("/Users/jpick/Dropbox/0_postdoc/10_metaDigitise/docs/MEE_submission/tikx/figure.png")
set.seed(25)
plot(runif(10,1,10),runif(10,1,10), pch=c(17,19),col=c(1,2),cex=2, xlab="seed size", ylab="seed number", xlim=c(1,10), ylim=c(1,10), cex.axis=1.5)
dev.off()

png("/Users/jpick/Dropbox/0_postdoc/10_metaDigitise/docs/MEE_submission/tikx/figure2.png")
set.seed(25)
boxplot(c(rnorm(60,1,1),rnorm(60,0,1))~gl(3,40))
dev.off()

library(digitize)

digitize("~/Dropbox/0_postdoc/10_metaDigitise/docs/MEE_submission/tikx/figure.png")


digitize("~/Dropbox/0_postdoc/10_metaDigitise/docs/MEE_submission/tikx/figure2.png")



#install.packages("devtools")
devtools::install_github("daniel1noble/metaDigitise")
library(metaDigitise)

metaDigitise("~/Dropbox/0_postdoc/10_metaDigitise/docs/MEE_submission/tikx")


  x        y
2.329895 9.605761
2.114273 7.212674
1.583472 5.246919
4.747202 3.914303
6.648952 5.837144
3.518762 7.556821
4.027756 7.544506
7.247960 4.248326
9.070899 6.302404
9.867233 2.323294

    x           y
1.0038093  3.36692124
1.0033249  1.34415790
1.0067158  0.66434661
1.0031267 -0.09818274
0.9957944 -0.74152193
2.0042386  3.03186020
2.0021028  1.24003046
2.0111966  0.11248387
1.9999009 -0.53254776
2.0029175 -1.42184095
2.9988550  1.65929044
2.9989871  0.45249529
3.0168665 -0.35809939
2.9979963 -0.71757389
2.9957503 -1.74928600


filename	 group_id	 variable       mean	  sd		n	 	r		plot_type
figure.png   	black   seed size  3.5161025 2.1280607  	5	-0.4088671 scatterplot
figure.png    	black 	seed number  6.3834989 2.1254968	5	-0.4088671 scatterplot
figure.png      red   	seed size  6.7722915 2.8728976		5	-0.7954101 scatterplot
figure.png      red 	seed number  5.6096123 2.2446751	5	-0.7954101 scatterplot
figure2.png		1		seed size	0.8172729 1.0331970		40          NA  boxplot
figure2.png		2   	seed size  	0.4190345 1.1953705		40          NA  boxplot
figure2.png		3   	seed size  -0.1411919 0.8478949		40          NA  boxplot