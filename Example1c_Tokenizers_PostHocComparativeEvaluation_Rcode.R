#############################################
## R code to post-hoc compare approaches to tokenization
## Author: Chris Meaney 
## Date: Jan 2022
#############################################

##############
## Import each of the tokenized example strings
##############

## Get paths to tokenized files
tok_dir <- "C:/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/"
tok_paths <- paste0(tok_dir, list.files(tok_dir))

## Get character vectors corresponding to tokenized files
list_tok_vecs <- lapply(tok_paths, scan, what='character')

## Unpack the list
examples_nltk_space <- list_tok_vecs[[1]]
examples_nltk_tb <- list_tok_vecs[[2]]
examples_spacy <- list_tok_vecs[[3]]
examples_scispacy <- list_tok_vecs[[4]]
examples_stanza <- list_tok_vecs[[5]]
examples_stanza_craft <- list_tok_vecs[[6]]
examples_tokenizers_words <- list_tok_vecs[[7]]
examples_tokenizers_word_stems <- list_tok_vecs[[8]]
examples_tokenizers_ptb <- list_tok_vecs[[9]]
examples_udpipe <- list_tok_vecs[[10]]

## Convert to token lists
tokens_nltk_space <- strsplit(examples_nltk_space, ";")
tokens_nltk_tb <- strsplit(examples_nltk_tb, ";")
tokens_spacy <- strsplit(examples_spacy, ";")
tokens_scispacy <- strsplit(examples_scispacy, ";")
tokens_stanza <- strsplit(examples_stanza, ";")
tokens_stanza_craft <- strsplit(examples_stanza_craft, ";")
tokens_tokenizers_words <- strsplit(examples_tokenizers_words, ";")
tokens_tokenizers_word_stems <- strsplit(examples_tokenizers_word_stems, ";")
tokens_tokenizers_ptb <- strsplit(examples_tokenizers_ptb, ";")
tokens_udpipe <- strsplit(examples_udpipe, ";")


##############
## Grab the actual examples
##############


## Hyphenated compound words
s1 = "Normal chest x-ray."
s2 = "2-year 2-month old female with pneumonia."
s3 = "This may occur through the ability of IL-10 to induce expression of the gene."

## Words with letters/slashes
s4 = "The maximal effect is observed at the IL-10 concentration of 20 U/ml."
s5 = "These results indicate that within the TCR/CD3 signal transduction pathway both PKC and calcineurin are required for the effective activation of the IKK complex and NF-kappaB in T lymphocytes."

## Words with letters and apostrophes
s6 = "The false positive rate of our predictor was estimated by the method of D'Haeseleer and Church 1855 and used to compare it to other prediction datasets."
s7 = "Small, scarred right kidney, below more than 2 standard deviations in size for patient's age."

## Words with letters and brackets
s8 = "Of these, Diap1 has been most extensively characterized; it can block cell death caused by the ectopic expression of reaper, hid, and grim (reviewed in [26])."

## Abbreviations in capital letters and acronyms
s9 = "Mutants in Toll signaling pathway were obtained from Dr. S. Govind: cactE8, cactIIIG, and cactD13 mutations in the cact gene on Chromosome II."
s10 = "The transcripts were detected in all the CD4- CD8-, CD4+ CD8+, CD4+ CD8-, and CD4- CD8+ cell populations."

## Words with letters and periods
s11 = "Two stop codons of an iORF (i.e. the inframe and C-terminal stops) can be any combination of canonical stop codons (TAA, TAG, TGA)."

## Words with letters and numbers
s12 = "Selenocysteine and pyrrolysine are the 21st and 22nd amino acids, which are genetically encoded by stop codons."

## Words with numbers and one type of punctuation
s13 = "A total of 26,003 iORF satisfied the above criteria."
s14 = "The patient had prior x-ray on 1/2 which demonstrated no pneumonia."
s15 = "Indeed, it has been estimated recently that the current yeast and human protein interaction maps are only 50% and 10% complete, respectively 18."
s16 = "The dotted line indicates significance level 0.05 after a correction for multiple testing."
s17 = "E-selectin is induced within 1-2 h, peaks at 4-6 h, and gradually returns to basal level by 24 h."

