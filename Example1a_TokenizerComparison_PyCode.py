###################################################
## Python code to compare tokenizers
## Author: Chris Meaney
## Date: Jan 2022
####################################################

## Package dependencies
import nltk
import spacy
import scispacy
import stanza
import csv

########################################
## Compile character vector of examples
########################################

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
examples = [s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,s21,s22,s23,s24]

###############################
## Apply tokenizers over examples contained in list
## 1) nltk
## 2) spacy
## 3) scispacy
## 4) medspacy??
## 5) stanza?? --- and biomedical add on module
###############################

###########
## 1) NLTK tokenizer
## https://www.nltk.org/api/nltk.tokenize.html
###########
from nltk.tokenize import SpaceTokenizer
from nltk.tokenize import TreebankWordTokenizer

## 1a. space tokenizer
examples_nltk_space = [SpaceTokenizer().tokenize(s) for s in examples]
examples_nltk_space = [";".join(s) + "\n" for s in examples_nltk_space]

nltk_space_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/nltk_space.txt"

with open(nltk_space_file, 'w') as myfile:
    for ex in examples_nltk_space:
        myfile.write(ex)


## 1b. Penn TreeBank Tokenizer
examples_nltk_tb = [TreebankWordTokenizer().tokenize(s) for s in examples]
examples_nltk_tb = [";".join(s) + "\n" for s in examples_nltk_tb]

nltk_tb_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/nltk_tb.txt"

with open(nltk_tb_file, 'w') as myfile:
    for ex in examples_nltk_tb:
        myfile.write(ex)


###########
## 2) spacy
## https://spacy.io/
###########

#$ Download the spacy module
## python -m spacy download en_core_web_lg

## Instantitate pipeline
nlp = spacy.load("en_core_web_lg")

examples_spacy = [[token.text for token in nlp(doc)] for doc in examples]
examples_spacy = [";".join(s) + "\n" for s in examples_spacy]

spacy_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/spacy.txt"

with open(spacy_file, 'w') as myfile:
    for ex in examples_spacy:
        myfile.write(ex)



## Other entities from NLP pipeline
## --- token.text
## --- token.lemma_
## --- token.pos_
## --- token.tag_
## --- token.dep_
## --- token.shape_
## --- token.is_alpha
## --- token.is_stop


############
## 3) SciSpacy
## https://github.com/allenai/scispacy
############

## Download the scispacy module
## pip install https://s3-us-west-2.amazonaws.com/ai2-s2-scispacy/releases/v0.4.0/en_core_sci_lg-0.4.0.tar.gz

## Install pipeline
nlp_sci = spacy.load("en_core_sci_lg")

examples_scispacy = [[token.text for token in nlp_sci(doc)] for doc in examples]
examples_scispacy = [";".join(s) + "\n" for s in examples_scispacy]

scispacy_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/scispacy.txt"

with open(scispacy_file, 'w') as myfile:
    for ex in examples_scispacy:
        myfile.write(ex)


############
## 4) stanza
## https://stanfordnlp.github.io/stanza/
############

##
## 4a. Stanza Core English Model
##

## Download model
stanza.download('en') 
## Initialize English neural pipeline
nlp_stanza = stanza.Pipeline('en', processors='tokenize', tokenize_no_ssplit=True) 

examples_stanza = [[[token.text for token in sent.tokens] for sent in nlp_stanza(doc).sentences] for doc in examples]
examples_stanza = [item for sublist in examples_stanza for item in sublist]
examples_stanza = [";".join(s) + "\n" for s in examples_stanza]

stanza_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/stanza.txt"

with open(stanza_file, 'w') as myfile:
    for ex in examples_stanza:
        myfile.write(ex)

##
## 4b. Stanza Craft Biomedical Model
##

## Download model
stanza.download('en')
## Initialize English neural pipeline
nlp_stanza_craft = stanza.Pipeline('en', package='craft', processors='tokenize', tokenize_no_ssplit=True) 

examples_stanza_craft = [[[token.text for token in sent.tokens] for sent in nlp_stanza_craft(doc).sentences] for doc in examples]
examples_stanza_craft = [item for sublist in examples_stanza_craft for item in sublist]
examples_stanza_craft = [";".join(s) + "\n" for s in examples_stanza_craft]

stanza_craft_file = "/mnt/c/Users/ChristopherMeaney/Desktop/Tokenizers_EmpiricalComparison/Tokenized_Outputs/stanza_craft.txt"

with open(stanza_craft_file, 'w') as myfile:
    for ex in examples_stanza_craft:
        myfile.write(ex)



############
## 5) medspacy
## https://github.com/medspacy/medspacy
############

#import spacy
#import medspacy




