# shinyで実験結果を可視化するwebアプリの開発 (妹尾先生のアルバイト)
- shiny-appの開発状況確認方法
松田研究室のネットに接続されてるパソコンのブラウザにて  
192.168.1.99:3838/sample-apps/arbeit_shiny
と打ち込む(動き出しました)

- ファイル説明
	- global.R : アプリを開始するときに一度だけ実行する処理を入れる。  
	データの読み込み、ライブラリの読み込み

	- ui.R server.R : アプリ本体

	- www : 使用するデータや画像などを入れるところ、容量が大きいのでgitlabにはあげない。

- コード説明
  - 基本的にはコード内のコメントを見ていただくのが早いかと思います
  - ubuntuのRstudioが英語しか入力できなかったので最初に書いた部分は英語になっていますがご了承ください
  - 今回は僕の時間が足らずP値とFDRが準備できなかったサンプルについて
    - 値やサンプルが用意できれば、現在KOのサンプルについて私が作成した関数と同じように作成してもらえれば動くと思いますが、関数名と入力の変数のid(たいていインプット関数の第一引数)はこのアプリ内で一意になるようにしてください。
  - 名前空間を完結にするshiny moduleについては私の調査不足かもしれませんが、inputとoutputのレイアウト上の場所を連続にする必要があるという問題を解決できなかたので採用を諦めました。

# ここから下はアプリ仕様に無関係の項目です
## shinyserverの開発情報
- インストールはshiny server install (OS名)とかで

- https://support.rstudio.com/hc/en-us/articles/214771447-Shiny-Server-Administrator-s-Guide　は参考になる　

- 新しいアプリを作成してdeployするときにパッケージがインストールされていないというエラーが出る(The application exited during initialization.)  
→ローカルのRの環境とは別にshiny serverに対してパッケージを入れなくてはいけない。(shinyserverからR自体への参照はしてるっぽい？)以下のコマンドでshiny serverに必要なパッケージをインストール、例えばshiny dashboardの場合  
``` 
sudo su - -c "R -e \"install.packages('shinydashboard', repos='https://cran.rstudio.com/')\""
```

* ポート番号の変更
	* /etc/shiny-server/shiny-server.conf のLISTENのところを変更
* エラーの詳細表示
	* /etc/shiny-server/shiny-server.conf　に `sanitize off;` を追加


# 開発環境？
/srv/shiny-server/sample-apps/arbeit_shiny  
をRstudioを開いて開発

/arbeit/TetTet/shiny/
みたいなところにgit用のディレクトリとreadmeがある(もろもろの事情で。。)  
Rmdでテストコードを書いて、shinyに移植する流れ  


# 開発メモ
shinyはローカルで実行した時に、rstudioのenviromentにある変数も参照できる  
server.R内の一つのrender関数で定義した変数は別のrender関数の中からは参照できない  
使いたい変数はすべてglobal.Rで定義しておく必要がある  
shinydashboardのtabはまだ動かない  


UbuntuでRの環境をセッティングする場合、ターミナルからインストールしておくべきライブラリ。
そのパッケージが無いとinstall.packageができないライブラリがある  
shinyのuiでは各パーツを呼び出すときにつける名前(tabのtabnameとか)には半角スペースを入れない、もし入れるとそのページがなかったことにされる  


コマンドの前にはsudo をつけましょう
## httr, RCurl
```
apt-get install libcurl4-openssl-dev
```
## RMySQL
```
apt-get install libdbd-mysql libmysqlclient-dev
```

## maptools
```
apt-get install libgeos-dev
```

## XML
```
apt-get install libxml2-dev
```
## 探し方

インストール時のエラーを見るとこのパッケージが無いよって言われるので
```
checking for xml2-config... no
Cannot find xml2-config
ERROR: configuration failed for package ‘XML’
```

その名前をターミナルで打ち込んで見る
ブラウザで検索してみるなどしてインストール



## Gviz
ゲノムの染色体上での位置を図示する  
shiny上でやりたいことは、mgisymbolを選択してもらう。そのsymbolをkeyにchromosomeとstart,endを抜いてきてその遺伝子が染色体の中でどのような箇所にあって、どれくらい発言しているのかどうかを見る  
bamファイルを簡単にとりつけるよ、以下参照
https://mrccsc.github.io/VisualisingGenomicsData/solutions/AlignmentTrack_Solutions.html
## データの準備
どんなデータも遺伝子名、サンプル名、発現量、p,hold changeを入れる
各データを取り込んでデータを上記の形に整形する関数をそれぞれにつきおいておく。 
