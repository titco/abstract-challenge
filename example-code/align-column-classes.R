## These first few lines are just to create some example data
data(mtcars)
df <- mtcars
df$vs <- as.factor(df$vs)
g <- dt <- df
dt[] <- lapply(dt, as.character)

## Although this was a neat solution it fails if you are trying to
## convert a character vector to a factor, even though as.factor
## exists.
dt[] <- mapply(FUN = as, dt, sapply(g, class), SIMPLIFY = FALSE)


## You also need to make sure that the order is the same in both data
## frames and both data frames have the same number of columns,
## otherwise you will assign the wrong classes
dt[] <- lapply(names(dt), function(name) {
    column <- dt[, name]
    correct.class <- class(g[, name])
    if (correct.class == "factor") {
        new.column <- factor(column, levels = levels(g[, name]))
    } else {
        new.column <- as(column, correct.class)
    }
    return (new.column)
})


