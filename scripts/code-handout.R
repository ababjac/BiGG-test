# temporarily load RSQLite so that the version shows in sessionInfo()
library(RSQLite)
library(tidyverse)
library(hexbin)
detach(package:RSQLite, unload=TRUE)

######################### INTRO TO R ##############################


### Creating objects in R

### Challenge
##
## What are the values after each statement in the following?
##
## mass <- 47.5            # mass?
(mass <- 47.5)
## age  <- 122             # age?
(age <- 122)
## mass <- mass * 2.0      # mass?
(mass <- mass * 2.0)
## age  <- age - 20        # age?
(age <-  age - 20)
## mass_index <- mass/age  # mass_index?
(mass_index <- mass/age)



### Vectors and data types

## ## We’ve seen that atomic vectors can be of type character, numeric, integer, and
## ## logical. But what happens if we try to mix these types in a single
## ## vector?
print("R will implicitly type cast objects while trying to avoid losing information.")

## ## What will happen in each of these examples? (hint: use `class()` to
## ## check the data type of your object)
num_char <- c(1, 2, 3, "a")
print(class(num_char))

num_logical <- c(1, 2, 3, TRUE)
print(class(num_logical))

char_logical <- c("a", "b", "c", TRUE)
print(class(char_logical))

tricky <- c(1, 2, 3, "4")
print(class(tricky))

## 
## ## Why do you think it happens?
print("vectors can only contain a single data type")
## 
## 
## ## How many values in `combined_logical` are `"TRUE"` (as a character) in the
## ## following example:
combined_logical <- c(num_logical, char_logical)
print(length(subset(combined_logical, combined_logical == "TRUE")))
## 
## ## You've probably noticed that objects of different types get
## ## converted into a single, shared type within a vector. In R, we call
## ## converting objects from one class into another class
## ## _coercion_. These conversions happen according to a hierarchy,
## ## whereby some types get preferentially coerced into other types. Can
## ## you draw a diagram that represents the hierarchy of how these data
## ## types are coerced?
print("logical becomes character/numeric, numeric becomes character")

### Challenge (optional)
##
## * Can you figure out why `"four" > "five"` returns `TRUE`?
print("Strings are compared alphabetically")


## ### Challenge
heights <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63, 63, NA, 72, 65, 64, 70, 63, 65)

# 1. Using this vector of heights in inches, create a new vector with the NAs removed.
heights_no_na <- heights[!is.na(heights)] 
# or
heights_no_na <- na.omit(heights)
# or
heights_no_na <- heights[complete.cases(heights)]

# 2. Use the function `median()` to calculate the median of the `heights` vector.
median(heights, na.rm = TRUE)

# 3. Use R to figure out how many people in the set are taller than 67 inches.
heights_above_67 <- heights_no_na[heights_no_na > 67]
length(heights_above_67)


######################### STARTING WITH DATA #############################


### Loading the survey data

download.file(url = "https://ndownloader.figshare.com/files/2292169",
               destfile = "data/raw/portal_data_joined.csv")
surveys <- read_csv("data/raw/portal_data_joined.csv")

## Challenge
## Based on the output of `str(surveys)`, can you answer the following questions?
str(surveys)

## * What is the class of the object `surveys`?
print(class(surveys))
## * How many rows and how many columns are in this object?
print(nrow(surveys))
print(ncol(surveys))


## Indexing and subsetting data frames

### Challenges:
###
### 1. Create a `data.frame` (`surveys_200`) containing only the
###    data in row 200 of the `surveys` dataset.
surveys_200 <- surveys[200, ]

### 2. Notice how `nrow()` gave you the number of rows in a `data.frame`?
###
###      * Use that number to pull out just that last row in the data frame
###      * Compare that with what you see as the last row using `tail()` to make
###        sure it's meeting expectations.
###      * Pull out that last row using `nrow()` instead of the row number
###      * Create a new data frame object (`surveys_last`) from that last row
surveys_last <- surveys[nrow(surveys), ]
tail(surveys, 1)

### 3. Use `nrow()` to extract the row that is in the middle of the
###    data frame. Store the content of this row in an object named
###    `surveys_middle`.
surveys_middle <- surveys[nrow(surveys)/2, ]

### 4. Combine `nrow()` with the `-` notation above to reproduce the behavior of
###    `head(surveys)`, keeping just the first through 6th rows of the surveys
###    dataset.
surveys_head <- surveys[-(7:nrow(surveys)), ]



