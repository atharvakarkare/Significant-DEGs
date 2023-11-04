setwd("##path")
library(dplyr)
library(purrr)
# Set the path to the folder containing your files
folder_path <- "##path"
# Get a list of files in the folder
file_list <- list.files(path = folder_path, full.names = TRUE)
# Define a function to process each file
process_file <- function(file_path, index) {
  df <- read.delim(file_path, sep = "\t") 
  # Data manipulation: Filter and rename columns for Condition 1
  result1 <- df %>%
    filter(P.Value <= 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup()
  # Data manipulation: Filter and rename columns for Condition 2
  result2 <- df %>%
    filter(P.Value <= 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC > 0.5)
  # Data manipulation: Filter and rename columns for Condition 3
  result3 <- df %>%
    filter(P.Value <= 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC < -0.5)
  # Data manipulation: Filter and rename columns for Condition 4
  result4 <- df %>%
    filter(P.Value < 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC > 1)  
  # Data manipulation: Filter and rename columns for Condition 5
  result5 <- df %>%
    filter(P.Value < 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC < -1)
  # Extract the file name without extension
  file_name <- basename(file_path)
  file_new <- tools::file_path_sans_ext(file_name) 
  # Generate the output file names with the desired format for all conditions
  output1 <- paste0(file_new, "_os.tsv")
  output2 <- paste0(file_new, "_gp.tsv")
  output3 <- paste0(file_new, "_lp.tsv")
  output4 <- paste0(file_new, "_go.tsv")
  output5 <- paste0(file_new, "_lo.tsv")
  # Write the results to separate files for each condition
  write.table(result1, output1, sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(result2, output2, sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(result3, output3, sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(result4, output4, sep = "\t", row.names = FALSE, quote = FALSE)
  write.table(result5, output5, sep = "\t", row.names = FALSE, quote = FALSE)
}
# Use purrr::imap to apply the process_file function to each file
imap(file_list, process_file)
