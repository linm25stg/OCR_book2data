#!/bin/bash

#### 目的：jpgをOCRして快適読書生活！！
# ファイル結合 して 半角スペース削除 機能の付け方を教えてくださるとありがたいです(´；ω；｀)

# 作業用ディレクトリ
workdir=$(mktemp -d); # -d オプションは dir作成の意味
# 作業用ファイル
tmpfile=$(mktemp)

### ファイルを作業用フォルダへ。空白、2バイト文字等でエラるからね…
if [ -d $1 ]; then
  filename=${1##*/};
  cp ${1}/*.jpg ${workdir};
fi # el
if [ -d $1 ]; then
  filename=${1##*/};
  cp ${1}/*.png ${workdir};
fi


### OCR処理
# $1=指定作業dir | $2=ID | ${workdir}=${f}=\rootfs\tmp の作業dir |
# 基本処理； $ bash book2data.sh /mnt/d/OCR/とある書籍/01/ 1wxzzCXPfmKZV8VnLqaeGPTW1Pxxxxx

# if [ -f ${workdir}/*.jpg ]; then
  for f in $(ls ${workdir}/*.jpg); do
    id=`gdrive import ${f} | awk '{print $2}'`; # " -p " 入れないと指定ディクトリではなくホームにブチ込まれる
    gdrive export --mime text/plain ${id};
    # mv ${1}/*.asc ${workdir}
    gdrive delete ${id};

    echo "Finish "${f}
  done
# elif [ -f ${workdir}/*.png ]; then
  for f in $(ls ${workdir}/*.png); do
    id=`gdrive import ${f} | awk '{print $2}'`;
    gdrive export --mime text/plain ${id};
    # mv ${f##*/}".txt" ${workdir}
    gdrive delete ${id};

    echo "Finish "${f}
  done
# fi

### ファイル結合、半角空白削除
# どうやってもうまく行かなかった為、コメントアウト

# filelist=(` ls -v ${1}/*.asc`) # -v は自然順ソート
# cp ${filelist[0]} out.asc
# for a in ${filelist[@]:1}; do
#   paste out.asc $a > out0.asc
#   mv out0.asc 01x.txt
# done

# sed 's/ //g' ${1}/*.asc

### 拡張子変更。手元Ubuntuではascで落ちてくるけど、Macとかは別拡張子で **要編集** かも？
# Win10だと.asmの模様

for fname in *.asc; do # ←拡張子がascのファイルが存在する限り、以下の命令を繰り返す
  mv $fname ${fname%.asc}.txt; # 未検証の為、txt拡張子になってるかは知らん。
  # mv $fname ${fname%.asc}.asm; ← 個人用の為、コメントアウト
done


##### 修了処理
rm -rf $workdir;
rm $tmpfile
