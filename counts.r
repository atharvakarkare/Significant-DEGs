setwd("##folder path")
library(dplyr)
library(purrr)

# Set the path to the current working directory
folder_path <- "##folder path"

# Rest of your code remains the same
file_list <- list.files(path = folder_path, full.names = TRUE)

process_file <- function(file_path, index) {
  df <- read.delim(file_path, sep = "\t") 
  
  # New code: Count of Gene.symbol column
  result0 <- df %>%
    summarise(count = n_distinct(Gene.symbol))
  
  # Extract the file name without extension
  file_name <- basename(file_path)
  file_new <- tools::file_path_sans_ext(file_name) 
  
  # Generate the output file name for the count of Gene.symbol
  output0 <- paste0(file_new, "_degs.tsv")
  
  # Write the result to a file
  write.table(result0, output0, sep = "\t", row.names = FALSE, quote = FALSE)
  
  # Data manipulation: Filter and rename columns for Condition 1
  result1 <- df %>%
    filter(P.Value <= 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup()
  
  # New code: Count of Gene.symbol column for Condition 1
  count1 <- result1 %>%
    summarise(count = n_distinct(Gene.symbol))
  
  # Data manipulation: Filter and rename columns for Condition 2
  result2 <- df %>%
    filter(P.Value <= 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC > 0.5)
  
  # New code: Count of Gene.symbol column for Condition 2
  count2 <- result2 %>%
    summarise(count = n_distinct(Gene.symbol))
  
  # Data manipulation: Filter and rename columns for Condition 3
  result3 <- df %>%
    filter(P.Value <= 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC < -0.5)
  
  # New code: Count of Gene.symbol column for Condition 3
  count3 <- result3 %>%
    summarise(count = n_distinct(Gene.symbol))
  
  # Data manipulation: Filter and rename columns for Condition 4
  result4 <- df %>%
    filter(P.Value < 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>%
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`, 1)) %>%
    group_by(Gene.symbol) %>%
    filter(P.Value == min(P.Value)) %>%
    ungroup() %>%
    filter(logFC >= 1)
  
  # New code: Count of Gene.symbol column for Condition4
  count4 <- result4 %>% 
    summarise(count = n_distinct(Gene.symbol))
  
  # Data manipulation: Filter and rename columns for Condition5
  result5 <- df %>% 
    filter(P.Value < 0.05, !is.na(Gene.symbol) & Gene.symbol != "") %>% 
    mutate(Gene.symbol = sapply(strsplit(Gene.symbol, "///"), `[`,1)) %>% 
    group_by(Gene.symbol) %>% 
    filter(P.Value == min(P.Value)) %>% 
    ungroup() %>% 
    filter(logFC <= -1)
  
  # New code: Count of Gene.symbol column for Condition5
  count5 <- result5 %>% 
    summarise(count = n_distinct(Gene.symbol))
  
  # Generate a data frame with all counts
  counts_df <- data.frame(
    File_Name = file_new,
    Total_Counts = result0$count,
    os = count1$count,
    gp = count2$count,
    lp = count3$count,
    go = count4$count,
    lo = count5$count
  )
  
  # Print the counts data frame
  print(counts_df)
}

imap(file_list, process_file)
