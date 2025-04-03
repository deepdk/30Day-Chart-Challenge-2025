library(tidyverse)

# Import Hamlet data
 hamlet <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-09-17/hamlet.csv')
 macbeth <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-09-17/macbeth.csv')
 romeo_juliet <- readr::read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-09-17/romeo_juliet.csv')

romeo_juliet |> 
  count(character, sort = TRUE)

# Filter for Hamlet's lines in Act I
hm <- hamlet |> 
  filter(character == "Hamlet") |> 
  filter(act == "Act I")

mac <- macbeth |> 
  filter(character == "Macbeth") |> 
  filter(act == "Act I")

romeo <- romeo_juliet |> 
  filter(character == "Romeo") |> 
  filter(act == "Act I")

juliet <- romeo_juliet |> 
  filter(character == "Juliet") |> 
  filter(act == "Act I")
