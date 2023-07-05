
### Trying to draw calligraphy guidelines on paper of varying sizes

options(useFancyQuotes = FALSE)

# help(package="units")
library(units)
install_unit(symbol = "px", name = "pixel")

library(grid)
library(tidyverse)
# ?viewport
`>=.unit` <- function(e1, e2) {
  stopifnot(inherits(e1, "unit") && inherits(e2, "unit"))
  if (!identical(attr(e1, "unit"), attr(e2, "unit"))) stop("Units must match")
  unclass(e1) >= unclass(e2)
}
`>.unit` <- function(e1, e2) {
  stopifnot(inherits(e1, "unit") && inherits(e2, "unit"))
  if (!identical(attr(e1, "unit"), attr(e2, "unit"))) stop("Units must match")
  unclass(e1) > unclass(e2)
}
`<=.unit` <- function(e1, e2) {
  stopifnot(inherits(e1, "unit") && inherits(e2, "unit"))
  if (!identical(attr(e1, "unit"), attr(e2, "unit"))) stop("Units must match")
  unclass(e1) <= unclass(e2)
}
`<.unit` <- function(e1, e2) {
  stopifnot(inherits(e1, "unit") && inherits(e2, "unit"))
  if (!identical(attr(e1, "unit"), attr(e2, "unit"))) stop("Units must match")
  unclass(e1) < unclass(e2)
}
`==.unit` <- function(e1, e2) {
  stopifnot(inherits(e1, "unit") && inherits(e2, "unit"))
  if (!identical(attr(e1, "unit"), attr(e2, "unit"))) stop("Units must match")
  unclass(e1) == unclass(e2)
}
`!=.unit` <- function(e1, e2) {
  stopifnot(inherits(e1, "unit") && inherits(e2, "unit"))
  if (!identical(attr(e1, "unit"), attr(e2, "unit"))) stop("Units must match")
  unclass(e1) != unclass(e2)
}


# dimensions (width x height): 167mm x 243mm
# 
# left margin = 15.0mm
# right margin = 12.5mm
# 
# 300 pixels per inch == (300px / 1in) / (1in / 25.4mm) == 11.811 pixels per millimeter
# 
# page height @ 300 pixels per inch:
#   243mm == 9.5669in -> 2870.0787 pixels height
# 
# page width @ 300 pixels per inch:
#   167mm == 6.5748in -> 1972.4409 pixels width
# 
# lineheight = 19.0mm == 0.7480in @ 300 ppi -> 224.4094px
# half lineheight = 112.2047px
# space between lines = 12.6mm == 0.4961in @ 300 ppi -> 148.8189px
# 
# chunk (lineheight + space between lines) size = 224.4094
# 
# 
# set uniform margin size of 15.0mm == 0.5906in @ 300 ppi -> 177.1654px
#   doubled -> 354.3307px
#     usable height = 2870.0787px - 354.3307px = 2515.7480px
#     usable width = 1972.4409px - 354.3307px = 1618.1102px

# units_to_use <- "mm"
units_to_use <- "in" ### must use "in" instead of "inch" or "inches" because `ggsave()` is stupid

# page_width <- set_units(167, "mm") |> set_units(units_to_use, mode = "standard")
# page_height <- set_units(243, "mm") |> set_units(units_to_use, mode = "standard")
page_width <- set_units(8.5, "inch")
page_height <- set_units(11, "inch")

margin_size <- set_units(15, "mm") |> set_units(units_to_use, mode = "standard")

# resolution <- 300 # pixels per inch
resolution <- set_units(300, "pixel/inch")

# # set_units(300, "px")
# 
# page_width
# page_width |> set_units("in")
# page_width |> set_units("in") * 300
# # page_width |> set_units("in") * set_units(300, "pixel/inch")
# # page_height |> set_units("in") * set_units(300, "pixel/inch")
# # page_width |> set_units("in") * resolution
# # page_height |> set_units("in") * resolution
# 
# page_width * resolution
# page_height * resolution

# x <- valid_udunits()
# 
# x |>
#   # filter(grepl(pattern = "x", x = name_singular, fixed = TRUE)) |>
#   filter(dimensionless == TRUE) |>
#   head() #|>
#   # as.data.frame()

# set_units(1, "pixel")
# 
# install_unit(symbol = "px", name = "pixel")
# set_units(300, px/inch)
# set_units(300, pixel/inch)
# install_unit(symbol = "ppi", def = "px/inch", name = "pixels_per_inch")
# 
# set_units(300, px / inch)
# set_units(300, ppi)
# identical(set_units(300, px/inch), set_units(300, ppi))
# identical(set_units(300, "px/in"), set_units(300, ppi))
# identical(set_units(300, "px/inch"), set_units(300, ppi))
# page_width |> set_units("ppi")
# 
# remove_unit(c("px", "ppi"), c("pixel", "pixels_per_inch"))



