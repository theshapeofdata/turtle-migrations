## Script for fitting (1) Bayes SSM for location estimation only (DCRW.ssm) and (2) Bayes SSM for location and behavioural state estimation (DCRWS.ssm)
## 25.10.2011
rm(list=ls())
require(bsam)

setwd("/Users/ashwinip/Documents/Academic/Turtles/Telemetry/R/DCRWS/")

## Obtain simulate data and convert dates to POSIX objects
tr = read.csv(file.path("sim","turtle_103402.csv"))
tr$date = as.POSIXct(as.character(tr$date), "%Y-%m-%d %H:%M:%S", tz="GMT")
argos = read.csv(file.path("sim","turtle_103402.csv"))
argos$date = as.POSIXct(as.character(argos$date), "%Y-%m-%d %H:%M:%S", tz="GMT")
argos = with(argos, data.frame(id=1, date, lc, lon, lat))

## Estimate track using MCMC via JAGs - this could take 20-30 minutes
DCRWS.ssm = fitSSM(indata=argos, model="DCRWS", tstep=6/24, adapt=10000, samples=5000, thin=10, chains=2)

## Save summary results to .csv file 
write.csv(DCRWS.ssm[[1]]$output$summary, file.path("mcmc","DCRWSsummary_103402.csv"), row.names=FALSE)

mcmc = DCRWS.ssm[[1]]$output$summary
 
## Plot track-based results
# create 3-colour ramp
bgr = colorRampPalette(c("blue", "grey", "red"))
ncols = 10
idx = round((mcmc$b-1) * ncols)
idx[idx==0] = 1

pdf(file.path("mcmc","results_103402.pdf"), width=6, height=7)
layout(matrix(c(1,2,1,3), 2,2), widths=c(2,2), heights=c(1.5,2.5), respect=TRUE)
par(mar=c(4,4,1,1),omi=c(0.3,0.1,0.1,0.1))

## plot estimated vs simluated (truth) behavioral states sequentially
#plot(I(b-1)~date, mcmc, type='h', col=grey(0.6), lwd=0.5, ylim=c(0,1), las=1, ylab="P(resident)", yaxt="n", xlab="", bty="n", xaxs="i")
plot(I(b-1)~date, mcmc, type='h', col=bgr(ncols)[idx], lwd=0.1, ylim=c(0,1), las=1, ylab="P(resident)", yaxt="n", xlab="", bty="n", xaxs="i",
     main='Time series: probability of residence')
axis(2, at=pretty(0:1, 5), mgp=c(1,0.5,0.25), las=1, tcl=-0.3)
axis(4, lab=FALSE, tcl=-0.3, mgp=c(3,1,0.25),) 
lines(I(b-1)~date, mcmc, type='l', col='black', lwd=0.5)

## plot estimated vs simulated (truth) locations (lon, lat)
plot(lat~lon, tr, type='p', col='black', las=1, ylab='Latitude (deg)', xlab='', xlim=extendrange(mcmc$lon, f=0.05), ylim=extendrange(mcmc$lat, f=0.05),
     main='Estimated vs observed locations')
lines(lat~lon, mcmc, col='black')
legend("bottomleft", 
       legend = "Observations", 
       col = "black",
       pch = 1, 
       bty = "n", 
       pt.cex = 1, 
       cex = 1, 
       text.col = "black", 
       horiz = F , 
       inset = c(0, 0))

## plot estimated vs simulated (truth) locations color coded by behavioral state
plot(lat~lon, mcmc, type='l', las=1, ylab='', xlab='', xlim=extendrange(mcmc$lon, f=0.01), ylim=extendrange(mcmc$lat, f=0.01),
     main='Behavioral states')
idx = round((mcmc$b-1) * ncols)
idx[idx==0] = 1
#points(lat~lon, mcmc, pch=21, bg=bgr(ncols)[idx], col=grey(0.6), cex=0.7, lwd=0.2)
points(lat~lon, mcmc, pch=19, col=bgr(ncols)[idx], cex=0.7, lwd=0.2)
legend("topleft", 
       legend = c("Resident", "Migrating", "Uncertain"), 
       col = c("red", 
               "blue", 
               "grey"),
       pch = 19, 
       bty = "n", 
       pt.cex = 1, 
       cex = 1, 
       text.col = "black", 
       horiz = F , 
       inset = c(0, 0))
mtext("Longitude (deg)", 1, -3.5, outer=T, adj=0.55)
dev.off()

## Diagnostics ##
do.diagnostics = TRUE
if(do.diagnostics){
	save(DCRWS.ssm,file=file.path("mcmc","BssmRes_103402.RData")) ## Save MCMC results to a binary file to be loaded later  
	diagSSM(DCRWS.ssm[[1]])	  
	}