## Numeration
s18 = "1. Bioactivation of sulphamethoxazole (SMX) to chemically-reactive metabolites and subsequent protein conjugation is thought to be involved in SMX hypersensitivity."

## Hypertext markup
s19 = "Bcd mRNA transcripts of &lt; or = 2.6kb were selectively expressed in PBL and testis of healthy individuals."

## URLs
s20 = "Names of all available Trace Databases were taken from a list of databases at http://www.ncbi.nlm.nih.gov/blast/mmtrace.shtml"

## DNA Sequences
s21 = "Footprinting analysis revealed that the identical sequence CCGAAACTGAAAAGG, designated E6, was protected by nuclear extracts from B cells, T cells, or HeLa cells."

## Temporal Expressions
s22 = "This was last documented on the Nuclear Cystogram dated 1/2/01."

## Chemical Substances
s23 = "These results reveal a central role for CaMKIV/Gr as a Ca(2+)-regulated activator of gene transcription in T lymphocytes."
s24 = "Expression of a highly specific protein inhibitor for cyclic AMP-dependent protein kinases in interleukin-1 (IL-1)-responsive cells blocked IL-1-induced gene transcription that was driven by the kappa immunoglobulin enhancer or the human immunodeficiency virus long terminal repeat."


##############################
## Put examples into list data structure
##############################
examples = list(s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24)


#####################
## Compare tokenization across examples
#####################
for (i in 1:length(examples)) {
	cat("Example",i,"\n")
	cat("\t\t", examples[[i]], "\n\n")
	cat("NLTK-space\t\t", tokens_nltk_space[[i]], "\n")
	cat("NLTK-tb\t\t\t", tokens_nltk_tb[[i]], "\n")
	cat("Spacy\t\t\t", tokens_spacy[[i]], "\n")
	cat("SciSpacy\t\t", tokens_scispacy[[i]], "\n")
	cat("Stanza\t\t\t", tokens_stanza[[i]], "\n")
	cat("StanzaCraft\t\t", tokens_stanza_craft[[i]], "\n")
	cat("Tokenizers\t\t", tokens_tokenizers_words[[i]], "\n")
	#cat("\t\t", tokens_tokenizers_word_stems[[i]], "\n")
	#cat("\t\t", tokens_tokenizers_ptb[[i]], "\n")
	cat("UDPIPE\t\t\t", tokens_udpipe[[i]], "\n")
	cat("\n\n\n")
}


#####################
## Which unique /// How many unique
#####################

check_unique <- function(i) {
	t1 <- paste0(tokens_nltk_space[[i]], collapse=" ")
	t2 <- paste0(tokens_nltk_tb[[i]], collapse=" ")
	t3 <- paste0(tokens_spacy[[i]], collapse=" ")
	t4 <- paste0(tokens_scispacy[[i]], collapse=" ")
	t5 <- paste0(tokens_stanza[[i]], collapse=" ")
	t6 <- paste0(tokens_stanza_craft[[i]], collapse=" ")
	t7 <- paste0(tokens_tokenizers_words[[i]], collapse=" ")
	t8 <- paste0(tokens_udpipe[[i]], collapse=" ")
	tokens <- c(t1,t2,t3,t4,t5,t6,t7,t8)
	uniq_tokens <- unique(tokens)
	return(uniq_tokens)
}


uniq_tokenizer_outputs <- sapply(1:24, check_unique)
uniq_tokenizer_outputs_len <- sapply(uniq_tokenizer_outputs, length)
uniq_tokenizer_outputs_len


#####################
## Which length of "bag of tokens" returned each of 24 experiments
#####################
check_len <- function(i) {
	t1 <- length(tokens_nltk_space[[i]])
	t2 <- length(tokens_nltk_tb[[i]])
	t3 <- length(tokens_spacy[[i]])
	t4 <- length(tokens_scispacy[[i]])
	t5 <- length(tokens_stanza[[i]])
	t6 <- length(tokens_stanza_craft[[i]])
	t7 <- length(tokens_tokenizers_words[[i]])
	t8 <- length(tokens_udpipe[[i]])
	tokens_len <- c(t1,t2,t3,t4,t5,t6,t7,t8)
	return(tokens_len)
}


