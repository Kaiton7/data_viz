##
## deploy environment
##


library(readxl)
library(ggplot2)
## if packages are not installed, it'll installs below.
# source("http://bioconductor.org/biocLite.R")
# biocLite("GemicRanges")
# biocLite("Gviz")
# biocLite("TxDb.Mmusculus.UCSC.mm10.knownGene")
suppressPackageStartupMessages(library(GenomicRanges))
suppressPackageStartupMessages(library(Gviz))
suppressPackageStartupMessages(library(TxDb.Mmusculus.UCSC.mm10.knownGene))
options(ucscChromosomeNames=FALSE)

#Read the dataset
RNA_KO <- read.table("./www/RNA-seq_KO/expression/result_RNAseq_Tet2KOTet3Het.txt", header=T, sep="\t")
RNA_TIME <- read_excel("www/RNA-seq_Time/expression/Dr.Nishikawa_v1_180904.xlsx")



# get the file name for specify bam file in Genome Browser Section.
file_name_DiP<-list.files("./www/hMeDIP-seq/bam/")
file_name_DiP<-file_name_DiP[grep("\\.bam$",file_name_DiP)]

file_name_RiP<-list.files("./www/hMeRIP-seq/bam/")
file_name_RiP<-file_name_RiP[grep("\\.bam$",file_name_RiP)]

file_name_KO<-list.files("./www/RNA-seq_KO/bam/")
file_name_KO<-file_name_KO[grep("\\.bam$",file_name_KO)]

file_name_TIME<-list.files("./www/RNA-seq_Time/bam/")
file_name_TIME<-file_name_TIME[grep("\\.bam$",file_name_TIME)]


## これより下は実際には使用していないデータです。
## データの列名の変更と使用しない列を切ったデータを作成しましたが、結局使用しませんでした。
## Extraction the data
columlist_KO <- c("PValue","FDR","X1.Control","X4.Control","X2.Tet2KOTet3Het","X3.Tet2KOTet3Het","X5.Tet2KO","X6.Tet2HetTet3KO","X7.Tet3KO","ensembl_gene_id","mgi_symbol","entrezgene","chromosome_name","start_position","end_position")
columlist_TIME <- c("X__1","343_0hr__1","395_0hr__1","343_10hrs__1","395_10hrs__1","343_24hrs__1","395_24hrs__1","343_48hrs__1","395_48hrs__1")

RNA_KO_extract <- RNA_KO[,columlist_KO]
RNA_TIME_extract <- RNA_TIME[,columlist_TIME]
#change the coloum names
names(RNA_KO_extract) <- c("PValue","FDR","WT_S1", "WT_S4", "Tet2KOTet3Het_S2","Tet2KOTet3Het_S3", "Tet2KO_S5", "Tet2HetTet3KO_S6", "Tet3KO_S7", "ensenble_gene_id", "mgi_symbol", "enterzgene", "chromosome_name", "start_position", "end_position")

names(RNA_TIME_extract) <- c("mgi_symbol","WT_S343_0hr","WT_S395_0hr","WT_S343_10hrs","WT_S395_10hrs","WT_S343_24hrs","WT_S395_24hrs","WT_S343_48hrs","WT_S395_48hrs")

RNA_TIME_extract<-RNA_TIME_extract[-1,]


