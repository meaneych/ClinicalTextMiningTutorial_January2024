#######################################################################################
## R code - BIO code the i2b2 DEID dataset 
##
## Author: Chris Meaney
## Date: 21 May, 2021
##
## These code will process i2b2-2014 XML files; return a data.frame in long format BIO-tag format
##
## 5 cols
##     1) doc_id
##     2) is_test (True=Test; False=Train)
##     3) tok_text (tokenized i2b2 text)
##     4) bio (BIO taf associated with tokenized text in col4 above)
##     5) bio_r (multinomial labels; not BIO tags --- strip leading B- and I-)
##
########################################################################################


#########################
## Package dependencies
#########################

## XML - to import and parse the notes
library(XML)



##############################
## Data paths and XML import
##############################

##
## Path where XML DEID train/test data live
## Note: XML files contain both free text note, and BIO tag spans
##
fdir_train1 <- "C:/Users/ChristopherMeaney/Desktop/DEID_BiostatsPracticum/DEID_PublicDatasets/i2b2_2014_deid/2_train_data/training-PHI-Gold-Set1/"
fdir_list_train1 <- list.files(fdir_train1)
fpaths_train1 <- paste0(fdir_train1, fdir_list_train1)


fdir_train2 <- "C:/Users/ChristopherMeaney/Desktop/DEID_BiostatsPracticum/DEID_PublicDatasets/i2b2_2014_deid/2_train_data/training-PHI-Gold-Set2/"
fdir_list_train2 <- list.files(fdir_train2)
fpaths_train2 <- paste0(fdir_train2, fdir_list_train2)


fdir_test <- "C:/Users/ChristopherMeaney/Desktop/DEID_BiostatsPracticum/DEID_PublicDatasets/i2b2_2014_deid/3_test_data/testing-PHI-Gold-fixed/"
fdir_list_test <- list.files(fdir_test)
fpaths_test <- paste0(fdir_test, fdir_list_test)

##
## Combine into large vector of fpaths for train/test data
##
fpaths <- c(fpaths_train1, fpaths_train2, fpaths_test)
length(fpaths)

## How many training vs. test
table(grepl(x=fpaths, pattern="testing-PHI-Gold-fixed"))



############################################################################################################
## Function to process XML data (2 nodes: text, tags)
##  --- fpaths = path to XML file
##  --- returns() - data.frame of BIO tagged and processed feature set for input CRF, bi-LSTM, BERT, etc.
############################################################################################################
bio_tag_xml <- function(fpath_note) {

	## Import note to XML structure
	xml_note <- xmlParse(file=fpath_note)

	## Get root of note
	xml_note_root <- xmlRoot(xml_note)

	##########################################################
	## Extract the text from the XML files
	##########################################################

	## This uses XPATH syntax to traverse XML hierarchy
	note <- xpathSApply(xml_note, path="//text()", fun=xmlValue)

	##########################################################
	## Extract the tags from the XML files
	##########################################################

	## From list of lists, construct a TAG data frame
	df_tags <- data.frame(do.call("rbind", xmlToList(xml_note_root[["TAGS"]])), stringsAsFactors=FALSE, row.names=NULL, check.rows=FALSE)
	names(df_tags) <- c("id","start","end","text","type","comment")

	## Specify data types in data frame object
	df_tags$id <- as.character(df_tags$id)
	df_tags$start <- as.integer(df_tags$start)
	df_tags$end <- as.integer(df_tags$end)
	df_tags$text <- as.character(df_tags$text)
	df_tags$type <- as.character(df_tags$type)
	df_tags$comment <- as.character(df_tags$comment)
	## Print df_tags dataframe to console for inspection
	# df_tags

	## Create arbitrary word ID
	df_tags$phi_id <- 1:nrow(df_tags)

	## How many tokens in each row (corresponding to single PHI instance)
	df_tags$num_toks_phi <- sapply(strsplit(df_tags$text, "\\s+"), length)

	## Now lets convert this wide-to-long format expanding out multi-token PHI into more rows of matrix
	df_tags_long <- df_tags[rep(df_tags$phi_id, df_tags$num_toks_phi), c("phi_id","text","type","num_toks_phi")]
	df_tags_long

	## Get token ID for each PHI instance
	tok_id_list <- list()
	for (i in 1:nrow(df_tags)) {
		tok_id_list[[i]] <- seq.int(from=1, to=df_tags$num_toks_phi[i])
	}
	tok_id <- unlist(tok_id_list)

	## Compute BIO tags for each token
	df_tags_long$bio_tag <- ifelse(duplicated(df_tags_long$phi_id)==TRUE, 
									paste0("I-", df_tags_long$type), 
									paste0("B-", df_tags_long$type))

	## Assign token ID
	df_tags_long$tok_id <- tok_id

	## Get associated text token for each unique PHI-token-id combination
	df_tags_long$tok_text <- unlist(lapply(df_tags$text, strsplit, split=" "))

	## Combine BIO-tags and token-text
	df_tags_long$bio_tags_tok_text <- with(df_tags_long, paste0(bio_tag, "_", tok_text))
	# df_tags_long

	## Get unique BIO tags
	uniq_bio_tags <- unique(df_tags_long$bio_tag)

	## Replace the note PHI with associated BIO-tags
	note_tagged <- note

	for (i in 1:nrow(df_tags_long)) {
	## Note: sub() only changes first occurrence, vs. gsub() change all
	## I only want to hit subs() incrementally, as i iterate over each PHI element in df_tags
	note_tagged <- sub(x=note_tagged, 
			pattern=df_tags_long$tok_text[i], 
			replace=paste0(" ", df_tags_long$bio_tag[i], " "))
	} 	

	## Now swap back and replace the bio-tag with " " separated text
	## This is a HACK to try to ensure tokenized seqs are of same length
	note_seps <- note_tagged

	for (i in 1:nrow(df_tags_long)) {
		## Tag the text
		note_seps <- sub(x=note_seps, 
			pattern=paste0(df_tags_long$bio_tag[i]), 
			replace=paste0(" ", df_tags_long$tok_text[i], " "))
	}

	## Trim leading/trailing whitespace
	note_tagged <- trimws(note_tagged, which="both")
	note_seps <- trimws(note_seps, which="both")

	## White space tokenizer (very simple...)
	tok_tagged <- c(strsplit(x=note_tagged, split="\\s+")[[1]])
	tok_text <- c(strsplit(x=note_seps, split="\\s+")[[1]])
	## Further note: no normalization to upcase/lowcase, no lemmas, no stemmer, etc.

	## Put into data frame
	df_tok <- data.frame(tok_tagged=tok_tagged, tok_text=tok_text)
	# str(df_tok)

	## Another check
	# sum(df_tok$tok_tagged %in% unique(df_tags_long$bio_tag))
	# nrow(df_tags_long)

	## BIO tags
	df_tok$bio <- ifelse(df_tok$tok_tagged %in% unique(df_tags_long$bio_tag),
					df_tok$tok_tagged,
					"O")

	## Create document ID
	df_tok$doc_id <- rep(gsub(x=basename(fpath_note), pattern="\\.xml", ""), nrow(df_tok))

	## Get train/test indicator
	df_tok$is_test <- grepl(x=fpath_note, pattern="testing-PHI-Gold-fixed")

	## Convert back to data.frame
	df_bio_final <- as.data.frame(df_tok)

	## Subset dataframe, returning final BIO tagged df to user
	df_bio_final <- df_bio_final[, c("doc_id",
								"is_test",
								"bio",
								"tok_text")]

	## Return processed dataframe to user
	return(df_bio_final)

}