len_mat <- sapply(1:24, check_len)
rownames(len_mat) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
colnames(len_mat) <- paste0("Q",1:24)
len_mat



#####################
## Which length of "bag of tokens" returned each of 24 experiments
#####################

check_len_uniq <- function(i) {
	t1 <- length(unique(tokens_nltk_space[[i]]))
	t2 <- length(unique(tokens_nltk_tb[[i]]))
	t3 <- length(unique(tokens_spacy[[i]]))
	t4 <- length(unique(tokens_scispacy[[i]]))
	t5 <- length(unique(tokens_stanza[[i]]))
	t6 <- length(unique(tokens_stanza_craft[[i]]))
	t7 <- length(unique(tokens_tokenizers_words[[i]]))
	t8 <- length(unique(tokens_udpipe[[i]]))
	tokens_len <- c(t1,t2,t3,t4,t5,t6,t7,t8)
	return(tokens_len)
}

len_uniq_mat <- sapply(1:24, check_len_uniq)
rownames(len_uniq_mat) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
colnames(len_uniq_mat) <- paste0("Q",1:24)
len_uniq_mat 


#####################
## Total number of words in corpus
#####################
total_words <- rowSums(len_mat)
names(total_words) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe")
total_words


####################
## Total number of unique words in the corpus
####################
t1 <- length(unique(unlist(tokens_nltk_space)))
t2 <- length(unique(unlist(tokens_nltk_tb)))
t3 <- length(unique(unlist(tokens_spacy)))
t4 <- length(unique(unlist(tokens_scispacy)))
t5 <- length(unique(unlist(tokens_stanza)))
t6 <- length(unique(unlist(tokens_stanza_craft)))
t7 <- length(unique(unlist(tokens_tokenizers_words)))
t8 <- length(unique(unlist(tokens_udpipe)))

total_words_uniq <- c(t1,t2,t3,t4,t5,t6,t7,t8)
names(total_words_uniq) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe")
total_words_uniq



###########################
## Format and output
###########################
len_mat_out <- matrix(paste0(len_uniq_mat, "/", len_mat), ncol=24, byrow=FALSE)
rownames(len_mat_out) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe")
colnames(len_mat_out) <- paste0("Example",1:24)
len_mat_out

total_out <- paste0(total_words_uniq, "/", total_words)

out <- cbind(total_out, len_mat_out)
colnames(out) <- c("Len","TotalCorpus", paste0("Example",1:24))

out <- data.frame(t(out))
out_ <- matrix(paste0("'", unlist(out)), ncol=ncol(out), nrow=nrow(out), byrow=FALSE)
out_ <- cbind(c(NA, uniq_tokenizer_outputs_len), out_)
colnames(out_) <- c("Len","nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe")
rownames(out_) <- c("TotalCorpus", paste0("Example",1:24))
table1_out <- "C://Users//ChristopherMeaney//Desktop//Tokenizers_EmpiricalComparison//ZZZ_Table1.csv"
write.csv(x=out_, file=table1_out, row.names=TRUE, quote=TRUE)
out_



###########################
## How unique are intersection of vocabulary
###########################

## NLTK-space-versus-others
t_space_space <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_nltk_space)))
t_space_tb <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_nltk_tb)))
t_space_spacy <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_spacy)))
t_space_scispacy <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_scispacy)))
t_space_stanza <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_stanza)))
t_space_craft <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_stanza_craft)))
t_space_tokenizers <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_tokenizers_words)))
t_space_udpipe <- length(intersect(unlist(tokens_nltk_space), unlist(tokens_udpipe)))

v1 <- c(t_space_space, t_space_tb, t_space_spacy, t_space_scispacy, t_space_stanza, t_space_craft, t_space_tokenizers, t_space_udpipe)
v1

## NLTK-tb-versus-others
t_tb_space <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_nltk_space)))
t_tb_tb <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_nltk_tb)))
t_tb_spacy <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_spacy)))
t_tb_scispacy <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_scispacy)))
t_tb_stanza <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_stanza)))
t_tb_craft <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_stanza_craft)))
t_tb_tokenizers <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_tokenizers_words)))
t_tb_udpipe <- length(intersect(unlist(tokens_nltk_tb), unlist(tokens_udpipe)))

