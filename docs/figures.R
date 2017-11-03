
data(iris)
head(iris)
data(airquality)
head(airquality)

#plot(Temp~Wind,airquality, subset = Month %in% c(5,6), pch=c(19,1)[as.factor(airquality$Month)])

cex.mtext = 2
setosa <- subset(iris, Species == "setosa")

setwd("/Users/joelpick/Dropbox/0_postdoc/10_metaDigitise")


## first plot

setEPS()
pdf("./docs/fig_plot_type.pdf", height=9, width=9)

par(mfrow=c(2,2), mar=c(6,5,2,1), cex.lab=1.5)

means <- with(iris,tapply(Sepal.Length, Species, mean))
ses <- with(iris,tapply(Sepal.Length, Species, function(x) sd(x)/sqrt(length(x))))*1.96

plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,3.5), xaxt="n", pch=19, cex=2, ylab="Sepal Length", xlab="Species")
mtext("A", 3, adj=0, line=0, cex=cex.mtext)
arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
axis(1,1:length(means),names(means))

boxplot(Sepal.Length ~ Species, iris, ylab="Sepal Length", xlab="Species", col="grey", range=0)
mtext("B", 3, adj=0, line=0, cex=cex.mtext)


set.seed(5)
plot(Sepal.Length~jitter(Petal.Length),setosa, pch=19, ylab="Sepal Length", xlab="Petal Length")
mtext("C", 3, adj=0, line=0, cex=cex.mtext)

hist(setosa$Sepal.Length,, main="", col="grey", xlab="Sepal Length")
mtext("D", 3, adj=0, line=0, cex=cex.mtext)

dev.off()




### make pngs
png("./docs/images/iris_mean_error.png")
par(mar=c(6,5,1,1), cex.lab=1.5)
plot(means, ylim = c(min(means-ses)-0.1,max(means+ses)+0.1), xlim=c(0.5,3.5), xaxt="n", pch=19, cex=2, ylab="Sepal Length", xlab="Species")
arrows(1:length(means),means+ses, 1:length(means), means-ses, code=3, angle=90, length=0.1)
axis(1,1:length(means),names(means))
dev.off()

png("./docs/images/iris_scatter.png")
par(mar=c(6,5,1,1), cex.lab=1.5)
plot(Sepal.Length~jitter(Petal.Length),setosa, pch=19, ylab="Sepal Length", xlab="Petal Length")
dev.off()

png("./docs/images/iris_boxplot.png")
par(mar=c(6,5,1,1), cex.lab=1.5)
boxplot(Sepal.Length ~ Species, iris, ylab="Sepal Length", xlab="Species", col="grey", range=0)
dev.off()

png("./docs/iris_histogram.png")
par(mar=c(6,5,1,1), cex.lab=1.5)
hist(setosa$Sepal.Length,, main="", col="grey", xlab="Sepal Length")
dev.off()


png("./docs/images/iris_boxplot_flip.png")
par(mar=c(6,5,1,1), cex.lab=1.5)
boxplot(Petal.Width ~ Species, iris, ylab="Petal Width", xlab="Species", col="grey", range=0, horizontal=TRUE)
dev.off()


png("./docs/images/iris_boxplot_log.png")
par(mar=c(6,5,1,1), cex.lab=1.5)
boxplot(Petal.Length ~ Species, iris, ylab="Sepal Length", xlab="Species", col="grey", range=0, log="y")
dev.off()





dat <- metaDigitise("./docs/images/")

object_scatter <- readRDS("./docs/images/caldat/iris_scatter_rotate")
object_hist <- readRDS("./docs/images/caldat/iris_histogram")
object_mean <- readRDS("./docs/images/caldat/iris_mean_error")
object_box <- readRDS("./docs/images/caldat/iris_boxplot")



setEPS()
pdf("./docs/fig_rotate.pdf", height=16, width=12)

par(mfrow=c(2,2), oma=c(0,0,0,0), cex.lab=1.5)
do.call(internal_redraw, c(object_scatter, rotation=FALSE, calibration=FALSE,points=FALSE))
mtext("A", side=3, adj=0.1, cex=cex.mtext)
do.call(internal_redraw, c(object_scatter, rotation=TRUE, calibration=FALSE,points=FALSE))
mtext("B", side=3, adj=0.1, cex=cex.mtext)
internal_redraw("./docs/images/iris_boxplot_flip.png")
mtext("C", side=3, adj=0.1, cex=cex.mtext)
internal_redraw("./docs/images/iris_boxplot_flip.png", flip=TRUE)
mtext("D", side=3, adj=0.1, cex=cex.mtext)
dev.off()




setEPS()
pdf("./docs/fig_calibrate.pdf", height=8, width=12)

par(mfrow=c(1,2), oma=c(0,0,3,0), cex.lab=1.5)
do.call(internal_redraw, c(object_scatter, calibration=FALSE,points=FALSE))
mtext("A", side=3, outer = TRUE, adj=0.1, cex=cex.mtext)
do.call(internal_redraw, c(object_scatter, calibration=TRUE,points=FALSE))
mtext("B", side=3, outer = TRUE, adj=0.6, cex=cex.mtext)

dev.off()





setEPS()
pdf("./docs/fig_all_extract.pdf", height=16, width=12)

par(mfrow=c(2,2), oma=c(0,0,0,0))
do.call(internal_redraw, c(object_mean, points=TRUE))
mtext("A", side=3, adj=0.1, cex=cex.mtext)
do.call(internal_redraw, c(object_box, points=TRUE))
mtext("B", side=3, adj=0.1, cex=cex.mtext)
do.call(internal_redraw, c(object_scatter, points=TRUE))
mtext("C", side=3, adj=0.1, cex=cex.mtext)
do.call(internal_redraw, c(object_hist, points=TRUE))
mtext("D", side=3, adj=0.1, cex=cex.mtext)

dev.off()


