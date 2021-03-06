% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lucC_plot_raster_results.r
\docType{data}
\name{lucC_plot_raster_result}
\alias{lucC_plot_raster_result}
\title{Plot RasterBrick and Events over}
\usage{
lucC_plot_raster_result (raster_obj = NULL, data_mtx = NULL,
timeline = NULL, label = NULL, custom_palette = FALSE, RGB_color = NULL,
plot_ncol = 5, relabel = FALSE, original_labels = NULL, new_labels = NULL,
legend_text = "Legend:", columns_legend = 4, shape_point = 0,
colour_point = "black", size_point= 1)
}
\arguments{
\item{raster_obj}{Raster. A raster stack with classified images}

\item{data_mtx}{Matrix. A matrix with values obtained from predicates RECUR, EVOLVE, CONVERT or HOLDS}

\item{timeline}{Character. A list of all dates of classified raster, timeline}

\item{label}{Character. All labels of each value of pixel from classified raster}

\item{custom_palette}{Boolean. A TRUE or FALSE value. If TRUE, user will provide its own color palette setting! Default is FALSE}

\item{RGB_color}{Character. A vector with color names of original raster, same order. Default is setting scale_colour_hue}

\item{plot_ncol}{Numeric. A number of columns to show the maps. Default is 5}

\item{relabel}{Boolean. A TRUE or FALSE value. If TRUE, user will provide its own legend text setting! Default is FALSE}

\item{original_labels}{Character. A vector with original labels from legend text, for example, c("Forest","Pasture")}

\item{new_labels}{Character. A vector with new labels to legend text, for example, c("Mature_Forest","Pasture1")}

\item{legend_text}{Character. A text legend to show in plot. Default is "Legend:"}

\item{columns_legend}{Integer. A number with the desired number of columns in legend. Default is 4}

\item{shape_point}{Numeric or Character. Is a shape point for events highlighted over map. Default is 0.
This includes different points symbols commonly used in R as "pch", such as numeric values like 0 to square, 1 to circle
and 4 to cross shape. And also other characters can be used including ".", "+", "*", "-", "#".}

\item{colour_point}{Numeric. Is a colour for the shape point for events highlighted over map. Default is black}

\item{size_point}{Numeric. Is a size of the shape point around pixels in plot. Default is 1}
}
\value{
Plot with input data as colored map
}
\description{
Plot map ggplot2 for all events discovered in input data
}
\examples{
\dontrun{


lucC_plot_raster_result(raster_obj = rb_sits, data_mtx = b,
timeline = timeline, label = label, custom_palette = TRUE,
RGB_color = colors_1, relabel = FALSE)

}

}
\author{
Adeline M. Maciel
}
\keyword{datasets}