v2 <- c(t_tb_space, t_tb_tb, t_tb_spacy, t_tb_scispacy, t_tb_stanza, t_tb_craft, t_tb_tokenizers, t_tb_udpipe)
v2

## spacy-versus-others
t_spacy_space <- length(intersect(unlist(tokens_spacy), unlist(tokens_nltk_space)))
t_spacy_tb <- length(intersect(unlist(tokens_spacy), unlist(tokens_nltk_tb)))
t_spacy_spacy <- length(intersect(unlist(tokens_spacy), unlist(tokens_spacy)))
t_spacy_scispacy <- length(intersect(unlist(tokens_spacy), unlist(tokens_scispacy)))
t_spacy_stanza <- length(intersect(unlist(tokens_spacy), unlist(tokens_stanza)))
t_spacy_craft <- length(intersect(unlist(tokens_spacy), unlist(tokens_stanza_craft)))
t_spacy_tokenizers <- length(intersect(unlist(tokens_spacy), unlist(tokens_tokenizers_words)))
t_spacy_udpipe <- length(intersect(unlist(tokens_spacy), unlist(tokens_udpipe)))

v3 <- c(t_spacy_space, t_spacy_tb, t_spacy_spacy, t_spacy_scispacy, t_spacy_stanza, t_spacy_craft, t_spacy_tokenizers, t_spacy_udpipe)
v3

## scispacy-versus-others
t_scispacy_space <- length(intersect(unlist(tokens_scispacy), unlist(tokens_nltk_space)))
t_scispacy_tb <- length(intersect(unlist(tokens_scispacy), unlist(tokens_nltk_tb)))
t_scispacy_spacy <- length(intersect(unlist(tokens_scispacy), unlist(tokens_spacy)))
t_scispacy_scispacy <- length(intersect(unlist(tokens_scispacy), unlist(tokens_scispacy)))
t_scispacy_stanza <- length(intersect(unlist(tokens_scispacy), unlist(tokens_stanza)))
t_scispacy_craft <- length(intersect(unlist(tokens_scispacy), unlist(tokens_stanza_craft)))
t_scispacy_tokenizers <- length(intersect(unlist(tokens_scispacy), unlist(tokens_tokenizers_words)))
t_scispacy_udpipe <- length(intersect(unlist(tokens_scispacy), unlist(tokens_udpipe)))

v4 <- c(t_scispacy_space, t_scispacy_tb, t_scispacy_spacy, t_scispacy_scispacy, t_scispacy_stanza, t_scispacy_craft, t_scispacy_tokenizers, t_scispacy_udpipe)
v4

## stanza-versus-others
t_stanza_space <- length(intersect(unlist(tokens_stanza), unlist(tokens_nltk_space)))
t_stanza_tb <- length(intersect(unlist(tokens_stanza), unlist(tokens_nltk_tb)))
t_stanza_spacy <- length(intersect(unlist(tokens_stanza), unlist(tokens_spacy)))
t_stanza_scispacy <- length(intersect(unlist(tokens_stanza), unlist(tokens_scispacy)))
t_stanza_stanza <- length(intersect(unlist(tokens_stanza), unlist(tokens_stanza)))
t_stanza_craft <- length(intersect(unlist(tokens_stanza), unlist(tokens_stanza_craft)))
t_stanza_tokenizers <- length(intersect(unlist(tokens_stanza), unlist(tokens_tokenizers_words)))
t_stanza_udpipe <- length(intersect(unlist(tokens_stanza), unlist(tokens_udpipe)))

v5 <- c(t_stanza_space, t_stanza_tb, t_stanza_spacy, t_stanza_scispacy, t_stanza_stanza, t_stanza_craft, t_stanza_tokenizers, t_stanza_udpipe)
v5

## stanza_crast-versus-others
t_stanza_craft_space <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_nltk_space)))
t_stanza_craft_tb <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_nltk_tb)))
t_stanza_craft_spacy <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_spacy)))
t_stanza_craft_scispacy <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_scispacy)))
t_stanza_craft_stanza <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_stanza)))
t_stanza_craft_craft <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_stanza_craft)))
t_stanza_craft_tokenizers <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_tokenizers_words)))
t_stanza_craft_udpipe <- length(intersect(unlist(tokens_stanza_craft), unlist(tokens_udpipe)))

