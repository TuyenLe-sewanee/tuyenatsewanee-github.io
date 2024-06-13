---
  title: "Messy Data"
author: "Tuyen Le"
date: "2024-06-13"
output: html_document
---
  
  ```{r}
library(dplyr)
library(readr)

### Format and create id columns
new_whales <- messy_dives %>% 
  mutate ( YEAR = ifelse( YEAR == 15, paste0('2015'), paste0(YEAR))) %>% 
  mutate (month = paste0(0,Month)) %>% 
  mutate ( sit = substr(messy_dives$sit, 10, 12)) %>% 
  mutate( id = paste0(YEAR,Month,Day,sit)) %>% 
  drop_na()

new_whales <- new_whales %>% select(id, Species.ID, bhvr, PreyVolume, PreyDepth, Dive_Time, Surfacetime, Blow.Interval, Blow_number_count)

view(new_whales)


# format species column
new_whales <- new_whales %>% 
  mutate( Species.ID = ifelse(Species.ID %in% c('FinWhale','fin','FinW','finderbender','FW'), paste0('FW'), paste0('HW')))

names(dives)
names(new_whales)
# Change column names

new_whales <- new_whales %>% 
  mutate()

names(new_whales) <- c('id','species', 'behavior', 'prey.volume', 'prey.depth','dive.time', 'surface.time', 'blow.interval','blow.number')

# Rearrange based on id
new_whales <- new_whales %>% arrange((id))
view(new_whales)

# Remove duplicated ids

new_whales <- new_whales %>% distinct( id, .keep_all = TRUE)

# 




```

