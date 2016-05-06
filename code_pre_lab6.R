library("pols503")
library("rio")
library("ggplot2")
library("dplyr")
library("broom")
library("xtable")

db <- import("TradeConflict.dta")

mod1 <- lm(lnrtrade ~ lnrpciab + avremote + landlocked + island + 
             landratio + pciratio + jointdem + laglnrtrade +
             lnrgdpab + lndist + logUNsun * avpctBCFE, 
           data = db)

db <- mutate(db, avpctBCFEcat3 = cut(x = avpctBCFE, breaks = 3, 
                                     labels = c("low", "medium", "high")))

mod3 <- lm(lnrtrade ~ lnrpciab + avremote + landlocked + island + 
             landratio + pciratio + jointdem + laglnrtrade +
             lnrgdpab + lndist + logUNsun * avpctBCFEcat3, 
           data = db)

controls <- c("lnrpciab", "avremote", "landlocked", "island", 
              "landratio", "pciratio", "jointdem", "laglnrtrade",
              "lnrgdpab", "lndist")
scenarios <- data.frame(logUNsun = rep(c(0,1), 3),
                        avpctBCFEcat3 = c(rep("low", 2), rep("medium", 2),
                                          rep("high", 2)))
for (var in controls) {
  scenarios[,var] <- mean(db[,var], na.rm = TRUE)
}
pred_scenarios <- predict(mod3, newdata = scenarios)

dif1 <- pred_scenarios[2] - pred_scenarios[1]
dif2 <- pred_scenarios[4] - pred_scenarios[3]
dif3 <- pred_scenarios[6] - pred_scenarios[5]
dif4 <- pred_scenarios[3] - pred_scenarios[1]
dif5 <- pred_scenarios[5] - pred_scenarios[1]
dif6 <- dif2 - dif1
dif7 <- dif3 - dif1

differences <- data.frame(dif1, dif2, dif3, 
                          dif4, dif5, dif6, dif7)