v6 <- c(t_stanza_craft_space, t_stanza_craft_tb, t_stanza_craft_spacy, t_stanza_craft_scispacy, t_stanza_craft_stanza, t_stanza_craft_craft, t_stanza_craft_tokenizers, t_stanza_craft_udpipe)
v6

## tokenizers-versus-others
t_tokenizers_space <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_nltk_space)))
t_tokenizers_tb <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_nltk_tb)))
t_tokenizers_spacy <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_spacy)))
t_tokenizers_scispacy <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_scispacy)))
t_tokenizers_stanza <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_stanza)))
t_tokenizers_craft <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_stanza_craft)))
t_tokenizers_tokenizers <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_tokenizers_words)))
t_tokenizers_udpipe <- length(intersect(unlist(tokens_tokenizers_words), unlist(tokens_udpipe)))

v7 <- c(t_tokenizers_space, t_tokenizers_tb, t_tokenizers_spacy, t_tokenizers_scispacy, t_tokenizers_stanza, t_tokenizers_craft, t_tokenizers_tokenizers, t_tokenizers_udpipe)
v7

## tokenizers-versus-others
t_udpipe_space <- length(intersect(unlist(tokens_udpipe), unlist(tokens_nltk_space)))
t_udpipe_tb <- length(intersect(unlist(tokens_udpipe), unlist(tokens_nltk_tb)))
t_udpipe_spacy <- length(intersect(unlist(tokens_udpipe), unlist(tokens_spacy)))
t_udpipe_scispacy <- length(intersect(unlist(tokens_udpipe), unlist(tokens_scispacy)))
t_udpipe_stanza <- length(intersect(unlist(tokens_udpipe), unlist(tokens_stanza)))
t_udpipe_craft <- length(intersect(unlist(tokens_udpipe), unlist(tokens_stanza_craft)))
t_udpipe_tokenizers <- length(intersect(unlist(tokens_udpipe), unlist(tokens_tokenizers_words)))
t_udpipe_udpipe <- length(intersect(unlist(tokens_udpipe), unlist(tokens_udpipe)))

v8 <- c(t_udpipe_space, t_udpipe_tb, t_udpipe_spacy, t_udpipe_scispacy, t_udpipe_stanza, t_udpipe_craft, t_udpipe_tokenizers, t_udpipe_udpipe)
v8

##
## Combine into matrix
##
compare_tokenizers_mat_int <- cbind(v1,v2,v3,v4,v5,v6,v7,v8)
rownames(compare_tokenizers_mat_int) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
colnames(compare_tokenizers_mat_int) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
compare_tokenizers_mat_int	








###########################
## How unique are union of vocabulary
###########################

## NLTK-space-versus-others
t_space_space <- length(union(unlist(tokens_nltk_space), unlist(tokens_nltk_space)))
t_space_tb <- length(union(unlist(tokens_nltk_space), unlist(tokens_nltk_tb)))
t_space_spacy <- length(union(unlist(tokens_nltk_space), unlist(tokens_spacy)))
t_space_scispacy <- length(union(unlist(tokens_nltk_space), unlist(tokens_scispacy)))
t_space_stanza <- length(union(unlist(tokens_nltk_space), unlist(tokens_stanza)))
t_space_craft <- length(union(unlist(tokens_nltk_space), unlist(tokens_stanza_craft)))
t_space_tokenizers <- length(union(unlist(tokens_nltk_space), unlist(tokens_tokenizers_words)))
t_space_udpipe <- length(union(unlist(tokens_nltk_space), unlist(tokens_udpipe)))

v1 <- c(t_space_space, t_space_tb, t_space_spacy, t_space_scispacy, t_space_stanza, t_space_craft, t_space_tokenizers, t_space_udpipe)
v1

