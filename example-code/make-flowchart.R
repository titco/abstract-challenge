## Install and load packages
if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install("Rgraphviz")
library(Rgraphviz)

## Define variables
n.ttris <- 15000
n.kbbh <- 4793
n.green <- 4133

## Define nodes
cohort <- paste0(n.ttris, " patients in the TTRIS cohort")
kbbh <- paste0(n.kbbh, " patients in the KBBH cohort")
not.kbbh <- paste0(n.ttris - n.kbbh, " patients in other centres")
kbbh.not.green <- paste0(n.kbbh - n.green, " patients were not triaged green")
kbbh.green <- paste0(n.green, " patients were triaged green")

## Modify attributes
custom.attributes <- getDefaultAttrs()
custom.attributes$graph$splines <- FALSE
custom.attributes$graph$bgcolor <- "white"
custom.attributes$graph$rankdir <- "TB"
custom.attributes$graph$ratio <- "auto"
custom.attributes$node$shape <- "rectangle"
custom.attributes$node$fixedsize <- FALSE

## Create the actual flowchart
flowchart <- graphNEL(nodes = c(cohort, not.kbbh, kbbh, kbbh.not.green, kbbh.green), edgemode = "directed")
flowchart <- addEdge(cohort, not.kbbh, flowchart)
flowchart <- addEdge(cohort, kbbh, flowchart)
flowchart <- addEdge(kbbh, kbbh.not.green, flowchart)
flowchart <- addEdge(kbbh, kbbh.green, flowchart)

## These sub graphs are what makes the "exclusion" boxes extend to the right 
sub.graph.1 <- list(graph = subGraph(c(cohort, not.kbbh), flowchart), cluster = FALSE, attrs = c(rank = "same", rankdir = "LR"))
sub.graph.2 <- list(graph = subGraph(c(kbbh, kbbh.not.green), flowchart), cluster = FALSE, attrs = c(rank = "same", rankdir = "LR"))

## Put it all together and write to file
fcg <- agopen(flowchart, "flowchart",
              attrs = custom.attributes,
              subGList = list(sub.graph.1, sub.graph.2))
toFile(fcg, filename = "flowchart.svg", fileType = "svg")
