##
## test environment
##


library(shiny)
library(shinydashboard)

## Shiny Module を使用しようと思いましたが、UIが固定される(同じクラスから複製した部品を連続して置かなければならない)ので今回は採用できませんでした。

# tabPanelで二つのページを作成しています
# 基本的に関数名にInputが含まれているのはデータ出力に必要なデータを入力するところです。
# column(6,)というのはfluidRowの中で使える文でページの横幅を指定します。
# 端から端までを12ブロックと考えて、columnの中に記述する部分をどれだけの大きさで表示したいかを決めます。(column(6,A)ならAはウィンドウの半分の大きさになる)


# Define UI for application that draws a histogram
ui <- navbarPage(
  "Detect Differential",
  # 一つ目のタブを記述
  tabPanel(
    "Gviz",
    fluidPage(
    titlePanel("Select Gene and Sample in every experiment"),
    fluidRow(
      column(6,
      # Gvizで表示する範囲をmgi or manualどちらで決めるのか選択
             radioButtons("varm",label="select mgi or manual",choices=list("mgi"=1,"manual"=2))
             )
    ),
    fluidRow(
      column(6,
      # それぞれのサンプルについてmgiを入力
        selectInput('GB_name', 'gene_name',selected = "Gnai3", unique(as.character(RNA_KO$mgi_symbol)), selectize=TRUE),
        selectInput("Sample_name", "Sample_name(RNA_KO)", file_name_KO, selectize =TRUE),
        selectInput("Sample_name_D", "Sample_name(MeDiP)", file_name_DiP, selectize =TRUE),
        selectInput("Sample_name_R", "Sample_name(MeRiP)", file_name_RiP, selectize =TRUE),
        selectInput("Sample_name_T", "Sample_name(TIME)", file_name_TIME, selectize =TRUE)
    ),
      column(6,
             selectInput("chr","chromosome_name",unique(RNA_KO$chromosome_name),selectize = TRUE),
             textInput("start","start point"),
             textInput("end","end point")
      )
    ),
    hr(),hr(),
    fluidRow(
      # グラフを表示
      column(6,h3("KO"),plotOutput("GP")),
      column(6,h3("MeDIP"),plotOutput("GP_D"))
    ),
    fluidRow(
      # グラフを表示
      column(6,h3("TIME"),plotOutput("GP_T")),
      column(6,h3("MeRIP"),plotOutput("GP_R"))
    )
    )
  ),
  # 二つ目のタブを記述
  tabPanel(
    "PValue&FDR",
    fluidPage(
      titlePanel("filter by pvalue and FDR"),
      fluidRow(
        # 各Sample毎にP値とFDRでフィルタリングする2018/12/27現在RNA-seqしかその値は計算されていない
        column(3,
               h2("KO Sample"),
               # P値の初期値を決める valueのところに初期値を入れる
               textInput("p","pvalue",value="0.0000001"),
               # FDRの初期値を決める
               textInput("FDR",label="FDR",value="0.001"),
               # 表示したい遺伝子のmgi_symbolを入力
               selectInput("mgi_input_pko","mgi_symbol(RNA_KO)",c(Choose='Gnai2',unique(as.character(RNA_KO$mgi_symbol))), selectize = TRUE,multiple = TRUE)
               ),
        column(3,
               h2("TIME Sample"),
               textInput("p","pvalue",value="0.0000001"),
               textInput("FDR",label="FDR",value="0.001"),
               selectInput("mgi_input_p","mgi_symbol(RNA_KO)",c(Choose='Gnai2',unique(as.character(RNA_KO$mgi_symbol))), selectize = TRUE,multiple = TRUE)
        ),
        column(3,
               h2("MeDIP Sample"),
               textInput("p","pvalue",value="0.0000001"),               
               textInput("FDR",label="FDR",value="0.001"),
               selectInput("mgi_input_p","mgi_symbol(RNA_KO)",c(Choose='Gnai2',unique(as.character(RNA_KO$mgi_symbol))), selectize = TRUE,multiple = TRUE)
        ),
        column(3,
               h2("MdRIP Sample"),
               textInput("p","pvalue",value="0.0000001"),
               textInput("FDR",label="FDR",value="0.001"),
               selectInput("mgi_input_p","mgi_symbol(RNA_KO)",c(Choose='Gnai2',unique(as.character(RNA_KO$mgi_symbol))), selectize = TRUE,multiple = TRUE)
        )
        
      ),
      #　以下の部分でまだデータが出揃っていない部分(RNA-seq以外のpとfdr)はコードをコメントアウトしています。
      # KO_PはRNA-seq_KOのp値でフィルタリングをかけた遺伝子名を表示するところです
      # KO_FDRは同様にFDRです
      # KO_tableは指定したmgi名でデータテーブルからその行を抜き取ってきます。
      # TIME, MeRIP, MeDIPについては、データと関数を用意すれば同様のレイアウトになるようにしてあります。(アウトプットの名前(関数名)は変更する必要があります。)
      # 関数名を一意なものにする必要あり。内容に関してはKOのデータを表示する関数server.RのKO_table関数を参考にしてください。
      fluidRow(
        # KOに関するデータを表示する部分
        column(12, wellPanel(
            column(12, 
              h3("KO_P"),
              textOutput("p_mgi")
            ),
          column(12,
              h3("KO_FDR"),
              textOutput("FDR_mgi")
          ),
          column(12,
              h3("KO_DataTable"),
              div(DT::dataTableOutput("KO_table"),style="font-size:50%")
          )))
      ),
      fluidRow(
        # 残りのサンプル
        column(12, wellPanel(
          column(12,
                 h3("TIME_Pvalue")
                 #textOutput("p_mgi")
          ),
          column(12,
                 h3("TIME_FDR")
                 #textOutput("FDR_mgi")
          ),
          column(12,
                h3("TIME_DataTable")
                # DT::dataTableOutput("Table_TIME")
          )
        )),
        column(12, wellPanel(
          column(12,
                 h3("DIP_Pvalue")
                 #textOutput("p_mgi")
          ),
          column(12,
                 h3("DIP_FDR")
                 #textOutput("FDR_mgi")
          ),
          h3("DIP_DataTable")
          #DT::dataTaleOutput("mgi_p")
        )),
        column(12, wellPanel(
          column(12,
                 h3("RIP_Pvalue")
                 #textOutput("p_mgi")
          ),
          column(12,
                 h3("RIP_FDR")
                 #textOutput("FDR_mgi")
          ),
          h3("RIP_DataTable")
          #DT::dataTableOutput("mgi_p")
        ))
      )
    )
  )
)