## NLTK-tb-versus-others
t_tb_space <- length(union(unlist(tokens_nltk_tb), unlist(tokens_nltk_space)))
t_tb_tb <- length(union(unlist(tokens_nltk_tb), unlist(tokens_nltk_tb)))
t_tb_spacy <- length(union(unlist(tokens_nltk_tb), unlist(tokens_spacy)))
t_tb_scispacy <- length(union(unlist(tokens_nltk_tb), unlist(tokens_scispacy)))
t_tb_stanza <- length(union(unlist(tokens_nltk_tb), unlist(tokens_stanza)))
t_tb_craft <- length(union(unlist(tokens_nltk_tb), unlist(tokens_stanza_craft)))
t_tb_tokenizers <- length(union(unlist(tokens_nltk_tb), unlist(tokens_tokenizers_words)))
t_tb_udpipe <- length(union(unlist(tokens_nltk_tb), unlist(tokens_udpipe)))

v2 <- c(t_tb_space, t_tb_tb, t_tb_spacy, t_tb_scispacy, t_tb_stanza, t_tb_craft, t_tb_tokenizers, t_tb_udpipe)
v2

## spacy-versus-others
t_spacy_space <- length(union(unlist(tokens_spacy), unlist(tokens_nltk_space)))
t_spacy_tb <- length(union(unlist(tokens_spacy), unlist(tokens_nltk_tb)))
t_spacy_spacy <- length(union(unlist(tokens_spacy), unlist(tokens_spacy)))
t_spacy_scispacy <- length(union(unlist(tokens_spacy), unlist(tokens_scispacy)))
t_spacy_stanza <- length(union(unlist(tokens_spacy), unlist(tokens_stanza)))
t_spacy_craft <- length(union(unlist(tokens_spacy), unlist(tokens_stanza_craft)))
t_spacy_tokenizers <- length(union(unlist(tokens_spacy), unlist(tokens_tokenizers_words)))
t_spacy_udpipe <- length(union(unlist(tokens_spacy), unlist(tokens_udpipe)))

v3 <- c(t_spacy_space, t_spacy_tb, t_spacy_spacy, t_spacy_scispacy, t_spacy_stanza, t_spacy_craft, t_spacy_tokenizers, t_spacy_udpipe)
v3

## scispacy-versus-others
t_scispacy_space <- length(union(unlist(tokens_scispacy), unlist(tokens_nltk_space)))
t_scispacy_tb <- length(union(unlist(tokens_scispacy), unlist(tokens_nltk_tb)))
t_scispacy_spacy <- length(union(unlist(tokens_scispacy), unlist(tokens_spacy)))
t_scispacy_scispacy <- length(union(unlist(tokens_scispacy), unlist(tokens_scispacy)))
t_scispacy_stanza <- length(union(unlist(tokens_scispacy), unlist(tokens_stanza)))
t_scispacy_craft <- length(union(unlist(tokens_scispacy), unlist(tokens_stanza_craft)))
t_scispacy_tokenizers <- length(union(unlist(tokens_scispacy), unlist(tokens_tokenizers_words)))
t_scispacy_udpipe <- length(union(unlist(tokens_scispacy), unlist(tokens_udpipe)))

v4 <- c(t_scispacy_space, t_scispacy_tb, t_scispacy_spacy, t_scispacy_scispacy, t_scispacy_stanza, t_scispacy_craft, t_scispacy_tokenizers, t_scispacy_udpipe)
v4

## stanza-versus-others
t_stanza_space <- length(union(unlist(tokens_stanza), unlist(tokens_nltk_space)))
t_stanza_tb <- length(union(unlist(tokens_stanza), unlist(tokens_nltk_tb)))
t_stanza_spacy <- length(union(unlist(tokens_stanza), unlist(tokens_spacy)))
t_stanza_scispacy <- length(union(unlist(tokens_stanza), unlist(tokens_scispacy)))
t_stanza_stanza <- length(union(unlist(tokens_stanza), unlist(tokens_stanza)))
t_stanza_craft <- length(union(unlist(tokens_stanza), unlist(tokens_stanza_craft)))
t_stanza_tokenizers <- length(union(unlist(tokens_stanza), unlist(tokens_tokenizers_words)))
t_stanza_udpipe <- length(union(unlist(tokens_stanza), unlist(tokens_udpipe)))

v5 <- c(t_stanza_space, t_stanza_tb, t_stanza_spacy, t_stanza_scispacy, t_stanza_stanza, t_stanza_craft, t_stanza_tokenizers, t_stanza_udpipe)
v5

