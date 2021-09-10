# This script tries to use Word2Vec technique on Handelingen data
# For Dialects of Discord on the party level
#Milan van Lange, June 2021

library(magrittr)
library(tm)
library(word2vec)
library(XML)
library(qdap)
library(stringr)
library(dplyr)
library(lumberjack)
library(readtext)

# Load original xml files from local folder -------------------------------------
# create empty value 'data' 
data <- NULL

# set wd with xmls
setwd("E:/Data PM 1940-90/1970")

#extract all .xml-filenames from folder/working directory
files <- list.files(pattern=".xml")

#load texts into R
for (filename in files) {
  doc = xmlTreeParse(filename, useInternalNodes=TRUE)
  top = xmlRoot(doc)
  # get speech-node set
  getNodeSet(doc, "//*[local-name()='speech']") -> proc
  # extract names of speakers
  xmlSApply(proc, xmlGetAttr, "pm:speaker", xmlValue) -> spreker
  # extract unique identifier of every speech
  xmlSApply(proc, xmlGetAttr, "pm:id", xmlValue) -> id
  # extract speeches
  xmlSApply(proc, xmlValue, "//p")-> sprkbrt
  # extract names of parties
  xmlSApply(proc, xmlGetAttr, "pm:party", NA) -> partij
  partij <- as.character(partij)
  na.pass(partij)
  # create dataframe/overview of extracted values. 
  # bind values into dataframe
  d2 <- data.frame(id, spreker, sprkbrt, partij)
  rbind(data, d2) -> data
}

#start_log(data, logger = simple$new(), label = NULL)

# clean data
data$sprkbrt <- tolower(data$sprkbrt)
data$sprkbrt <- removeWords(data$sprkbrt, stopwords("dutch"))
data$sprkbrt <- removePunctuation(data$sprkbrt, preserve_intra_word_dashes = TRUE)
data$sprkbrt <- str_squish(data$sprkbrt)

#We performed some pre-processing steps to the parliamentary data sets to remove noise and improve the quality of our WEMs. These steps include the lowercasing of all the words in the texts and the removal of interpunction, white spaces and general Dutch stop words. To perform these pre-processing steps, we used the R package tm, which also includes a standard list of stop words for Dutch. 

#  use a copy of this when calculating values of spec. speaker or party
dt <- data 

# Create party and year specific datasets ---------------------------------
# set wd
 setwd("Q:/Onderzoeksdata_Milan/Surfdrive_milan/Shared/Dialects_of_Discord/Raw_data/Plain_texts_party_spec_7075")

# CPN
dt %>%
  dplyr::filter(partij == "CPN") -> cpn

cpn %>%
  dplyr::filter(str_detect(id, "19691970")) -> cpn.19691970
cpn %>%
  dplyr::filter(str_detect(id, "19701971")) -> cpn.19701971
cpn %>%
  dplyr::filter(str_detect(id, "19711972")) -> cpn.19711972
cpn %>%
  dplyr::filter(str_detect(id, "19721973")) -> cpn.19721973
cpn %>%
  dplyr::filter(str_detect(id, "19731974")) -> cpn.19731974
cpn %>%
  dplyr::filter(str_detect(id, "19741975")) -> cpn.19741975

# etc.

#write file to use as training text 
write(cpn.19691970$sprkbrt, "corpus19691970cpn.txt")
write(cpn.19701971$sprkbrt, "corpus19701971cpn.txt")
write(cpn.19711972$sprkbrt, "corpus19711972cpn.txt")
write(cpn.19721973$sprkbrt, "corpus19721973cpn.txt")
write(cpn.19731974$sprkbrt, "corpus19731974cpn.txt")
write(cpn.19741975$sprkbrt, "corpus19741975cpn.txt")

# VVD

dt %>%
  dplyr::filter(partij == "VVD") -> vvd

vvd %>%
  dplyr::filter(str_detect(id, "19691970")) -> vvd.19691970
