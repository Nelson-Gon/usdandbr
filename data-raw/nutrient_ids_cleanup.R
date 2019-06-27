# The following illustrates the code used to generate nutrient_ids_clean
# The data is from the following files:
# https://figshare.com/articles/PubChem_CID_to_USDA_NDB_mappings/7033217
# Once the data is available, read  `mesh2ndb.missing.csv` as follows.

nutrient_ids_ext <- read.csv("mesh2ndb.missing.csv")

# Further processing is done as shown below. 
nutrient_ids_clean <- rbind(nutrient_ids[,-c(1,4)],
      nutrient_ids_ext[-which(nutrient_ids_ext$NDB.ID %in%
                                nutrient_ids$NDB.ID)])