## stanza_crast-versus-others
t_stanza_craft_space <- length(union(unlist(tokens_stanza_craft), unlist(tokens_nltk_space)))
t_stanza_craft_tb <- length(union(unlist(tokens_stanza_craft), unlist(tokens_nltk_tb)))
t_stanza_craft_spacy <- length(union(unlist(tokens_stanza_craft), unlist(tokens_spacy)))
t_stanza_craft_scispacy <- length(union(unlist(tokens_stanza_craft), unlist(tokens_scispacy)))
t_stanza_craft_stanza <- length(union(unlist(tokens_stanza_craft), unlist(tokens_stanza)))
t_stanza_craft_craft <- length(union(unlist(tokens_stanza_craft), unlist(tokens_stanza_craft)))
t_stanza_craft_tokenizers <- length(union(unlist(tokens_stanza_craft), unlist(tokens_tokenizers_words)))
t_stanza_craft_udpipe <- length(union(unlist(tokens_stanza_craft), unlist(tokens_udpipe)))

v6 <- c(t_stanza_craft_space, t_stanza_craft_tb, t_stanza_craft_spacy, t_stanza_craft_scispacy, t_stanza_craft_stanza, t_stanza_craft_craft, t_stanza_craft_tokenizers, t_stanza_craft_udpipe)
v6

## tokenizers-versus-others
t_tokenizers_space <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_nltk_space)))
t_tokenizers_tb <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_nltk_tb)))
t_tokenizers_spacy <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_spacy)))
t_tokenizers_scispacy <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_scispacy)))
t_tokenizers_stanza <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_stanza)))
t_tokenizers_craft <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_stanza_craft)))
t_tokenizers_tokenizers <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_tokenizers_words)))
t_tokenizers_udpipe <- length(union(unlist(tokens_tokenizers_words), unlist(tokens_udpipe)))

v7 <- c(t_tokenizers_space, t_tokenizers_tb, t_tokenizers_spacy, t_tokenizers_scispacy, t_tokenizers_stanza, t_tokenizers_craft, t_tokenizers_tokenizers, t_tokenizers_udpipe)
v7

## tokenizers-versus-others
t_udpipe_space <- length(union(unlist(tokens_udpipe), unlist(tokens_nltk_space)))
t_udpipe_tb <- length(union(unlist(tokens_udpipe), unlist(tokens_nltk_tb)))
t_udpipe_spacy <- length(union(unlist(tokens_udpipe), unlist(tokens_spacy)))
t_udpipe_scispacy <- length(union(unlist(tokens_udpipe), unlist(tokens_scispacy)))
t_udpipe_stanza <- length(union(unlist(tokens_udpipe), unlist(tokens_stanza)))
t_udpipe_craft <- length(union(unlist(tokens_udpipe), unlist(tokens_stanza_craft)))
t_udpipe_tokenizers <- length(union(unlist(tokens_udpipe), unlist(tokens_tokenizers_words)))
t_udpipe_udpipe <- length(union(unlist(tokens_udpipe), unlist(tokens_udpipe)))

v8 <- c(t_udpipe_space, t_udpipe_tb, t_udpipe_spacy, t_udpipe_scispacy, t_udpipe_stanza, t_udpipe_craft, t_udpipe_tokenizers, t_udpipe_udpipe)
v8

##
## Combine into matrix
#3
compare_tokenizers_mat_union <- cbind(v1,v2,v3,v4,v5,v6,v7,v8)
rownames(compare_tokenizers_mat_union) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
colnames(compare_tokenizers_mat_union) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
compare_tokenizers_mat_union



##
##
## Compute Jaccard Index as ratio of cardinality of intersection of sets over cardinality union of sets
##	
##
jac_mat <- compare_tokenizers_mat_int/compare_tokenizers_mat_union
jac_mat

rownames(jac_mat) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 
colnames(jac_mat) <- c("nltk-space","nltk-tb","spacy","scispacy","stanza","stanza-craft","tokenizers","udpipe") 

table2_out <- "C://Users//ChristopherMeaney//Desktop//Tokenizers_EmpiricalComparison//ZZZ_Table2.csv"
write.csv(x=jac_mat, file=table2_out, row.names=TRUE)





