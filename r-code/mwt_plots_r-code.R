#INSTRUCTIONAL CODE FOR MONROE WORK TODAY (auut studio) ETHICAL VISUALIZATIONS - DHSI - OTHER PLOTS
#CHRISTOPHER CHURCH / KATHERINE HEPWORTH

#Where did you download the data?
setwd(
  "D:/Users/Christopher/Dropbox/NDAD/DHSI/course-packet/datasets/monroe-work-today"
)

#variables
#----------------------------------------------------------------------------------------------------------
start_year         = 1803               #when to start mapping, default = 1803
end_year           = 2011               #when to end mapping, default = 2011
white_supremacy    = T                  #set to T to only include those that the dataset author concluded were incidents of white supremacy
x_axis             = "mwt_race"         #what do you want to tally?  [mwt_race,race_source,year_source,sex,alleged,mwt_alleged_category]
plot_type          = "bar"              #what type of plot do you want to create?    [bar,scatter,pie,waffle]
plot_title_size    = 32                 #how big do you want the size of the title font? , default is 32
plot_subtitle_size = 22                 #how big do you want the size of the subtitle font?, default is 22
caption_size       = 10                 #how big do you want the size of the caption font?, default is 10
plot_title         = "Plot Title"
plot_subtitle      = "Subtitle"
plot_caption       = "Caption"
x_label            = ""
y_label            = ""
#----------------------------------------------------------------------------------------------------------
#libraries
library(ggplot2)


#get data
lynchings = read.csv("MWT_dataset_compilation_v1_0_ChurchHepworth.csv")
lynchings = lynchings [lynchings$year_source >= start_year &
                         lynchings$year_source <= end_year, ]
if (white_supremacy == T) {
  lynchings = lynchings [lynchings$mwt_white_supremacy == 1, ]
}
a = x_axis
b = "count"

agg <-
  aggregate(
    cbind(count = mwt_id) ~ lynchings[, a],
    data = lynchings,
    FUN = function(x) {
      NROW(x)
    }
  )

colnames(agg) <- c(a, b)

g <- ggplot(agg, aes_string(a, b))
if (plot_type == "bar") {
  g = g + geom_bar(stat = "identity")
}
if (plot_type == "scatter") {
  g = g + geom_line()
}
if (plot_type == "pie") {
  agg$percent = (agg[, b] / sum(agg[, b]) * 100)
  g = ggplot(agg, aes_string(x = 1, agg[, "percent"], fill = a)) + geom_bar(width =
                                                                              1, stat = "identity") + coord_polar("y", start = 0)
}
if (plot_type == "waffle") {
  agg$percent = (agg[, b] / sum(agg[, b]) * 100)
  ndeep <- 5 # How many rows do you want the y axis to have?
  agg[, a] <- as.character(agg[, a])
  waffles <-
    expand.grid(y = 1:ndeep, x = seq_len(ceiling(sum(agg$percent) / ndeep)))
  catvec <- rep(agg[, a], agg$percent)
  waffles$cat <- c(catvec, rep(NA, nrow(waffles) - length(catvec)))
  g = ggplot(waffles, aes(x = x, y = y, fill = cat)) +
    geom_tile(color = "white") # The color of the lines between tiles
  
}

#LABELS
g = g + labs(title = plot_title,
             subtitle = plot_subtitle,
             caption = plot_caption) +
  xlab(x_label) +
  ylab(y_label)

#COLOR AND THEME
g = g + theme_bw() + theme(
  plot.title = element_text(size = plot_title_size),
  plot.subtitle = element_text(size = plot_subtitle_size),
  text = element_text(size = 20),
  plot.caption = element_text(size = caption_size),
  axis.text.x = element_text(angle = 45, hjust = 1),
  panel.grid.major.x = element_blank(),
  panel.grid.minor.x = element_blank(),
  panel.grid.major.y = element_line(size = .1, color = "black")
)
if (plot_type == "pie" || plot_type == "waffle") {
  g = g + theme(
    axis.ticks = element_blank(),
    axis.text.y = element_blank(),
    axis.text.x = element_blank()
  )
}
g