## Test over fpaths object
demo <- bio_tag_xml(fpath_note=fpaths[1])
# demo
# table(demo$bio)


###########################################################
## Loop function over all XML files in fpaths vector
## Save processed files in list, and coerce to dataframe
###########################################################

## Initialize empty list
bio_df_list <- list()

## Length of fpaths vector (train vs. test)
length(fpaths)
## How many training vs. test
table(grepl(x=fpaths, pattern="testing-PHI-Gold-fixed"))

## Loop over fpaths and saved BIO processed XML data to list
for (i in 1:length(fpaths)) {
	## Print iteration history to console
	cat(paste0("Iteration=",i,"\n"))
	## HACK below - deals with BIO tagger errors/failures (essentially throwing out edge case data)
	skip_to_next <- FALSE
	tryCatch(
		bio_df_list[[i]] <- bio_tag_xml(fpath_note=fpaths[i]),
		error=function(e) {skip_to_next <- TRUE}
		)
	if(skip_to_next) { next }
}

## Post hoc clean the returned list of data frame
bio_df_list_small <- bio_df_list[which(sapply(bio_df_list, length)!=0)]
length(bio_df_list_small)
length(bio_df_list)

## Stack list of dataframe into single final object for use in CRF, bi-LSTM, BERT models
bio_df <- do.call("rbind", bio_df_list_small)
str(bio_df)


##########################################################
## Dataset created above, now post-hoc summarize
##########################################################

## How many unique docs remain; what proportions train vs. test
length(unique(bio_df$doc_id))
table(bio_df$is_test[!(duplicated(bio_df$doc_id))])


## How many unique word tokens 
length(unique(bio_df$tok_text))
tok_table <- as.data.frame(table(bio_df$tok_text), stringsAsFactors=FALSE)
names(tok_table) <- c("Token","Freq")
tok_table <- with(tok_table, tok_table[order(-Freq), ])
str(tok_table)
## Word token frequency as expected; most freq words dominated by stop/functional-words
## Remainder word freqs look power-law-ish distributed (Many 1-freq words; Lesser 2-freq words; etc. Few words with very high freq in corpus).



## How many unique labels
tag_table <- as.data.frame(table(bio_df$bio), stringsAsFactors=FALSE)
names(tag_table) <- c("Tag","Freq")
tag_table <- with(tag_table, tag_table[order(Tag),])
tag_table
##
## Create another short label as just multinomial tag everything not BIO
##
bio_df$bio_r <- sapply(bio_df$bio, function(x) ifelse(x=="O", "O", substr(x, start=3, stop=nchar(x))))
tag_table_r <- as.data.frame(table(bio_df$bio_r), stringsAsFactors=FALSE)
names(tag_table_r) <- c("Tag","Freq")
tag_table_r <- with(tag_table_r, tag_table_r[order(Tag),])
tag_table_r


#########################
## Write file to disk
#########################
str(bio_df)

## CSV
write.csv(bio_df, file="C:/Users/ChristopherMeaney/Desktop/DEID_BiostatsPracticum/Chris_Rcode_Devel/bio_df_st.csv", row.names=FALSE)
## RDS
saveRDS(bio_df, file="C:/Users/ChristopherMeaney/Desktop/DEID_BiostatsPracticum/Chris_Rcode_Devel/bio_df_st.RDS")

#########################
## SessionInfo
#########################
sessionInfo()




