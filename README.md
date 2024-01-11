# Clinical Text Mining: A Showcase of Computational Tools and Statistical Models in R/Python

## Author: Christopher Meaney

## Date: January 2024

## Abstract

Healthcare systems are collecting increasingly large quantities of digital information on their patients; much of the digital health information generated exists in clinical text format. The objective of this talk/tutorial is to introduce several computational tools and statistical models commonly encountered in clinical text mining research. The talk begins by introducing how text/string data (i.e. collections of digital character sequences) are stored in R/Python, and how they might be manipulated using pattern matching and regular expression algorithms. Next, the talk introduces the problem of tokenization, i.e. splitting input digital character sequences into sets of words/tokens (several tokenizers are introduced and empirically compared). Statistical semantic models are introduced (document term matrices, term co-occurrence matrices, etc.), and we illustrate how they can be used in several diverse clinical NLP problems (e.g. supervised document classification, unsupervised topic extraction and document clustering, unsupervised token/word clustering, etc.). Lastly, the talk introduces large language models (LLMs), as a general purpose and performant class of statistical model across a variety of core clinical NLP tasks (with particular application to clinical text deidentification, cast as a named entity recognition problem). Jupyter notebooks (using either R/Python kernels) will be provided to illustrate computational tools and statistical models introduced in the talk, and are available at the following URL: https://github.com/meaneych/ClinicalTextMiningTutorial_January2024

## Details Regarding Datasets Used in this Tutorial

Real clinical text datasets will be used to demonstrate computational tools and statistical models. In particular, we will make use of 1) the general purpose MIMIC-III dataset, and 2) the i2b2 2014 clinical text deidentification track dataset.

MIMIC-III documentation, and details regarding data access are provided at the following URL [https://physionet.org/content/mimiciii/1.4/]. An accompanying scientific manuscript describing the open access clinical data resource is provided at the following URL [https://dspace.mit.edu/bitstream/handle/1721.1/109192/MIMIC-III.pdf?sequence=1]. 

The i2b2 2014 clinical text deidenticiation track dataset is described at the following URL [https://portal.dbmi.hms.harvard.edu/projects/n2c2-nlp/]. An accompnaying scientific manuscript discussing study design and data annotation re provided at the following URL [https://www.sciencedirect.com/science/article/pii/S1532046415001823?via%3Dihub]. An overview of top performing DEID models is provided at the following URL [https://www.sciencedirect.com/science/article/pii/S1532046415001173?via%3Dihub].

## Talk Overview and Additional Resources

The talk is composed of 6 Jupyter notebooks each illustrating the use of a computational tool or statistical model in clinical text mining research. Additional details regarding the clinical NLP problem, and/or the tool/model are provided below.

1. Tokenizers
2. Tokenization, Feature Generation, and Contextual Modification (medspacy)
3. Document Classification: DTMs and Logistic Lasso
4. Topic Extraction and Supervised Clustering: NMF Topic Models
5. Word Clustering/Embedding and Estimation of Semantic Relatedness: word2vec
6. Clinical text deidentification and related NER problems: Roberta LLM 


