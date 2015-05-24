#!/bin/sh

#开始生成代码的标识点
tag="\/\*auto token\*\/"
#即将添加自动代码的目标文件名
target_file=parser.y
#添加代码后的新文件
new_target_file=${target_file%.*}"_autocode.y"
#存放关键字列表文件
keywords_file=keywords.txt

#临时文件
statement_file=$keywords_file.y.tmp

#确保删除临时文件
rm -f $statement_file

#生成代码到临时文件
keylist=`sort -u $keywords_file`
for i in $keylist
do
    tmp="$(echo $i | tr '[:lower:]' '[:upper:]')"
    echo "%token $tmp" >>$statement_file
done

#查找目标文件中的标识位置
line=`grep -n "${tag}" $target_file|head -n 1|cut -d ":" -f 1`
if [ $((line)) = 0 ] ;then
    echo error:not find the auto code tag!
    exit
fi


#添加自动代码到目标文件中
sed "${line} r $statement_file" $target_file >$new_target_file

#确保删除临时文件
rm -f $statement_file
