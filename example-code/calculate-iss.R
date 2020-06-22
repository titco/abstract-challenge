library(rio)
library(tibble)
library(dplyr)
library(tidyr)
library(splitstackshape)
titco <- file.path(getOption("data.path"), "ttris-dataset-with-iss-8317-20190708120045.csv") %>%
    rio::import() %>%
    as_tibble()
ais <- titco %>% select(contains("clean_"))
ais.list <- lapply(names(ais), function(x) cSplit(ais[, x], x, sep = ","))
row_max <- function(x, na.rm = FALSE) {
    if (all(is.na(x)))
        return (NA)
    max(x, na.rm = na.rm)
}
ais.max <- lapply(ais.list, function(x) apply(x, 1, row_max, na.rm = TRUE))
get_top_3 <- function(x) {
    x <- sort(x, decreasing = TRUE, na.last = TRUE)
    i <- min(c(3, length(x)))
    x[seq_len(i)]
}
calculate_iss <- function(x) {
    top_3 <- get_top_3(x)
    iss <- sum(x[1]^2, x[2]^2, x[3]^2, na.rm = TRUE)
    iss
}
iss <- apply(do.call(cbind, ais.max), 1, calculate_iss)
ttris$iss <- iss
