# usdandbr

[![Build Status](https://travis-ci.org/Nelson-Gon/usdandbr.svg?branch=master)](https://travis-ci.org/Nelson-Gon/usdandbr)   [![license](https://img.shields.io/badge/license-GPL--2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.html)
[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)


**Access and retrieve data from the USDA Nutrient Data Base.**


**Version: 0.1.0**

The goal is to ease access to the USDA NDB data base in the hope that this will enable researchers looking to study the effects of different feeding behavior(s) on an individual's life and/or aid education of the masses on the importance of proper nutrition.



**Installing the Package**

```
devtools::install_github("Nelson-Gon/usdandbr")

```

**Loading the package**

```

library(usdandbr)

```

## Sample usage:


# **Food Reports**
The main function of this package is `get_nutrients` that can be used as follows:

```
res<-get_nutrients(nutrients = "204",api_key ="api_key_here", 
subset = 0,ndbno =NULL,
max_rows = NULL,
food_group = NULL,
offset = 0,result_type = "json")

```

To easily get a `nutrient_id`(ie nutrients in `get_nutrients` above), one can obtain nutrients as shown below:

```
data(nutrient_ids)
get_nutrient_id("caffeine",nutrient_ids)

#[1] 262

```
For more `nutrient_ids`, please use the data set `nutrient_ids` clean. The clean up process is shown in `nutrient_ids_cleanup` based on data provided by [Jay et al.,2018](https://link.springer.com/article/10.1186%2Fs13104-018-3997-y)


The result of `get_nutrients` is a list of unprocessed `JSON` and semi_processed data that can be obtained as follows:

**1. Unprocessed JSON**
  ```
  res[[1]]
  
  ```

**2. Semi_Processed Data**

```
res[[2]]



```

To get any form of information from the report, one could use `get_report_info` as shown here:

```
get_report_info("name", res)

```

The above would return a list with all food names.


To get a `pretty_json` output, one can use `pretty_json` on the above results as follows:

```
pretty_json(res)

```



To obtain a semi-processed `data.frame` object, use `get_nutrient_info` as shown here. This extracts the first list in the nested list(list of lists).

```
get_nutrient_info(res)[[1]]
         Name             Value
1 nutrient_id               204
2    nutrient Total lipid (fat)
3        unit                 g
4       value              0.11
5          gm               0.1

```

If `xml` was requested in `get_nutrients`, `pretty_xml` can be used to further process the data. For more details on usage, please see `help(pretty_xml)`. For example if we requested `xml`, we could do:

```
pretty_xml(res,"food",target = "name")

```

The above would return a list of lists with the nutrient data base number, name, weigth and measure. 

## **Lists**

To get lists from the database, we can use `get_lists` as follows:

```
res <- get_list(api_key = my_key,list_type = "ns",
                sort_by = "id",max_items = 50,
                offset = 12,format = "xml")
        
```

The above will allow us to obtain a list of speciality nutrients(`ns`) sorted by id. Depending on the format requested, the results can then be further processed as follows:

```
res
usdandbr::pretty_xml(res,tag="name")
usdandbr::pretty_json(res)

```


For more information about any of these functions, please take a look at `?function_name` or see detailed information for the package in `help(package="usdandbr")`. For issues, feature requests and/or contributions, please raise an issue at [usdandbr](https://www.github.com/Nelson-Gon/usdandbr).



**Sources**
1.US Department of Agriculture, Agricultural Research Service, Nutrient Data Laboratory. USDA National Nutrient Database for Standard Reference, Release 28. Version Current:  September 2015.  Internet:  /nea/bhnrc/ndl

2. US Department of Agriculture, Agricultural Research Service, Nutrient Data Laboratory. USDA National Nutrient Database for Standard Reference, Release 28. Version Current:  September 2015.  Internet:  /nea/bhnrc/ndl

3. Jay, J., Sanders, A., Reid, R. and Brouwer, C. (2018). Connecting nutrition composition measures to biomedical research. BMC Research Notes, 11(1).  [link](https://link.springer.com/article/10.1186%2Fs13104-018-3997-y)

4. USDA Food Reports Data Base(Version 2) https://ndb.nal.usda.gov/ndb/doc/apilist/API-FOOD-REPORT.md


**If you have got this far, thank you and please provide feedback on what works and what doesn't.**

**Thank you and Happy Coding.**

>Nutrition for all.
