
### Trying to draw calligraphy guidelines on paper of varying sizes

options(useFancyQuotes = FALSE)

library(units)
help(package="units")

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

page_width <- set_units(167, "mm")
page_height <- set_units(243, "mm")

margin_size <- set_units(15, "mm")

resolution <- 300 # points per inch

# set_units(300, "px")

page_width
page_width |> set_units("in")
page_width |> set_units("in") * 300

# set_units(1, "pixel")
# 
# install_unit(symbol = "px", name = "pixel")
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



usable_width <- page_width - (2 * margin_size)
usable_height <- page_height - (2 * margin_size)

line_height <- set_units(19.0, "mm")
line_height_half <- line_height / 2

# space_between_lines <- set_units(12.6, "mm")
# space_between_lines <- set_units(12.0, "mm")
space_between_lines <- set_units(11.0, "mm")

chunk_height <- line_height + space_between_lines

# usable_height / chunk_height
# 
# # (x+1)line_height + x*space_between_lines <= usable_height
# # OR
# # (x+1)line_height + x*space_between_lines + 2*margin_size <= page_height

# trunc(usable_height / chunk_height)*chunk_height + line_height
# usable_height
trunc(page_height / chunk_height)*chunk_height + line_height
page_height

page_height - (trunc(page_height / chunk_height)*chunk_height + line_height)
page_height - (6*chunk_height + line_height)
page_height - (7*chunk_height + line_height)

page_height - 8*line_height - 7*space_between_lines #- 2*margin_size

margin_size_tb <- (page_height - 8*line_height - 7*space_between_lines) / 2
margin_size_lr <- margin_size


top_left_x_header <- margin_size_lr
top_left_y_header <- page_height - margin_size_tb

top_right_x_header <- page_width - margin_size_lr
top_right_y_header <- top_left_y_header

top_left_x_footer <- margin_size_lr
top_left_y_footer <- page_height - margin_size_tb - line_height

top_right_x_footer <- page_width - margin_size_lr
top_right_y_footer <- top_left_y_footer

top_left_x_middle <- margin_size_lr
top_left_y_middle <- page_height - margin_size_tb - line_height_half

top_right_x_middle <- page_width - margin_size_lr
top_right_y_middle <- top_left_y_middle


library(ggplot2)
library(grid)

?viewport







