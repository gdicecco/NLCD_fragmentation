# Calculate fragmentation measures for routes, all BCRS
# 2013

#### Libraries ####
library(raster)
library(sp)
library(rgdal)
library(rgeos)
library(dplyr)
library(stringr)
library(SDMTools)

# Read in BBS routes shapefile

# 2013
setwd("/proj/hurlbertlab/nlcd_landcover/NLCD_2013_Land_Cover_L48_20190424/")
nlcd <- raster("nlcd_2013_whole_simplified.tif")
routes <- readOGR("/proj/hurlbertlab/gdicecco/nlcd_frag_proj_shapefiles/BBS_routepaths/bbsroutes_5km_buffer.shp")
routes_tr <- spTransform(routes, crs(nlcd))

routenos <- routes_tr@data[ , 1]

setwd("/proj/hurlbertlab/gdicecco/nlcd_frag_proj_routes_simplified/")
for(i in 1:nrow(routes_tr@data)) {
  rte <- subset(routes_tr, rteno == routenos[i])
  rtenum <- routenos[i]
  nlcd_crop <- crop(nlcd, rte)
  nlcd_mask <- mask(nlcd_crop, rte)
  class <- ClassStat(nlcd_mask)
  filename <- paste0("classStat_nlcd_30x30_2013_route_", rtenum, ".csv")
  write.csv(class, filename, row.names = F)
}
