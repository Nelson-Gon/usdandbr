# usdandbr

[![Build Status](https://travis-ci.org/Nelson-Gon/usdandbr.svg?branch=master)](https://travis-ci.org/Nelson-Gon/usdandbr)


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

**Sources**
1. U.S. Department of Agriculture, Agricultural Research Service. 20xx. USDA National Nutrient Database for Standard Reference, Release . Nutrient Data Laboratory Home Page, http://www.ars.usda.gov/nutrientdata

2. U.S. Department of Agriculture, Agricultural Research Service. 20xx. USDA Branded Food Products Database . Nutrient Data Laboratory Home Page, http://ndb.nal.usda.gov

3. Jay, J., Sanders, A., Reid, R. and Brouwer, C. (2018). Connecting nutrition composition measures to biomedical research. BMC Research Notes, 11(1).  [link](https://link.springer.com/article/10.1186%2Fs13104-018-3997-y)

**If you have got this far, thank you and please provide feedback on what works and what doesn't.**

**Thank you and Happy Coding.**

>Nutrition for all.
