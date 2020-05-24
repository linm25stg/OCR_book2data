### これは何？
**GoogleDriveに画像を投げると勝手にOCRされてドキュメントが作成される機能**を利用するスクリプトです
![](https://drive.google.com/uc?export=view&id=1_wZFvyJZMthoopWg6OC3a-3TKKWSieny)
作成者はWin10環境のWSL(Ubuntu18.04)で使用しているため、Macは知りません。

## 使用には以下のものが必要です
1. [gdrive](https://github.com/gdrive-org/gdrive)をGithubからご使用の環境に合わせてDL
    - **は？OAuth認証とか意味フwww** の方は [こちら(Qiita)](https://qiita.com/linm25stg/items/4a46ee5264b0cef24f46)を御覧ください。
    - **OAuth認証(1.client_id 2.client_secret)は取得済だけど、置換？がわかんね** の方は[こちら(teratailの自分の回答)](https://teratail.com/questions/229001?nli=5e2553a6-0f54-4f12-90fa-45ec0a28011b)を御覧ください
2. gdrive コマンドを都度入力か、本スクリプト**book2data.sh**
    - 使用コマンドは ↓

```shell
gdrive import $1 -p $2 # $1はディレクトリー。$2はGoogleDriveのディレクトリーID
gdrive export --mime text/plain ${id} # ${id}は ↑で発生したドキュメントファイルのID
gdrive delete ${id} # ドキュメントは使用容量0kbなので消さなくてもいいのでは？問題
```

## 使い方
基本処理；
```shell
$ sudo book2data.sh $1 $2
# 例
$ sudo book2data.sh /mnt/d/OCR/とある書籍/01/ 1wxzzCXPfmKZV8VnLqaeGPTW1Pxxxxx
```

## やった方が便利な事
`gdrive`もだけど`book2data.sh`に `chmod +x` で実行権限追加して、`sudo cp    /usr/local/bin` にでも入れとけば？的な
2個とも入れておけば、`book2data.sh コマンド が見つかりません ボケナス` がなくなって便利だと思う

## 駄目な部分
- GoogleDrive API の処理上限関係で 一辺に**5個以上同時**処理させると `Failed to get file: googleapi: Error 404: File not found: to., notFound` のエラーを吐きやがる
    + つまり自炊小説4冊同時変換なら大体問題がないって言うことだね！
        + (400枚 x 4個ぶち込んで2,3個問題発生する模様)
    + エラッタ場合、`gdrive delete ${id}` が実行されない場合があるので、GoogleDriveのHomeにあるドキュメントを削除してどうぞ。
    + また、スクリプトを途中終了した場合、最後の`rm -rf $workdir` 辺りが実行されないので、tmpを削除してどうぞ～

- 拡張子がtxtじゃないんだが？
    + 仕様です。 っていうか`--mime text/plain`で指定してるんだけど、謎拡張子で落ちてくるんだよね…
    + 一応`book2data.sh`の方では`asc → txt`する様に書いてるけど、Ubuntu 以外のユーザーは書き換えて、どうぞ

- 半角スペースが発生する
    + 仕様です。半角指定して置換削除すればいいんじゃないっすかねぇ(半ギレ)
        + `sed 's/ //g' ${1}/*.asc`を書いても上手く働かなかった…

- 自動的に結合して1個の`.txt`にならない
    + 頑張ったのですが、上手くいきませんでした。**是非教えて下さい！**
    + `basename`を使って、$1パスの最後のディレクトリ名を 結合txt の名前にしたいなぁって、ミサカはミサカは…

- `usage`を使った `book2data.sh --help` が無い
    + 面倒…

- ルビ多めの小説だとゴミが多い
    + はい。
        + txt としてエディタで**見ると**めっちゃ**邪魔だけど**、音声に変換して**聞いてる**と案外その辺は脳みそがスルッとスルーしてくれるので、**問題なかったり**？

- GoogleDriveのゴミ箱が混沌とする
    + 毎回デリートコマンドを自動実行してるからねぇ…

## 総括
基本的に GoogleDrive のOCR機能を使用しているので、細かい制御は聞きません。オートマです。
しかし、縦読みOK、手書きでも一部OK、印刷文字なら99％OK、挿絵は自動スルー、多言語対応 と中々使いやすいです。

1年前は表内の文字は読めなかったりしてたけど、いまは大分マシになってきたりと、勝手にUpdateされていますね。
みんなもっとデータをGoogleさんに上納すればいいと思うよ('A`)