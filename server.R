##
## deploy environment
##
library(shiny)


# 関数の説明
# GPが名前につく関数はGenome Browser表示用の関数
# 


# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  output$GP <- renderPlot({
    # このifでmgiで絞るのかmanualで絞るのかを判断
    if(input$varm==1){
    Chromosome_input = paste("chr",as.character(RNA_KO[RNA_KO$mgi_symbol==input$GB_name,17]),sep = "")
    Start_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,18]
    End_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,19]
    }
    else{
       Chromosome_input = paste("chr",input$chr,sep = "")
       Start_input = as.numeric(input$start)
       End_input = as.numeric(input$end)
     }
    Sample=paste("./www/RNA-seq_KO/bam/",input$Sample_name,sep="")
    #show how amount of gene expression around selected gene
    kid <- AlignmentsTrack(Sample,stacking="dense")

    #show where is our plot in whole chromosome
    itrack <- IdeogramTrack(genome = "mm10", chromposome = Chromosome_input)

    # show gene relationship in our area
    gtTrack <- GeneRegionTrack(TxDb.Mmusculus.UCSC.mm10.knownGene, chromosome = Chromosome_input, start=Start_input,end=End_input)

    #plot
    plotTracks(c(itrack,kid,gtTrack), chromosome = Chromosome_input, start=Start_input,end = End_input, transcriptAnnotation="Name", type="pileup")
  })
  
  
  output$GP_D <- renderPlot({
    if(input$varm==1){
    Chromosome_input = paste("chr",as.character(RNA_KO[RNA_KO$mgi_symbol==input$GB_name,17]),sep = "")
    Start_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,18]
    End_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,19]
  }
    else{
      Chromosome_input = paste("chr",input$chr,sep = "")
      Start_input = as.numeric(input$start)
      End_input = as.numeric(input$end)
    }
    
    Sample_D=paste("./www/hMeDIP-seq/bam/",input$Sample_name_D,sep="")
    #show how amount of gene expression around selected gene 
    kid_D <- AlignmentsTrack(Sample_D,stacking="hide")
    
    #show where is our plot in whole chromosome
    itrack_D <- IdeogramTrack(genome = "mm10", chromposome = Chromosome_input)
    
    # show gene relationship in our area
    gtTrack_D <- GeneRegionTrack(TxDb.Mmusculus.UCSC.mm10.knownGene, chromosome = Chromosome_input, start=Start_input,end=End_input)
    
    #plot
    plotTracks(c(itrack_D,kid_D,gtTrack_D), chromosome = Chromosome_input, start=Start_input,end = End_input, transcriptAnnotation="Name", type="pileup")
  })


  output$GP_R <- renderPlot({
    if(input$varm==1){
      Chromosome_input = paste("chr",as.character(RNA_KO[RNA_KO$mgi_symbol==input$GB_name,17]),sep = "")
      Start_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,18]
      End_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,19]
    }
    else{
      Chromosome_input = paste("chr",input$chr,sep = "")
      Start_input = as.numeric(input$start)
      End_input = as.numeric(input$end)
    }
    
    Sample_R=paste("./www/hMeRIP-seq/bam/",input$Sample_name_R,sep="")
    #show how amount of gene expression around selected gene 
    kid_R <- AlignmentsTrack(Sample_R,stacking="hide")
    
    #show where is our plot in whole chromosome
    itrack_R <- IdeogramTrack(genome = "mm10", chromposome = Chromosome_input)
    
    # show gene relationship in our area
    gtTrack_R <- GeneRegionTrack(TxDb.Mmusculus.UCSC.mm10.knownGene, chromosome = Chromosome_input, start=Start_input,end=End_input)
    
    #plot
    plotTracks(c(itrack_R,kid_R,gtTrack_R), chromosome = Chromosome_input, start=Start_input,end = End_input, transcriptAnnotation="Name", type="pileup")
  })


  output$GP_T <- renderPlot({
    if(input$varm==1){
      Chromosome_input = paste("chr",as.character(RNA_KO[RNA_KO$mgi_symbol==input$GB_name,17]),sep = "")
      Start_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,18]
      End_input = RNA_KO[RNA_KO$mgi_symbol==input$GB_name,19]
    }
    else{
      Chromosome_input = paste("chr",input$chr,sep = "")
      Start_input = as.numeric(input$start)
      End_input = as.numeric(input$end)
    }
    Sample_T=paste("./www/RNA-seq_Time/bam/",input$Sample_name_T,sep="")
    #show how amount of gene expression around selected gene 
    kid_T <- AlignmentsTrack(Sample_T,stacking="hide")
    
    #show where is our plot in whole chromosome
    itrack_T <- IdeogramTrack(genome = "mm10", chromposome = Chromosome_input)
    
    # show gene relationship in our area
    gtTrack_T <- GeneRegionTrack(TxDb.Mmusculus.UCSC.mm10.knownGene, chromosome = Chromosome_input, start=Start_input,end=End_input)
    
    #plot
    plotTracks(c(itrack_T,kid_T,gtTrack_T), chromosome = Chromosome_input, start=Start_input,end = End_input, transcriptAnnotation="Name", type="pileup")
  })
  
  # mgiシンボルで指定して行を抜き出して表示
  # DTはdata tableを綺麗に表示するためのオプション
  # DTのオプションの参考リンク
  output$KO_table <- DT::renderDataTable(
    subset(RNA_KO, RNA_KO$mgi_symbol %in% input$mgi_input_pko),
    options = list(scrollX=TRUE,dom="Bfrtip",
                   buttons = I('colvis')),
    extensions = 'Buttons',
    rownames=FALSE
  )
  
  # 入力された値以下のp値を持つ遺伝子のmgiを出力
  output$p_mgi <- renderText({
    as.character(subset(RNA_KO,RNA_KO$PValue<as.numeric(input$p))$mgi_symbol)
  })
  

# FDRについて一つ上の関数と同様
  output$FDR_mgi <- renderText({
    as.character(subset(RNA_KO,RNA_KO$FDR<as.numeric(input$FDR))$mgi_symbol)
  })
})