vvd %>%
  dplyr::filter(str_detect(id, "19701971")) -> vvd.19701971
vvd %>%
  dplyr::filter(str_detect(id, "19711972")) -> vvd.19711972
vvd %>%
  dplyr::filter(str_detect(id, "19721973")) -> vvd.19721973
vvd %>%
  dplyr::filter(str_detect(id, "19731974")) -> vvd.19731974
vvd %>%
  dplyr::filter(str_detect(id, "19741975")) -> vvd.19741975

# etc.

#write file to use as training text 
write(vvd.19691970$sprkbrt, "corpus19691970vvd.txt")
write(vvd.19701971$sprkbrt, "corpus19701971vvd.txt")
write(vvd.19711972$sprkbrt, "corpus19711972vvd.txt")
write(vvd.19721973$sprkbrt, "corpus19721973vvd.txt")
write(vvd.19731974$sprkbrt, "corpus19731974vvd.txt")
write(vvd.19741975$sprkbrt, "corpus19741975vvd.txt")

# PVDA

dt %>%
   dplyr::filter(partij == "PvdA") -> pvda

pvda %>%
   dplyr::filter(str_detect(id, "19691970")) -> pvda.19691970
pvda %>%
   dplyr::filter(str_detect(id, "19701971")) -> pvda.19701971
pvda %>%
   dplyr::filter(str_detect(id, "19711972")) -> pvda.19711972
pvda %>%
   dplyr::filter(str_detect(id, "19721973")) -> pvda.19721973
pvda %>%
   dplyr::filter(str_detect(id, "19731974")) -> pvda.19731974
pvda %>%
   dplyr::filter(str_detect(id, "19741975")) -> pvda.19741975

# etc.

#write file to use as training text 
write(pvda.19691970$sprkbrt, "corpus19691970pvda.txt")
write(pvda.19701971$sprkbrt, "corpus19701971pvda.txt")
write(pvda.19711972$sprkbrt, "corpus19711972pvda.txt")
write(pvda.19721973$sprkbrt, "corpus19721973pvda.txt")
write(pvda.19731974$sprkbrt, "corpus19731974pvda.txt")
write(pvda.19741975$sprkbrt, "corpus19741975pvda.txt")

# CDA

dt %>%
   dplyr::filter(partij == "CDA") -> cda

cda %>%
   dplyr::filter(str_detect(id, "19691970")) -> cda.19691970
cda %>%
   dplyr::filter(str_detect(id, "19701971")) -> cda.19701971
cda %>%
   dplyr::filter(str_detect(id, "19711972")) -> cda.19711972
cda %>%
   dplyr::filter(str_detect(id, "19721973")) -> cda.19721973
cda %>%
   dplyr::filter(str_detect(id, "19731974")) -> cda.19731974
cda %>%
   dplyr::filter(str_detect(id, "19741975")) -> cda.19741975

# etc.

#write file to use as training text 
write(cda.19691970$sprkbrt, "corpus19691970cda.txt")
write(cda.19701971$sprkbrt, "corpus19701971cda.txt")
write(cda.19711972$sprkbrt, "corpus19711972cda.txt")
write(cda.19721973$sprkbrt, "corpus19721973cda.txt")
write(cda.19731974$sprkbrt, "corpus19731974cda.txt")
write(cda.19741975$sprkbrt, "corpus19741975cda.txt")
#etc for all other years

setwd("Q:/Onderzoeksdata_Milan/Surfdrive_milan/Shared/Dialects_of_Discord/Raw_data/Plain_texts_timeslot/1970-1975")

# All parties
dt %>%
  dplyr::filter(str_detect(id, "19691970")) -> dt.19691970
dt %>%
  dplyr::filter(str_detect(id, "19701971")) -> dt.19701971
dt %>%
  dplyr::filter(str_detect(id, "19711972")) -> dt.19711972
dt %>%
  dplyr::filter(str_detect(id, "19721973")) -> dt.19721973
