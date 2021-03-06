library(lucCalculus)

options(digits = 12)

# all files in folder
#all.the.files <- list.files("~/TESTE/MT/MT_SecVeg", full=TRUE, pattern = ".tif")
all.the.files <- list.files("~/TESTE/MT/MT_SecCerrado", full=TRUE, pattern = ".tif")
all.the.files

#-------------
# # #Carrega os pacotes necessários para realizar o paralelismo
# library(foreach)
# #
# # #Checa quantos núcleos existem
# ncl <- parallel::detectCores()-10
# ncl
# #Registra os clusters a serem utilizados
# cl <- parallel::makeCluster(ncl) #ncl
# doParallel::registerDoParallel(2)
# foreach::getDoParWorkers()
#-------------

# start time
start.time <- Sys.time()

number_Pas_Soy <- list()
#for_sv.tb <- NULL

#for_sv.tb <- foreach(i = 1:length(all.the.files), .combine=rbind, .packages= c("lucCalculus")) %dopar%  {
for (i in 1:length(all.the.files)) {
  # file
  file <- all.the.files[i]

  # create timeline with classified data from SVM method
  timeline <- lubridate::as_date(c("2001-09-01", "2002-09-01", "2003-09-01", "2005-09-01", "2006-09-01", "2007-09-01", "2008-09-01", "2009-09-01", "2010-09-01", "2011-09-01", "2012-09-01", "2013-09-01", "2014-09-01", "2015-09-01", "2016-09-01"))

  file_name <- basename(tools::file_path_sans_ext(file))

  # library(sits)
  # create a RasterBrick metadata file based on the information about the files
  raster.tb <- sits::sits_coverage(service = "RASTER", name = file_name, timeline = timeline, bands = "ndvi", files = file)

  message("\n--------------------------------------------------\n")
  message(paste0("Load RasterBrick! Name: ", raster.tb$name, " ...\n", sep = ""))

  # new variable with raster object
  rb_sits <- raster.tb$r_objs[[1]][[1]]

  # ------------- define variables to plot raster -------------
  # original label - see QML file, same order
  # label2 <- as.character(c("Cerrado", "Fallow_Cotton", "Forest", "Pasture", "Soy_Corn", "Soy_Cotton", "Soy_Fallow", "Soy_Millet", "Soy_Sunflower", "Sugarcane", "Urban_Area", "Water", "Secondary_Vegetation"))
  label2 <- as.character(c("Cerrado", "Fallow_Cotton", "Forest", "Pasture", "Soy", "Soy", "Soy", "Soy", "Soy", "Sugarcane", "Urban_Area", "Water", "Secondary_Vegetation", "Degradation", "Secondary_Cerrado"))

  # original colors set - see QML file, same order
  # colors_2 <- c("#b3cc33", "#8ddbec", "#228b22", "#afe3c8", "#b6a896", "#e1cdb6", "#e5c6a0", "#b69872", "#b68549", "#dec000", "#cc18b4", "#0000f1", "red" )

  file_name <- basename(tools::file_path_sans_ext(file))

  message("Start Soy holds ...\n")
  # secondary and forest
  secondary.mtx <- lucC_pred_holds(raster_obj = rb_sits, raster_class = "Soy",
                                   time_interval = c("2001-09-01","2016-09-01"),
                                   relation_interval = "contains", label = label2, timeline = timeline)
  #head(secondary.mtx)

  message("Start Pasture holds ...\n")
  forest.mtx <- lucC_pred_holds(raster_obj = rb_sits, raster_class = "Pasture",
                                time_interval = c("2001-09-01","2016-09-01"),
                                relation_interval = "contains", label = label2, timeline = timeline)
  #head(forest.mtx)

  message("Merge Pasture and Soy ...\n")
  Forest_secondary.mtx <- lucC_merge(secondary.mtx, forest.mtx)
  #head(Forest_secondary.mtx)

  number_Pas_Soy[[i]] <- Forest_secondary.mtx

  message("Save image in provided path ...\n")
  # save result of secondary vegetation

  message("Prepare image 1 ...\n")
  lucC_save_raster_result(raster_obj = rb_sits, data_mtx = Forest_secondary.mtx, timeline = timeline, label = label2, path_raster_folder = paste0("~/TESTE/MT/HoldsPastureSoy/", file_name, sep = ""), as_RasterBrick = TRUE)

  message("Prepare image 2 ...\n")
  lucC_save_raster_result(raster_obj = rb_sits, data_mtx = Forest_secondary.mtx, timeline = timeline, label = label2, path_raster_folder = paste0("~/TESTE/MT/HoldsPastureSoy/", file_name, sep = ""), as_RasterBrick = FALSE)



  # clear environment, except these elements
  rm(list=ls()[!(ls() %in% c('all.the.files', "start.time", "end.time", "number_Pas_Soy", "i"))])
  gc()
  gc()

  message("--------------------------------------------------\n")
}

message("Save data as list in .rda file ...\n")
#save to rda file
save(number_Pas_Soy, file = "~/TESTE/MT/HoldsPastureSoy/number_Pas_Soy.rda")

# #Stop clusters
# parallel::stopCluster(cl)

# end time
print(Sys.time() - start.time)

rm(number_Pas_Soy)
gc()

#----------------------------------------------------
# Save results as measures
#----------------------------------------------------


# start time
start.time <- Sys.time()


load(file = "~/TESTE/MT/HoldsPastureSoy/number_Pas_Soy.rda")

output_freq <- lucC_extract_frequency(data_mtx.list = number_Pas_Soy, cores_in_parallel = 6)
#output_freq

#----------------------
# # plot results
# lucC_plot_bar_events(data_frequency = output_freq,
#                      pixel_resolution = 231.656, custom_palette = FALSE, side_by_side = TRUE)
#
# lucC_plot_frequency_events(data_frequency = output_freq,
#                      pixel_resolution = 231.656, custom_palette = FALSE)

# Compute values
measuresPas_Soy <- lucC_result_measures(data_frequency = output_freq, pixel_resolution = 231.656)
measuresPas_Soy

write.table(x = measuresPas_Soy, file = "~/TESTE/MT/HoldsPastureSoy/measuresPas_Soy.csv", quote = FALSE, sep = ";", row.names = FALSE)

save(measuresPas_Soy, file = "~/TESTE/MT/HoldsPastureSoy/measuresPas_Soy.rda")


# end time
print(Sys.time() - start.time)



#----------------------------------------------------
# Merge all blocks and then generate image exit for each band
#----------------------------------------------------

library(lucCalculus)

options(digits = 12)

# start time
start.time <- Sys.time()

# merge blocks into a single image
lucC_merge_rasters(path_open_GeoTIFFs = "~/TESTE/MT/HoldsPastureSoy/All_blocks_Pas_Soy", number_raster = 4, pattern_name = "New_New_New_Raster_Splitted_", is.rasterBrick = TRUE)
# save each layer of brick as images
lucC_save_rasterBrick_layers(path_name_GeoTIFF_Brick = "~/TESTE/MT/HoldsPastureSoy/All_blocks_Pas_Soy/Mosaic_New_New_New_Raster_Splitted_.tif")


# end time
print(Sys.time() - start.time)

