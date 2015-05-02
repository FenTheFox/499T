library(ggplot2)
library(plyr)

ffjsdata <- read.csv(file = "firefox/js.csv", header = T, sep = ",")
ffjsstats <- read.csv(file = "firefox/js_stats.csv", header = T, sep = ",")
ffrenderdata <- read.csv(file = "firefox/render.csv", header = T, sep = ",")
ffrenderstats <- read.csv(file = "firefox/render_stats.csv", header = T, sep = ",")
sqldata <- read.csv(file = "sqlite/results.csv", header = T, sep = ",")
sqlstats <- read.csv(file = "sqlite/stats.csv", header = T, sep = ",")

ffperf <- read.csv(file="firefox/perf.csv", header = T, sep = ",")
sqlperf <- read.csv(file = "sqlite/perf.csv", header = T, sep = ",")

stat_mean <- function(map) {
  stat_summary(mapping = map, fun.y=mean, geom="bar")
}

aes_alloc = aes(x=allocator, fill=allocator)

ffj <- ggplot(ffjsdata,aes_alloc) + ggtitle("JSBench") + stat_summary(mapping=aes(y=runtime), fun.y=mean, geom="bar") + geom_errorbar(data=ffjsstats, mapping=aes(ymin=mean-standard_dev, ymax=mean+standard_dev), width=0.6)
ggsave(filename = "ffj.png", ffj, height = 4.5)
ffr <- ggplot(ffrenderdata,aes_alloc) + ggtitle("RenderBench") + stat_summary(mapping=aes(y=runtime), fun.y=mean, geom="bar") + geom_errorbar(data=ffrenderstats, mapping=aes(ymin=mean-standard_dev, ymax=mean+standard_dev), width=0.6)
ggsave(filename = "ffr.png", ffr, height = 4.5)

sqlc <- ggplot(sqldata, aes_alloc) + ggtitle("CreateBench") + ylab("runtime") + stat_summary(mapping=aes(y=create), fun.y=mean, geom="bar") + geom_errorbar(data=sqlstats, mapping=aes(ymin=create_mean-create_stdev, ymax=create_mean+create_stdev), width=0.6)
ggsave(filename = "sqlc.png", sqlc, height = 4.5)
sqlq <- ggplot(sqldata, aes_alloc) + ggtitle("QueryBench") + ylab("runtime") + stat_summary(mapping=aes(y=query), fun.y=mean, geom="bar") + geom_errorbar(data=sqlstats, mapping=aes(ymin=query_mean-query_stdev, ymax=query_mean+query_stdev), width=0.6)
ggsave(filename = "sqlq.png", sqlq, height = 4.5)

ffa <- ggplot(ffperf, aes(x=allocator, fill=benchmark)) + ggtitle("Time Firefox Spent in Allocator") + geom_bar(aes(y=percent), position = "dodge", stat = "identity")
ggsave(filename = "ffa.png", ffa, height = 4.5)
sqla <- ggplot(sqldata, aes_alloc) + ggtitle("Time SQLite Spent in Allocator") + geom_bar(aes(y=percent), stat = "identity")
ggsave(filename = "sqla.png", sqla, height = 4.5)