### Factors
sex <- factor(c("male", "female", "female", "male"))

### Challenges:
###
### 1. Change the columns `taxa` and `genus` in the `surveys` data frame into a 
###    factor.
surveys$taxa <- factor(surveys$taxa)
surveys$genus <- factor(surveys$genus)

###
### 2. Using the functions you learned before, can you find out...
###
###      * How many rabbits were observed?
summary(surveys$taxa)
###      * How many different genera are in the `genus` column?
nlevels(surveys$genus)


#Converting Data
year_fct <- factor(c(1990, 1983, 1977, 1998, 1990))
as.numeric(year_fct)               # Wrong! And there is no warning...
as.numeric(as.character(year_fct)) # Works...
as.numeric(levels(year_fct))[year_fct]    # The recommended way.

## bar plot of the number of females and males captured during the experiment:
surveys$sex <- factor(surveys$sex)
plot(surveys$sex)

surveys$sex <- addNA(surveys$sex)
levels(surveys$sex)[3] <- "NA"
plot(surveys$sex)

## Challenges
##
## * Rename "F" and "M" to "female" and "male" respectively.
levels(surveys$sex) <- c('male', 'female', 'undetermined')
## * Now that we have renamed the factor level to "undetermined", can you recreate the
##   barplot such that "undetermined" is first (before "female")
surveys$sex <- factor(surveys$sex, levels = c("undetermined", "female", "male"))
plot(surveys$sex)



## ## Challenge:
## ##  There are a few mistakes in this hand-crafted `data.frame`,
## ##  can you spot and fix them? Don't hesitate to experiment!
animal_data <- data.frame(
      animal = c("dog", "cat", "sea cucumber", "sea urchin"),
      feel = c("furry", "furry", "squishy", "spiny"),
      weight = c(45, 8, 1.1, 0.8)
      )

## ## Challenge:

country_climate <- data.frame(country = c("Canada", "Panama", "South Africa", "Australia"),
                               climate = c("cold", "hot", "temperate", "hot/temperate"),
                               temperature = c(10, 30, 18, "15"),
                               northern_hemisphere = c(TRUE, TRUE, FALSE, "FALSE"),
                               has_kangaroo = c(FALSE, FALSE, FALSE, 1))
## ##   Can you predict the class for each of the columns in the following
## ##   example?
str(country_climate)
## ##   Check your guesses using `str(country_climate)`:
## ##   * Are they what you expected? Why? why not?
print("They are implicitly cast wrong to strings due to data type errors")
## ##   * What would you need to change to ensure that each column had the
## ##     accurate data type?
country_climate <- data.frame(country = c("Canada", "Panama", "South Africa", "Australia"),
                              climate = c("cold", "hot", "temperate", "hot/temperate"),
                              temperature = c(10, 30, 18, 15),
                              northern_hemisphere = c(TRUE, TRUE, FALSE, FALSE),
                              has_kangaroo = c(FALSE, FALSE, FALSE, TRUE))



######################### MANIPULATING DATA IN R #########################

## ## Pipes Challenge:
## ##  Using pipes, subset the data to include animals collected
## ##  before 1995, and retain the columns `year`, `sex`, and `weight.`
pipes <- surveys %>% 
  filter(year < 1995) %>% 
  select(year, sex, weight)

## ## Mutate Challenge:
## ##  Create a new data frame from the `surveys` data that meets the following
## ##  criteria: contains only the `species_id` column and a new column called
## ##  `hindfoot_cm` containing the `hindfoot_length` values converted to centimeters.
## ##  In this `hindfoot_cm` column, there are no `NA`s and all values are less
## ##  than 3.
## 
## ##  Hint: think about how the commands should be ordered to produce this data frame!
mutate <- surveys %>%
  filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_cm = hindfoot_length / 10) %>%
  filter(hindfoot_cm < 3) %>%
  select(species_id, hindfoot_cm)

## ## Count Challenges:
## ##  1. How many animals were caught in each `plot_type` surveyed?
## 
surveys %>% 
  count(plot_type)
## ##  2. Use `group_by()` and `summarize()` to find the mean, min, and max
## ## hindfoot length for each species (using `species_id`). Also add the number of
## ## observations (hint: see `?n`).
## 
surveys %>% 
  group_by(species_id) %>% 
  summarize(mean_hl = mean(hindfoot_length),
            min_hl = min(hindfoot_length),
            maz_hl = max(hindfoot_length),
            n = n()
            )