usable_width <- page_width - (2 * margin_size) |> set_units(units_to_use, mode = "standard")
usable_height <- page_height - (2 * margin_size) |> set_units(units_to_use, mode = "standard")

line_height <- set_units(19.0, "mm") |> set_units(units_to_use, mode = "standard")
line_height_half <- line_height / 2



# space_between_lines <- set_units(12.6, "mm")
# space_between_lines <- set_units(12.0, "mm")
space_between_lines <- set_units(11.0, "mm") |> set_units(units_to_use, mode = "standard")

chunk_height <- line_height + space_between_lines

# usable_height / chunk_height
# 
# # (x+1)line_height + x*space_between_lines <= usable_height
# # OR
# # (x+1)line_height + x*space_between_lines + 2*margin_size <= page_height

# # trunc(usable_height / chunk_height)*chunk_height + line_height
# # usable_height
# page_height / chunk_height
# trunc(page_height / chunk_height)*chunk_height + line_height
# 
# page_height - (trunc(page_height / chunk_height)*chunk_height + line_height)
# page_height - (6*chunk_height + line_height)
# page_height - (7*chunk_height + line_height)
# 
# page_height - 8*line_height - 7*space_between_lines #- 2*margin_size
# 
# margin_size_tb <- (page_height - 8*line_height - 7*space_between_lines) / 2
# margin_size_lr <- margin_size
# 
# 
# top_left_x_header <- margin_size_lr
# top_left_y_header <- page_height - margin_size_tb
# 
# top_right_x_header <- page_width - margin_size_lr
# top_right_y_header <- top_left_y_header
# 
# top_left_x_footer <- margin_size_lr
# top_left_y_footer <- page_height - margin_size_tb - line_height
# 
# top_right_x_footer <- page_width - margin_size_lr
# top_right_y_footer <- top_left_y_footer
# 
# top_left_x_middle <- margin_size_lr
# top_left_y_middle <- page_height - margin_size_tb - line_height_half
# 
# top_right_x_middle <- page_width - margin_size_lr
# top_right_y_middle <- top_left_y_middle




# page_height / chunk_height
# trunc(page_height / chunk_height)*chunk_height + line_height
# page_height
# (which.min(((0:30 * chunk_height) + line_height) < page_height) - 1) * chunk_height + line_height
# 
# multiples <- 0:30
# multiples[which.min(((multiples * chunk_height) + line_height) < page_height) - 1L] * chunk_height + line_height
# 
# baselines_y <- multiples * chunk_height
# baselines_y < page_height
# baselines_y[which.min(baselines_y < page_height) - 1L] + line_height
# page_height - (baselines_y[which.min(baselines_y < page_height) - 1L] + line_height)



zero <- set_units(0, "mm") |> set_units(units_to_use, mode = "standard")
line_locations <- tibble(line_number = 1:30) |>
  mutate(
    multiple = line_number - 1L,
    y_headline = page_height - (multiple * chunk_height),
    y_midline = page_height - line_height_half - (multiple * chunk_height),
    y_baseline = page_height - line_height - (multiple * chunk_height),
    x_left = margin_size,
    x_right = page_width - margin_size
  ) |>
  filter(
    # y_headline > zero,
    # y_baseline > zero
    between(y_headline, zero, page_height),
    between(y_baseline, zero, page_height)
  # ) |>
  # # filter(row_number() == n())
  # mutate(
  #   total_lines = max(line_number)
  )
# # line_locations
# # glimpse(line_locations)
# sapply(line_locations, is.unit)
# sapply(line_locations, \(x) {inherits(x, "units")})

occupied_height <- with(line_locations, max(y_headline) - min(y_baseline))
unused_height <- page_height - occupied_height
line_coordinates <- line_locations |>
# line_locations |>
  select(-multiple) |>
  mutate(
    across(.cols = starts_with("y_"), .fns = \(x) {x - (0.2 * unused_height)})#,
    # across(.cols = where(\(x) {inherits(x, "units")}), .fns = \(x) {x * set_units(300, "pixel/inch")})
  )

plot_coordinates <- line_coordinates |>
  pivot_longer(
    cols = starts_with("y_"),
    names_to = "line_purpose",
    names_prefix = "y_",
    values_to = "y"
  ) |>
  mutate(
    linetype = case_match(
      line_purpose,
      c("headline", "baseline") ~ "solid",
      "midline" ~ "dashed",
      .default = "dotted"
    )
  )
