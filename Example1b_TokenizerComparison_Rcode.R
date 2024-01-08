####################################################
## R code to compare tokenizers
## Author: Chris Meaney
## Date: Jan 2022
####################################################

#########################
## Package dependencies
#########################
library(tokenizers)
library(udpipe)
library(spacyr)


########################################
## Compile character vector of examples
########################################

## Hyphenated compound words
s1 <- "Normal chest x-ray."
s2 <- "2-year 2-month old female with pneumonia."
s3 <- "This may occur through the ability of IL-10 to induce expression of the gene."

## Words with letters/slashes
s4 <- "The maximal effect is observed at the IL-10 concentration of 20 U/ml."
s5 <- "These results indicate that within the TCR/CD3 signal transduction pathway both PKC and calcineurin are required for the effective activation of the IKK complex and NF-kappaB in T lymphocytes."

## Words with letters and apostrophes
s6 <- "The false positive rate of our predictor was estimated by the method of D'Haeseleer and Church 1855 and used to compare it to other prediction datasets."
s7 <- "Small, scarred right kidney, below more than 2 standard deviations in size for patient's age."

## Words with letters and brackets
s8 <- "Of these, Diap1 has been most extensively characterized; it can block cell death caused by the ectopic expression of reaper, hid, and grim (reviewed in [26])."

## Abbreviations in capital letters and acronyms
s9 <- "Mutants in Toll signaling pathway were obtained from Dr. S. Govind: cactE8, cactIIIG, and cactD13 mutations in the cact gene on Chromosome II."
s10 <- "The transcripts were detected in all the CD4- CD8-, CD4+ CD8+, CD4+ CD8-, and CD4- CD8+ cell populations."

## Words with letters and periods
s11 <- "Two stop codons of an iORF (i.e. the inframe and C-terminal stops) can be any combination of canonical stop codons (TAA, TAG, TGA)."

## Words with letters and numbers
s12 <- "Selenocysteine and pyrrolysine are the 21st and 22nd amino acids, which are genetically encoded by stop codons."

## Words with numbers and one type of punctuation
s13 <- "A total of 26,003 iORF satisfied the above criteria."
s14 <- "The patient had prior x-ray on 1/2 which demonstrated no pneumonia."
s15 <- "Indeed, it has been estimated recently that the current yeast and human protein interaction maps are only 50% and 10% complete, respectively 18."
s16 <- "The dotted line indicates significance level 0.05 after a correction for multiple testing."
s17 <- "E-selectin is induced within 1-2 h, peaks at 4-6 h, and gradually returns to basal level by 24 h."

## Numeration
s18 <- "1. Bioactivation of sulphamethoxazole (SMX) to chemically-reactive metabolites and subsequent protein conjugation is thought to be involved in SMX hypersensitivity."

## Hypertext markup
s19 <- "Bcd mRNA transcripts of &lt; or = 2.6kb were selectively expressed in PBL and testis of healthy individuals."

## URLs
s20 <- "Names of all available Trace Databases were taken from a list of databases at http://www.ncbi.nlm.nih.gov/blast/mmtrace.shtml"

## DNA Sequences
s21 <- "Footprinting analysis revealed that the identical sequence CCGAAACTGAAAAGG, designated E6, was protected by nuclear extracts from B cells, T cells, or HeLa cells."

## Temporal Expressions
s22 <- "This was last documented on the Nuclear Cystogram dated 1/2/01."

## Chemical Substances
s23 <- "These results reveal a central role for CaMKIV/Gr as a Ca(2+)-regulated activator of gene transcription in T lymphocytes."
s24 <- "Expression of a highly specific protein inhibitor for cyclic AMP-dependent protein kinases in interleukin-1 (IL-1)-responsive cells blocked IL-1-induced gene transcription that was driven by the kappa immunoglobulin enhancer or the human immunodeficiency virus long terminal repeat."


##############################
## Put examples into character vector
##############################
examples <- c(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24)


###############################
## Apply tokenizers over examples contained in character vector
## 1) tokenizers package
## 2) udpipe package
###############################

##########
## 1) tokenizers package
## https://cran.r-project.org/web/packages/tokenizers/vignettes/introduction-to-tokenizers.html
##########

## 1a. Word Tokenizer
examples_tokenize_words <- tokenize_words(examples)
examples_tokenize_words <- sapply(examples_tokenize_words, paste0, collapse=";")

tokenizers_words_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/tokenizers_words.txt"
write.table(examples_tokenize_words, file=tokenizers_words_file, sep="\n", row.names=FALSE, col.names=FALSE, quote=FALSE)

## 1b. Word Stems Tokenizer
examples_tokenize_word_stems <- tokenize_word_stems(examples)
examples_tokenize_word_stems <- sapply(examples_tokenize_word_stems, paste0, collapse=";")

tokenizers_word_stems_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/tokenizers_word_stems.txt"
write.table(examples_tokenize_word_stems, file=tokenizers_word_stems_file, sep="\n", row.names=FALSE, col.names=FALSE, quote=FALSE)

## 1c. Penn Tree Bank Tokenizer
examples_tokenize_ptb <- tokenize_ptb(examples)
examples_tokenize_ptb <- sapply(examples_tokenize_ptb, paste0, collapse=";")

tokenizers_ptb_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/tokenizers_ptb.txt"
write.table(examples_tokenize_ptb, file=tokenizers_ptb_file, sep="\n", row.names=FALSE, col.names=FALSE, quote=FALSE)


##########
## 2) udpipe package
## https://cran.r-project.org/web/packages/udpipe/vignettes/udpipe-annotation.html
##########

## Download udpipe model
en <- udpipe_download_model(language="english")
str(en)
## Load udpipe model, from full path to the file 
udmodel_en <- udpipe_load_model(file=en$file_model)

examples_udpipe_df <- as.data.frame(udpipe_annotate(udmodel_en, x=examples))
str(examples_udpipe_df)

examples_udpipe_df_split <- split(examples_udpipe_df, f=factor(examples_udpipe_df$doc_id, levels=unique(examples_udpipe_df$doc_id)))
examples_udpipe <- sapply(examples_udpipe_df_split, function(x) paste0(x[["token"]], collapse=";"))

udpipe_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/udpipe.txt"
write.table(examples_udpipe, file=udpipe_file, sep="\n", row.names=FALSE, col.names=FALSE, quote=FALSE)