## ##  3. What was the heaviest animal measured in each year? Return the
## ##  columns `year`, `genus`, `species_id`, and `weight`.
surveys %>% 
  group_by(year) %>% 
  filter(weight == max(weight)) %>% 
  select(year, genus, species_id, weight)

## ## Reshaping challenges
## 
## ## 1. Spread the `surveys` data frame with `year` as columns, `plot_id` as rows, and the number of genera per plot as the values. You will need to summarize before reshaping, and use the function `n_distinct()` to get the number of unique genera within a particular chunk of data. It's a powerful function! See `?n_distinct` for more.
## 
s_surveys <- surveys %>%
  group_by(plot_id, year) %>%
  summarize(n_genera = n_distinct(genus)) %>%
  spread(year, n_genera)
## ## 2. Now take that data frame and `gather()` it again, so each row is a unique `plot_id` by `year` combination.
## 
g_surveys <- spread_surveys %>% 
  gather("year", "n_genera", -plot_id)
## ## 3. The `surveys` data set has two measurement columns: `hindfoot_length` and `weight`. This makes it difficult to do things like look at the relationship between mean values of each measurement per year in different plot types. Let's walk through a common solution for this type of problem. First, use `gather()` to create a dataset where we have a key column called `measurement` and a `value` column that takes on the value of either `hindfoot_length` or `weight`. *Hint*: You'll need to specify which columns are being gathered.
##
gathered_surveys <- surveys %>%
  gather("measurement", "value", hindfoot_length, weight)
## ## 4. With this new data set, calculate the average of each `measurement` in each `year` for each different `plot_type`. Then `spread()` them into a data set with a column for `hindfoot_length` and `weight`. *Hint*: You only need to specify the key and value columns for `spread()`.
spread_surveys <- gathered_surveys %>% 
  group_by(year, measurement, plot_type) %>% 
  summarize(measurement_mean = mean(measurement)) %>% 
  spread(measurement, measurement_mean)



######################## VISUALIZING DATA IN R #############################

## ### Create the dataset for exporting:
## ##  Start by removing observations for which the `species_id`, `weight`,
## ##  `hindfoot_length`, or `sex` data are missing:
surveys_complete <- surveys %>%
    filter(species_id != "",        # remove missing species_id
           !is.na(weight),                 # remove missing weight
           !is.na(hindfoot_length),        # remove missing hindfoot_length
           sex != "")                      # remove missing sex
## 
## ##  Now remove rare species in two steps. First, make a list of species which
## ##  appear at least 50 times in our dataset:
species_counts <- surveys_complete %>%
    count(species_id) %>%
    filter(n >= 50) %>%
    select(species_id)
## 
## ##  Second, keep only those species:
surveys_complete <- surveys_complete %>%
    filter(species_id %in% species_counts$species_id)



### Data Visualization with ggplot2

## install.packages("hexbin")
## library(hexbin)

## surveys_plot +
##  geom_hex()

## ### Challenge with hexbin
## ##
## ## To use the hexagonal binning with **`ggplot2`**, first install the `hexbin`
## ## package from CRAN:
## 
## install.packages("hexbin")
## library(hexbin)
## 

surveys_plot <- ggplot(data = surveys_complete, 
                       mapping = aes(x = weight, y = hindfoot_length))
## ## Then use the `geom_hex()` function:
## 
surveys_plot +
    geom_hex()
## 
## ## What are the relative strengths and weaknesses of a hexagonal bin
## ## plot compared to a scatter plot?
print("Can be harder to interpret but shows more information")


## ### Challenge with scatter plot:
## ##
## ##  Use what you just learned to create a scatter plot of `weight`
## ## over `species_id` with the plot types showing in different colors.
## ## Is this a good way to show this type of data?
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_point(alpha = 0.5, aes(color = plot_type))


## ## Challenge with boxplots:
## ##  Start with the boxplot we created:
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_jitter(alpha = 0.3, color = "tomato")
## 
## ##  1. Replace the box plot with a violin plot; see `geom_violin()`.
## 
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  geom_boxplot(alpha = 0) +
  geom_violin(alpha = 0.5)
