library(ggplot2)
library(dplyr)
library(svglite)

# Data
stumpings <- data.frame(
  player = c("Keemo Paul\n(2018 ODI)", "Mitchell Marsh\n(2012 T20I)",
             "Shubman Gill\n(IPL 2023)", "Suryakumar Yadav\n(IPL 2024)"),
  time = c(0.08, 0.09, 0.10, 0.12)
)

# Calculate hand positions
stumpings <- stumpings %>%
  mutate(
    degree = 360 * (time / 60),
    radians = (90 - degree) * pi / 180,
    x = cos(radians),
    y = sin(radians),
    xend = 0,
    yend = 0
  )

# Circle outline
circle <- data.frame(angle = seq(0, 360, length.out = 360)) %>%
  mutate(
    radians = (90 - angle) * pi / 180,
    x = cos(radians),
    y = sin(radians)
  )

# Major ticks (5s)
major_ticks <- data.frame(seconds = seq(0, 60, by = 5)) %>%
  mutate(degree = 360 * (seconds / 60),
         radians = (90 - degree) * pi / 180,
         x_start = 0.94 * cos(radians),
         y_start = 0.94 * sin(radians),
         x_end = 1.06 * cos(radians),
         y_end = 1.06 * sin(radians),
         x_label = 1.2 * cos(radians),
         y_label = 1.2 * sin(radians))

# Minor ticks (1s)
minor_ticks <- data.frame(seconds = seq(0, 60, by = 1)) %>%
  mutate(degree = 360 * (seconds / 60),
         radians = (90 - degree) * pi / 180,
         x_start = 0.96 * cos(radians),
         y_start = 0.96 * sin(radians),
         x_end = 1.04 * cos(radians),
         y_end = 1.04 * sin(radians))

# Fine ticks (every 0.1s)
fine_ticks <- data.frame(seconds = seq(0, 60, by = 0.1)) %>%
  mutate(degree = 360 * (seconds / 60),
         radians = (90 - degree) * pi / 180,
         x_start = 0.98 * cos(radians),
         y_start = 0.98 * sin(radians),
         x_end = 1.02 * cos(radians),
         y_end = 1.02 * sin(radians))

# Plot
p <- ggplot() +
  # Circle outline
  geom_path(data = circle, aes(x = x, y = y), color = "gray80") +
  
  # Fine tickmarks (milliseconds)
  geom_segment(data = fine_ticks, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray80", linewidth = 0.2) +
  
  # Minor tickmarks
  geom_segment(data = minor_ticks, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray60", linewidth = 0.3) +
  
  # Major tickmarks
  geom_segment(data = major_ticks, aes(x = x_start, y = y_start, xend = x_end, yend = y_end),
               color = "gray40", linewidth = 0.5) +
  
  # Labels at major ticks
  geom_text(data = major_ticks, aes(x = x_label, y = y_label, label = seconds),
            size = 3, color = "gray20") +
  
  # Stopwatch hands
  geom_segment(data = stumpings, aes(x = xend, y = yend, xend = x, yend = y),
               color = "darkgreen", linewidth = 0.5) +
  geom_point(data = stumpings, aes(x = x, y = y), size = 1, color = "darkgreen") +
  geom_text(data = stumpings, aes(x = x, y = y + 0.15, label = paste0(time, "s")),
            size = 4, fontface = "bold") +
  
  coord_fixed() +
  theme_void() +
  facet_wrap(~player, ncol = 2) +
  ggtitle("Dhoni's Fastest Stumpings with Millisecond Precision") +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 14),
    strip.text = element_text(face = "bold", size = 12)
  )

width_px = 1000
height_px = 800
dpi = 96 
width_in_inches = width_px / dpi
height_in_inches = height_px / dpi
svglite("p.svg", width = width_in_inches, height = height_in_inches)
print(p) # Plot output is captured and written to the file
dev.off()