dt %>%
  dplyr::filter(str_detect(id, "19731974")) -> dt.19731974
dt %>%
  dplyr::filter(str_detect(id, "19741975")) -> dt.19741975


write(dt.19691970$sprkbrt, "corpus19691970dt.txt")
write(dt.19701971$sprkbrt, "corpus19701971dt.txt")
write(dt.19711972$sprkbrt, "corpus19711972dt.txt")
write(dt.19721973$sprkbrt, "corpus19721973dt.txt")
write(dt.19731974$sprkbrt, "corpus19731974dt.txt")
write(dt.19741975$sprkbrt, "corpus19741975dt.txt")
#etc for all other years


### data prepared! 


# Train word2vec model --------------------------------------------------

# load prepared txts in envir
# create object with directory where files are in # this is workstation-specific!
data.dir <- c("Q:/Onderzoeksdata_Milan/Surfdrive_milan/Shared/Dialects_of_Discord/Raw_data/Plain_texts_timeslot")

# load all files with .txt file type. make sure only the txt files needed are in the directory!
files <- readtext(paste0(data.dir, "/1970-1975*" ))

# Train overall model 1970-1975 -------------------------------------------

# set text as character
all.7075 <- as.character(files$text)

# train model
# train word2vec
model.all.7075 <- word2vec(x = all.7075, min_count = 5, threads = 4, type = 'skip-gram', dim = 100)

# create matrix
emb.all.7075 <- as.matrix(model.all.7075)

# Train party specific models ---------------------------------------------

# create object with directory where files are in # this is workstation-specific!
data.dir2 <- c("Q:/Onderzoeksdata_Milan/Surfdrive_milan/Shared/Dialects_of_Discord/Raw_data")

# load all files with .txt file type. make sure only the txt files needed are in the directory!
files2 <- readtext(paste0(data.dir2, "/Plain_texts_party_spec_7075*" ))


# CPN
# Subset specific year, set as character vector to serve as input for word2vec package
files2 %>%
  filter(str_detect(doc_id, "cpn")) -> cpn.7075

# set as character
cpn.7075 <- as.character(cpn.7075$text)

# train model
# train word2vec
model.cpn.7075 <- word2vec(x = cpn.7075, min_count = 5, threads = 4, type = 'skip-gram', dim = 100, iter = 20 )

# create matrix
emb.cpn.7075 <- as.matrix(model.cpn.7075)

# VVD

# Subset specific year, set as character vector to serve as input for word2vec package
files2 %>%
  filter(str_detect(doc_id, "vvd")) -> vvd.7075

# set as character
vvd.7075 <- as.character(vvd.7075$text)

# train model
# train word2vec
model.vvd.7075 <- word2vec(x = vvd.7075, min_count = 5, threads = 4, type = 'skip-gram', dim = 100)

# create matrix
emb.vvd.7075 <- as.matrix(model.vvd.7075)

# PvdA

# Subset specific year, set as character vector to serve as input for word2vec package
files2 %>%
  filter(str_detect(doc_id, "pvda")) -> pvda.7075

# set as character
pvda.7075 <- as.character(pvda.7075$text)

# train model
# train word2vec
model.pvda.7075 <- word2vec(x = pvda.7075, min_count = 5, threads = 4, type = 'skip-gram', dim = 100)

# create matrix
emb.pvda.7075 <- as.matrix(model.pvda.7075)

# CDA
# Subset specific year, set as character vector to serve as input for word2vec package
files2 %>%
  filter(str_detect(doc_id, "cda")) -> cda.7075

# set as character
cda.7075 <- as.character(cda.7075$text)

# train model
# train word2vec
model.cda.7075 <- word2vec(x = cda.7075, min_count = 5, threads = 4, type = 'skip-gram', dim = 100)

# create matrix
emb.cda.7075 <- as.matrix(model.cda.7075)

# Training complete, go to analysis in next script 2_analyse_plot_7075_parties.R



