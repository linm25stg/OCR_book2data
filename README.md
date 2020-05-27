## これは何？
**GoogleDriveに画像を投げると勝手にOCRされてドキュメントが作成される機能**を利用するスクリプトです  
![](https://drive.google.com/uc?export=view&id=1_wZFvyJZMthoopWg6OC3a-3TKKWSieny)  
* 本GIFは`Win10、WSL(Ubuntu18.04)`環境で作成されています。

## 出来ること
- `JPG`と`PNG`を`テキストデータ`に変換してくれます。
- `JPG`と`PNG`のみ対応。他は非対応。
    - 上記拡張子2種を一緒のフォルダに混ぜても構いません。
    - ファイルサイズを2MB以下にして下さい。

## 使用には以下のものが必要です
1. [**gdrive**](https://github.com/gdrive-org/gdrive)をGithubからご自身の使用の環境OSに合わせてDLして下さい
    - そのままでは使えないので、まずデフォルトの **OAuth認証を書き直す** 必要があります。 [こちら(Qiita)の記事を参照](https://qiita.com/linm25stg/items/4a46ee5264b0cef24f46)してください。
        - 上記のリンクを参照して **OAuth(1.client_id 2.client_secret)は取得済だけど、それでも認証が通らない** の方は[こちら(teratailの自分の回答)](https://teratail.com/questions/229001?nli=5e2553a6-0f54-4f12-90fa-45ec0a28011b)を御覧ください
            - 既にバイナリ書換済み、それでも通らない場合、[ここ画像の左下](https://github.com/gdrive-org/gdrive/issues/506#issuecomment-568086416) `goto <your app name>(unsafe)`の**クリックリンクを見逃している可能性が高い**です。
2. 本スクリプト[**book2data.sh**](https://github.com/linm25stg/OCR_book2data)
    - スクリプト内で使用したコマンドは ↓

```shell
gdrive import $1 -p $2 # $1はディレクトリーパス。$2はGoogleDriveのディレクトリーID
gdrive export --mime text/plain ${id} # ${id}は ↑で発生したドキュメントファイルのID
gdrive delete ${id} 
```

## インストール
Github の [releases](https://github.com/linm25stg/OCR_book2data/releases/tag/v0.9) から落として下さい。  
* **Mac OS XはLFなので**[book2data-ubuntu.sh](https://github.com/linm25stg/OCR_book2data/releases/download/v0.9/book2data-ubuntu.sh)を使って下さい

| Filename                                                                                                     | Version | 改行コード     | Shasum                                         |
| ----                                                                                                         | :--:    | :--:           | ----                                           |
| [book2data-osx.sh](https://github.com/linm25stg/OCR_book2data/releases/download/v0.9/book2data-osx.sh)       | 0.9     | CR(MacOS9以前) | SHA1: 0DD7F2E8979827F6447E6DFD1257BB1273836FC7 |
| [book2data-ubuntu.sh](https://github.com/linm25stg/OCR_book2data/releases/download/v0.9/book2data-ubuntu.sh) | 0.9     | LF             | SHA1: 82D0D148A3D21648BF6D413CAB9BF3CF752F7153 |

```shell
$ mv book2data-hoge.sh book2data.sh
$ sudo chmod +x book2data.sh
```

## やった方が便利な事
- `gdrive`を  

```shell
$ mv gdrive-hoge-x64 gdrive
$ sudo chmod +x gdrive
$ sudo cp gdrive /bin/
```

- 同じく `book2data.sh`を 

```shell
$ sudo cp book2data.sh /bin/
```

## 使い方
```shell
# 基本処理
$ sudo book2data.sh $1 $2
# 例
$ sudo book2data.sh /mnt/d/OCR/とある書籍/01/ 1wxzzCXPfmKZV8VnLqaeGPTW1Pxxxxx
```
- $1 は OCRしたい画像のディレクトリーパス
- $2 はGoogleDriveの適当なフォルダーの ID部分
    + 例 
    > https://drive.google.com/drive/u/1/folders/{フォルダID}
        + {フォルダID}の部分です。

## 以下駄文(Q&A)がQittaにあります
[[OCR] Google Driveを使ったOCRのシェルスクリプトを書いた…ような？](https://qiita.com/linm25stg/items/b870320dcca1eabe4d6f)
