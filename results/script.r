library(ggplot2)
library(plyr)

ffjsdata <- read.csv(file = "firefox/js.csv", header = T, sep = ",")
ffjsstats <- read.csv(file = "firefox/js_stats.csv", header = T, sep = ",")
ffrenderdata <- read.csv(file = "firefox/render.csv", header = T, sep = ",")
ffrenderstats <- read.csv(file = "firefox/render_stats.csv", header = T, sep = ",")
sqldata <- read.csv(file = "sqlite/results.csv", header = T, sep = ",")
sqlstats <- read.csv(file = "sqlite/stats.csv", header = T, sep = ",")

stat_mean <- function(map) {
  stat_summary(mapping = map, fun.y=mean, geom="bar")
}

plot_mean <- function(data, aesx, aesy, title) {
  ggplot(data, aesx) + ggtitle(title) + stat_summary(mapping = aesy, fun.y=mean, geom="bar") + geom_errorbar(data = sqlstats, mapping = aes(ymin=create_mean-create_stdev, ymax=create_mean+create_stdev), width=0.5)
}
sql <- plot_mean(sqldata, aes(x=allocator, fill=allocator), aes(y = create), "Sqlite Create")
ggsave(filename = "sqlc.png", sql)
