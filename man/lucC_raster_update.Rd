% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/lucC_update_raster.R
\docType{data}
\name{lucC_raster_update}
\alias{lucC_raster_update}
\title{Update a RasterBrick with pixel replaced}
\usage{
lucC_raster_update(raster_obj = NULL, data_mtx = NULL,
timeline = NULL, class_to_replace = NULL, new_pixel_value = 20)
}
\arguments{
\item{raster_obj}{Raster. A raster stack with classified images}

\item{data_mtx}{Matrix. A matrix with values obtained from predicates RECUR, EVOLVE, CONVERT or HOLDS}

\item{timeline}{Character. A list of all dates of classified raster, timeline}

\item{class_to_replace}{Character. All labels of each value of pixel from classified raster}

\item{new_pixel_value}{Integer. New pixel value to raster. Default is 20}
}
\value{
Matrix with raster and new pixel to create a RasterBrick reclassified
}
\description{
Update a RasterBrick with new values of pixel discovered from LUC Calculus formalism
}
\examples{
\dontrun{

rb_new <- lucC_raster_update(raster_obj = rb_sits, data_mtx = third_raster.df,
timeline = timeline, class_to_replace = "Forest", new_pixel_value = 6)
rb_new

}

}
\author{
Adeline M. Maciel
}
\keyword{datasets}
