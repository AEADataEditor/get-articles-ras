# Read in export

library(tidyverse)
install.packages("wordcloud") # word-cloud generator 
library(wordcloud)

# locations

dataloc <- "data"

df <- read_csv(file.path(dataloc,"export_Articles-and-RAs_10-27-2023.csv")) 
# separate out articles
df %>%
  separate_wider_delim(`Manuscript Central identifier`,".",
                       names=c("MC","Revision") ,
                       too_few="align_start",
                       too_many = "drop") %>%
  filter(!is.na(MC)) %>%
  filter(!is.na(Assignee))-> cases

# list assignees


exclusions = c("Lars Vilhuber","Jenna Kutz Farabaugh","LV (Data Editor)")

cases %>% 
  filter(! Assignee %in% exclusions) %>%
  filter(! tolower(Assignee)==Assignee) %>%
  distinct(Assignee,MC) %>%
  group_by(Assignee) %>%
  summarize(n=n()) -> assignees

# unique MC

nrow(cases %>% distinct(MC))
nrow(assignees %>% distinct(Assignee))

# wordcloud

png(paste0("wordcloud-",Sys.Date(),".png")) 
wordcloud(words = assignees$Assignee, freq = assignees$n, min.freq = 1,
          max.words=200, random.order=FALSE, rot.per=0.35, 
          colors=brewer.pal(8, "Dark2"))
dev.off()