print(plot_coordinates, n = 50)

guidelines_sheet <- plot_coordinates |>
  ggplot(
    mapping = aes(
      x = x_left,
      y = y,
      xend = x_right,
      yend = y
    )
  ) +
  theme_void() +
  geom_segment(linetype = plot_coordinates[["linetype"]], colour = "black")
guidelines_sheet

# # ggsave(filename = "C:/Users/Ted/Documents/GitHub/sandbox/r/guidelines.svg", plot = guidelines_sheet, device = "svg")
# # ggsave(filename = "C:/Users/Ted/Documents/GitHub/sandbox/r/guidelines.svg", plot = guidelines_sheet, device = "svg", width = page_width, height = page_height)
# ggsave(filename = "C:/Users/Ted/Documents/GitHub/sandbox/r/guidelines.svg", plot = guidelines_sheet, device = "svg", width = unclass(page_width), height = unclass(page_height), units = "mm")
# ggsave(filename = "C:/Users/Ted/Documents/GitHub/sandbox/r/guidelines.png", plot = guidelines_sheet, device = "png", width = unclass(page_width), height = unclass(page_height), units = "mm")

ggsave(filename = "C:/Users/Ted/Documents/GitHub/sandbox/r/guidelines.svg", plot = guidelines_sheet, device = "svg", width = as.numeric(page_width), height = as.numeric(page_height), units = units_to_use)
ggsave(filename = "C:/Users/Ted/Documents/GitHub/sandbox/r/guidelines.png", plot = guidelines_sheet, device = "png", width = as.numeric(page_width), height = as.numeric(page_height), units = units_to_use)


# # guidelines <- tribble(
# #   ~role, ~x, ~y
# # )
# 
# page_width <- unit(167, "mm")
# page_height <- unit(243, "mm")
# 
# margin_size <- unit(15, "mm")
# 
# # resolution <- 300 # pixels per inch
# 
# page_width
# # page_width |> convertWidth("in")
# # page_width |> convertX("in")
# 
# 
# usable_width <- page_width - (2 * margin_size)
# usable_height <- page_height - (2 * margin_size)
# 
# line_height <- unit(19.0, "mm")
# line_height_half <- line_height / 2
# 
# # space_between_lines <- unit(12.6, "mm")
# # space_between_lines <- unit(12.0, "mm")
# space_between_lines <- unit(11.0, "mm")
# 
# chunk_height <- line_height + space_between_lines
# 
# baselines_y <- 0:20 * chunk_height
# midlines_y <- baselines_y + line_height_half
# headlines_y <- baselines_y + line_height
# 
# headlines_y >= page_height
# which.max(headlines_y >= page_height)
# which.min(baselines_y <= page_height)
# 
# baselines_y >= page_height
# headlines_y >= page_height
# 
# baselines_y < page_height
# headlines_y < page_height
# 
# (baselines_y < page_height) & (headlines_y < page_height)
# 
# trunc(unclass(page_height) / unclass(chunk_height))
# 
# 
# # usable_height / chunk_height
# # 
# # # (x+1)line_height + x*space_between_lines <= usable_height
# # # OR
# # # (x+1)line_height + x*space_between_lines + 2*margin_size <= page_height
# 
# # trunc(usable_height / chunk_height)*chunk_height + line_height
# # usable_height
# trunc(page_height / chunk_height)*chunk_height + line_height
# page_height
# 
# page_height - (trunc(page_height / chunk_height)*chunk_height + line_height)
# page_height - (6*chunk_height + line_height)
# page_height - (7*chunk_height + line_height)
# 
# page_height - 8*line_height - 7*space_between_lines #- 2*margin_size
# 
# margin_size_tb <- (page_height - 8*line_height - 7*space_between_lines) / 2
# margin_size_lr <- margin_size
# 
# 
# top_left_x_header <- margin_size_lr
# top_left_y_header <- page_height - margin_size_tb
# 
# top_right_x_header <- page_width - margin_size_lr
# top_right_y_header <- top_left_y_header
# 
# top_left_x_footer <- margin_size_lr
# top_left_y_footer <- page_height - margin_size_tb - line_height
# 
# top_right_x_footer <- page_width - margin_size_lr
# top_right_y_footer <- top_left_y_footer
# 
# top_left_x_middle <- margin_size_lr
# top_left_y_middle <- page_height - margin_size_tb - line_height_half
# 
# top_right_x_middle <- page_width - margin_size_lr
# top_right_y_middle <- top_left_y_middle












