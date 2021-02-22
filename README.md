# GithubのActions上でSeleniumを使ったUITestコードを実行して画像をSlackに投稿する仕組みを構築して見ました。
  
***
自分の環境で試す際には、絶対にPublicにしないこと！！！
***
##  概要
Selenium,webdriverを利用しJavascriptベースでテストを記載し利用するテストパッケージ。  
テストロジック中で必要に応じてスクリーンショットを撮影し、過去のスクリーンショットと比較することで画面表示の変化を検出する。   
また画面操作ができなかった場合もエラーが発生し処理が中断されるため、画面の動作が予期せず変わった場合についても検出可能となる。 
***
## 目次
1. 必要環境
1. 構成  
   1. ベース
   1. package.json
1. Slackの準備
1. Githubの準備
1. 実行準備
1. Github Actionsの実行
1. テスト実装方針

***
## 必要環境 
1. Node.js(Python) 
1. Visual Studio Code  
1. Githubのアカウント  
1. Git / Git bash(Windowsのみ)  
1. Sfdx Cli  
1. Salckのアカウント、ワークスペース  
1. エイリアスの使えるメールアドレス（推奨：Gmail）  
  
Nodejsは　v12 , v14　で動作確認。  
## 現在以下のWebdriverに対応。   
- chrome  
- firefox  
- safari(PC)※ドライバーにバグあり

***
## 構成
### ベース 
| ファイル名 | 説明 |
| ---- | ---- |
| .github/workflows/node.js.yaml | Github Actions用YAML | 
| package.json | Selenium,Webdriber,resembleJS ,Slack／Boltなどの必要なパッケージを記載 | 
| runCheck.js | 新旧のフォルダの同名の画像同士を比較して、差分画像データと差分率を出力する | 
| runCheck.sh | 上記差分チェックのスクリプトをコールする |
| runGitandPostSlack.sh | テスト結果の画像をZIPに固めてSlackにPost＆画像フォルダをgitコミットプッシュ |
| runMain.sh | メインのプログラム、共通の設定値はここに記載。 |
| runPostSlack.js  | runCheckの標準出力をSlackに加工して投稿するためのスクリプト |
| runPostSlackFile.sh  | 引数に指定したファイルをSlackにポストするスクリプト |
| runTest.js     | テストを呼び出す呼び出しもとのスクリプト |
| runTest.sh     | テストスクリプトを呼び出すシェル。スクリーンショットを保存先フォルダをクリアする |
| /lib/testUtil  | スクロール、スクリーンショット、クリックなど。  |
| /lib/FileUtil  | ファイルの検索、ディレクトリの検索など  |
| /lib/SlackUtil | Slackへのテキスト、画像のポスト  |
| /lib/ImageUtil | 画像の比較。  |
| /lib/LineReader | ファイルから１行ずつ読み込む  |

***  
## package.json
| ファイル名 | 説明 |
| ---- | ---- |
| @slack/bolt | Slcak投稿用のパッケージ | 
| chromedriver | Chrome用Web Driver | 
| date-utils | 日付操作を追加するパッケージ | 
| expect.js | テスト用フレームワーク。期待値と実際の値の比較結果を出したりするのに利用する。 Jest。現在未使用 | 
| fs-extra | ファイル、ディレクトリ操作のためのパッケージ | 
| geckodriver | firefox用Web Driver | 
| mocha | テスト用フレームワーク。Assertを出したりするのに利用する | 
| path | ファイルフォルダのパスを取り扱うためのパッケージ | 
| resemblejs | ２つの画像を比較して差分画像を生成する | 
| selenium-webdriver | Selenium本体 | 
| sleep | Sleep処理を入れるためのパッケージ | 
  　
  
***
## 1) Slackの準備  

1. Slackのワークスペース、アカウントを用意 
1. https://api.slack.com/apps にアクセスする  
1. 「Basic Information」から「App Credential」を参照し「Client Secret」をメモ  
1. 「Create Your Apps」からアプリを作成する  
1. Permissonsを設定する。「Add an OAuth Scope」を押下し以下の権限をセットする。
    1. channel : join  
    1. chat : write  
    1. files : write   
1. 「Install to Workspace」をクリック  
1. 「許可する」をクリック  
1. 「Bot User OAuth Access Token」をメモ「xoxb-hogehohe」  
1. Slackのワークスペースに移動　　
1. ChannelID：URLの「higehige」部分をメモ「https://app.slack.com/client/hogehoge/higehige」  
1. チャンネルへ作成したアプリを招待する。「チャンネル」→「詳細」→「その他」→「アプリを追加する」で３）で用意したアプリを選択して追加。

## 2) Salesforce認証キーの取得
  
1. ローカルの開発環境へ移動（テストするSandbox環境）  
1. sfdx force:org:display -u <username> --verbose  
1. 「Sfdx Auth Url」の値をメモ 

***
## 3) Github側の準備  

1. 新規のRepositryを用意
1. 本Repositryのソースをコピーして、上記のリポジトリにPush  
1. 公開したくないキー情報などを登録する。「Settings」→「Secret」→「New repositry secret」を押下する
   1. 「SFDX_AUTH_URL」： 2)3.でメモした物を保存
   1. 「SLACK_SIGNING_SECRET」： 1)4.でメモした物保を存
   1. 「SLACK_BOT_TOKEN」： 1)8.でメモした物を保存
   1. 「SLACK_CHANNEL」： 1)10.でメモした物を保存
***
  
***
## 3) 実行
### (1)【ローカル実行の場合】 テスト環境用にBranchを作成して設定を編集  
  
1. 3)で用意した環境でBranchを作成（環境名などでOK）
1. key.authの中身を４)3.でメモした物に差し替えて保存
1. runMain.shの「SLACK_SECRET_KEY」の値を1)4.でメモした物に書き換え
1. runMain.shの「SLACK_TOKEN」の値を1)8.でメモした物に書き換え
1. runMain.shの「SLACK_CHANNEL」の値を1)10.でメモした物に書き換え
1. runMain.shの「GIT_EMAIL」のEメールアドレスをGithubで利用しているメールアドレスに書き換え
1. runMain.shの「GIT_USERNAME」のユーザ名を自分の名前に書き換え
1. Windowsの場合ZIPコマンドで失敗するため、ZIPコマンドとZIPコマンドをSlackに投稿する部分をコメントアウトする
  1. runCheck.jsのzipコマンド及び`node runPostSlack`部分をコメントアウト
  1. runGitandPostSlack.jsのzipコマンド及び`node runPostSlack`部分をコメントアウト
1. ./runMain.shを実行

### (2)【Github　Actionsから実行の場合】 Github上で設定を編集  
1. 「Actions」を押下 
1. 「SeleniumTest」を押下 
1. 「Run workflow」のボタンが表示されていることを確認   
1. 「Run workflow」を押下。
1. 表示されたダイアログに従って入力
1. 「Run」ボタンを押下

## 4) テスト実装方針
### (1) runTest.js内にテストロジックを記載する方針　　
  個別のテストを記載する場合にはフォルダを切って、その中でテストロジックを記載することを推奨する。  
  runTest.js以外のファイルについてはできる限り編集しないこと。＊runMain.shの設定値は除く。  
### (2) test.js内にテストロジックを記載する方針　　
　　テストメソッドについては以下のロジックを記載すること
   1. 個別のテストメソッド内ではwebDriverを作成する。
   1. 画面の操作を記載する。
   1. 必要に応じてフレームワークによる値チェックなども行う。
   1. スクリーンショットを撮影する。
   1. スクリーンショットのファイル名については、画像の比較に利用するため実施ごとにファイル名が変わらないように実装する。



