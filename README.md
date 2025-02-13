# usdar

[![Build Status](https://travis-ci.org/Nelson-Gon/usdar.svg?branch=master)](https://travis-ci.org/Nelson-Gon/usdar)   [![license](https://img.shields.io/badge/license-GPL--2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![lifecycle](https://img.shields.io/badge/lifecycle-retired-orange.svg)](https://www.tidyverse.org/lifecycle/#retired)

---
# **IMPORTANT NOTICE**

This repository is no longer being maintained because the API it references is slated for End of Life. Instead, please use one of the following alternative packages(by the same author):

1. `pyfdc` that can be accessed [here](https://github.com/Nelson-Gon/pyfdc)

This is written in python and hence only supports python.

2. `rfdc` accessible [here](https://github.com/Nelson-Gon/rfdc)

This is meant to serve as the direct R replacement of `usdar` although it does differ in several ways from `usdar` due to differences in the APIs used.

>Thank you for having used `usdar` and for reading this far.


---



**Access and retrieve data from the USDA Nutrient Data Base.**


**Version: 0.1.0**

The goal is to ease access to the USDA NDB data base in the hope that this will enable researchers looking to study the effects of different feeding behavior(s) on an individual's life and/or aid education of the masses on the importance of proper nutrition.



**Installing the Package**

```
devtools::install_github("Nelson-Gon/usdar")

```

**Loading the package**

```

library(usdar)

```

## Sample usage:

**Setting an API_key for a session**

```
set_apikey("my_key")

```

If the above is not set, a user can manually set the key on each call of a function by passing the key to the parameter 
that holds the `api_key` as per a function's documentation. 

**Nutrient Reports**
The main function of this package is `get_nutrients` that can be used as follows:

```
res<-get_nutrients(nutrients = c("204","510"))

# MUltiple food groups
res2 <- get_nutrients(nutrients=c("204","205"),
              result_type="json",
              offset = 25,
              max_rows = 50,
              food_group = c("0500","0100"))
```

To get some specific output from the above result, we can use `get_report_info`. To get the names for instance:

```
# get only first item from the list
 get_report_info("name", res)[[1]][1]
#[1] "APPLEBEE'S, mozzarella sticks"

```

To easily get a `nutrient_id`(ie nutrients in `get_nutrients` above), one can obtain nutrients as shown below. If no data set name is provided, the default is to use `nutrient_ids` that is part of the package.

```
get_nutrient_id("myr")
#[1] 788
get_nutrient_id("caff")
#[1] 262
```
For more `nutrient_ids`, please use the data set `nutrient_ids` clean. The clean up process is shown in `nutrient_ids_cleanup` based on data provided by [Jay et al.,2018](https://link.springer.com/article/10.1186%2Fs13104-018-3997-y)


The result of `get_nutrients` is a list of unprocessed `JSON` and semi_processed data that can be obtained as follows:

**1. Unprocessed JSON** : 

```

res[[1]] 


```

**2. Semi_Processed Data** : 

```
res[[2]]

```

When `json` data is requested, a prettier output can be obtained with `get_nutrient_info` as shown here:

```
# Using res above
# Uses defaults, returns abbreviated data since
# abbr is set to TRUE.
  head(get_nutrient_info(res))
      Name ndbno  ID          Nutrient Weight Unit Value
1 APPLEBEE'S, mo 36004 510            Valine     32    g 0.365
2 Apples, canned 09008 204 Total lipid (fat)    204    g  5.88
3 Apples, dehydr 09010 510            Valine    193    g 0.016
4 Apples, dehydr 09009 204 Total lipid (fat)     60    g  0.88
5 Apples, dried, 09013 510            Valine    280    g 0.025
6 Apples, dried, 09012 204 Total lipid (fat)    255    g  0.23
         Measure     Gm
1      1.0 piece  1.140
2 1.0 cup slices 18.370
3        1.0 cup  0.008
4        1.0 cup  0.430
5        1.0 cup  0.013
6        1.0 cup  0.120

```


The above returns an object with the source(Name) abbreviated. One can override this by setting `abbr` to `FALSE`.


```
result<-get_nutrient_info(res, abbr=FALSE)
head(result[,1])
[1] "APPLEBEE'S, mozzarella sticks"                        
[2] "Apples, canned, sweetened, sliced, drained, heated"   
[3] "Apples, dehydrated (low moisture), sulfured, stewed"  
[4] "Apples, dehydrated (low moisture), sulfured, uncooked"
[5] "Apples, dried, sulfured, stewed, with added sugar"    
[6] "Apples, dried, sulfured, stewed, without added sugar"
```
If `xml` was requested in `get_nutrients`, `pretty_xml` can be used to further process the data. For more details on usage, please see `help(pretty_xml)`. For example if we requested `xml`, we could do:

```
res2 <- get_nutrients(nutrients=c("204","205"),
              result_type="xml",
              offset = 25,
              max_rows = 50,
              food_group = c("0500","0100"),
              ndbno = "01009")

pretty_xml(res2,"food",target = "name")

```

The above would return a list of lists with the nutrient data base number, name, weight and measure. 

## **Lists**

To get lists from the database, we can use `get_lists` as follows:

```
res3 <- get_list(list_type = "ns",
                sort_by = "id",max_items = 50,
                offset = 12,format = "json")
                

head(res3$list$item)

offset  id              name
1      0 710          Daidzein
2      1 711         Genistein
3      2 712         Glycitein
4      3 713 Total isoflavones
5      4 714       Biochanin A
6      5 715      Formononetin
                
  
        
```

The above will allow us to obtain a list of speciality nutrients(`ns`) sorted by id. The above result is also useful if one would like to quickly get Nutrient IDs if they are not available in the data sets via `get_nutrient_id`.

Depending on the format requested, the results can then be further processed as follows:

```
usdar::pretty_xml(res2,tag="name")
usdar::pretty_json(res3)

```

### **Plain Text Search**

To use plain text to search the database, we can use `db_search` as follows:

```
#' # sorted by name
 res<-db_search(result_type = "json",search_term = "Acerola",
 sort_by = "n")
 # Get manufacturers
 res[[1]]$item["manu"]
#                           manu
#1                          none
#2                          none
#3 Sourdough:  A European Bakery
#4   BOWMAN ANDROS PRODUCTS, LLC

 res<-db_search(result_type = "xml",search_term = "Acerola", sort_by = "r")
#' #process xml
pretty_xml(res, tag="name")

#{xml_nodeset (4)}
#[1] <name>Acerola juice, raw</name>
#[2] <name>Acerola, (west indian cherry), raw</name>
#[3] <name>WHOLE FOODS MARKET, SUPER STARS, ALL NATURAL #FLAVORS  ...
#[4] <name>FRUIT ME UP!, BOOST, BLENDED FRUIT SAUCE, #BLUEBERRY,  

 
  ```

For more information about any of these functions, please take a look at `?function_name` or see detailed information for the package in `help(package="usdar")`. 

**For issues, feature requests and/or contributions, please raise an issue at [usdar](https://www.github.com/Nelson-Gon/usdar/issues).**



**Sources**

1. US Department of Agriculture, Agricultural Research Service, Nutrient Data Laboratory. USDA National Nutrient Database for Standard Reference, Release 28. Version Current: September 2015.  Internet:  /nea/bhnrc/ndl

2. US Department of Agriculture, Agricultural Research Service, Nutrient Data Laboratory. USDA National Nutrient Database for Standard Reference, Release 28. Version Current:  September 2015.  Internet:  /nea/bhnrc/ndl

3. Jay, J., Sanders, A., Reid, R. and Brouwer, C. (2018). Connecting nutrition composition measures to biomedical research. BMC Research Notes, 11(1).  [link](https://link.springer.com/article/10.1186%2Fs13104-018-3997-y)

4. USDA Food Reports Data Base[Version 2](https://ndb.nal.usda.gov/ndb/doc/apilist/API-FOOD-REPORT.md)


**If you have got this far, thank you and please provide feedback on what works and what doesn't.**

**Thank you and Happy Coding.**

>Nutrition for all.