## ##  2. Represent weight on the log10 scale; see `scale_y_log10()`.
## 
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = weight)) +
  scale_y_log10("weight") +
  geom_boxplot(alpha = 0) +
  geom_violin(alpha = 0.5)
## ##  3. Create boxplot for `hindfoot_length` overlaid on a jitter layer.
ggplot(data = surveys_complete, mapping = aes(x = species_id, y = hindfoot_length)) +
  geom_jitter(alpha = 0.1, aes(color = plot_id)) +
  geom_boxplot(alpha = 0)
## ##  4. Add color to the data points on your boxplot according to the
## ##  plot from which the sample was taken (`plot_id`).
## ##  *Hint:* Check the class for `plot_id`. Consider changing the class
## ##  of `plot_id` from integer to factor. Why does this change how R
## ##  makes the graph?
## SEE Q3


## ### Plotting time series challenge:
## ##
## ##  Use what you just learned to create a plot that depicts how the
## ##  average weight of each species changes through the years.
## 
groups <- surveys_complete %>% 
  group_by(year, species_id) %>% 
  summarize(avg_w = mean(weight))

ggplot(data = groups, mapping = aes(x = year, y = avg_w)) +
  geom_line() +
  facet_wrap(vars(species_id))

## install.packages("patchwork")

## ### Final plotting challenge:
## ##  With all of this information in hand, please take another five
## ##  minutes to either improve one of the plots generated in this
## ##  exercise or create a beautiful graph of your own. Use the RStudio
## ##  ggplot2 cheat sheet for inspiration:
## ##  https://www.rstudio.com/wp-content/uploads/2015/08/ggplot2-cheatsheet.pdf
## SQL databases and R

## install.packages(c("dbplyr", "RSQLite"))



#################### R AND SQL #########################

library(dplyr)
library(dbplyr)
mammals <- DBI::dbConnect(RSQLite::SQLite(), "data_raw/portal_mammals.sqlite")

src_dbi(mammals)

tbl(mammals, sql("SELECT year, species_id, plot_id FROM surveys"))

surveys <- tbl(mammals, "surveys")
surveys %>%
    select(year, species_id, plot_id)



















## with dplyr syntax
species <- tbl(mammals, "species")

left_join(surveys, species) %>%
  filter(taxa == "Rodent") %>%
  group_by(taxa, year) %>%
  tally %>%
  collect()

## with SQL syntax
query <- paste("
SELECT a.year, b.taxa,count(*) as count
FROM surveys a
JOIN species b
ON a.species_id = b.species_id
AND b.taxa = 'Rodent'
GROUP BY a.year, b.taxa",
sep = "" )

tbl(mammals, sql(query))



### Challenge
## Write a query that returns the number of rodents observed in each
## plot in each year.

##  Hint: Connect to the species table and write a query that joins
##  the species and survey tables together to exclude all
##  non-rodents. The query should return counts of rodents by year.

## Optional: Write a query in SQL that will produce the same
## result. You can join multiple tables together using the following
## syntax where foreign key refers to your unique id (e.g.,
## `species_id`):

## SELECT table.col, table.col
## FROM table1 JOIN table2
## ON table1.key = table2.key
## JOIN table3 ON table2.key = table3.key


## species <- tbl(mammals, "species")
## genus_counts <- left_join(surveys, plots) %>%
##   left_join(species) %>%
##   filter(taxa == "Rodent") %>%
##   group_by(plot_type, genus) %>%
##   tally %>%
##   collect()

### Challenge

## Write a query that returns the total number of rodents in each
## genus caught in the different plot types.

##  Hint: Write a query that joins the species, plot, and survey
##  tables together.  The query should return counts of genus by plot
##  type.



download.file("https://ndownloader.figshare.com/files/3299483",
              "data_raw/species.csv")
download.file("https://ndownloader.figshare.com/files/10717177",
              "data_raw/surveys.csv")
download.file("https://ndownloader.figshare.com/files/3299474",
              "data_raw/plots.csv")
library(tidyverse)
species <- read_csv("data_raw/species.csv")
surveys <- read_csv("data_raw/surveys.csv")
plots <- read_csv("data_raw/plots.csv")

my_db_file <- "data/portal-database-output.sqlite"
my_db <- src_sqlite(my_db_file, create = TRUE)

my_db



### Challenge

## Add the remaining species table to the my_db database and run some
## of your queries from earlier in the lesson to verify that you
## have faithfully recreated the mammals database.
