
set.seed(5)
library(MASS)
n=50
plot_dat <- mvrnorm(n,c(0,0.5),matrix(c(1,0.5,0.5,1),ncol=2))
x <- plot_dat[,1]
y <- plot_dat[,2]
id <- gl(2,n)
idx <- gl(2,n/2)
means <- tapply(c(x,y), id, mean)
ses <- tapply(c(x,y), id, function(x) sd(x)/sqrt(length(x)))

setEPS()
pdf("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/fig_plot_type.pdf", height=9, width=9)

par(mfrow=c(2,2), mar=c(6,5,2,1), cex.lab=1.5)
plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,2.5), xaxt="n", pch=19, cex=2, ylab="variable", xlab="group")
mtext("A", 3, adj=0, line=0)
arrows(c(1,2),means+ses, c(1,2), means-ses, code=3, angle=90, length=0.1)
axis(1,c(1,2),c(1,2))
boxplot(c(x,y)~id, ylab="variable", xlab="group", col="grey")
mtext("B", 3, adj=0, line=0)
plot(x,y, pch=c(19,1)[idx])
mtext("C", 3, adj=0, line=0)
hist(x, main="", col="grey")
mtext("D", 3, adj=0, line=0)

dev.off()


png("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/scatter_plot.png")
plot(x~y, pch=19)
dev.off()



setEPS()
pdf("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/fig_rotate.pdf", height=5, width=10)

par(mfrow=c(1,2), oma=c(0,0,3,0), cex.lab=1.5)
internal_redraw("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/scatter_rotate.png")
mtext("A", side=3, outer = TRUE, adj=0.1, cex=2)
#user_rotate_graph("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/scatter_rotate.png")

internal_redraw("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/scatter_rotate.png", rotate=6.66894)
mtext("B", side=3, outer = TRUE, adj=0.6, cex=2)

dev.off()



setEPS()
pdf("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/fig_flip.pdf", height=5, width=10)

par(mfrow=c(1,2), oma=c(0,0,3,0), cex.lab=1.5)
internal_redraw("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/example_figs/horiz_plot.png")
mtext("A", side=3, outer = TRUE, adj=0.1, cex=2)
internal_redraw("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/example_figs/horiz_plot.png", flip=TRUE)
mtext("B", side=3, outer = TRUE, adj=0.6, cex=2)

dev.off()



object <- readRDS("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/scatter.RDS")


setEPS()
pdf("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/fig_calibrate.pdf", height=5, width=10)

par(mfrow=c(1,2), oma=c(0,0,3,0), cex.lab=1.5)
do.call(internal_redraw, c(object, calibration=FALSE))
mtext("A", side=3, outer = TRUE, adj=0.1, cex=2)
do.call(internal_redraw, c(object, calibration=TRUE))
mtext("B", side=3, outer = TRUE, adj=0.6, cex=2)

dev.off()

#user_calibrate(list(image_file="/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/scatter_rotate.png", variable=c(y="x", x="y"), rotate=6.66894, plot_type="scatterplot"))


setEPS()
pdf("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise/docs/fig_scatter_points.pdf", height=7, width=12)

par(mfrow=c(1,2), oma=c(0,0,3,0), cex.lab=1.5)
do.call(internal_redraw, c(object, points=FALSE))
mtext("A", side=3, outer = TRUE, adj=0.1, cex=2)
do.call(internal_redraw, c(object, points=TRUE))
mtext("B", side=3, outer = TRUE, adj=0.6, cex=2)

dev.off()

 
# point_extraction(object)



