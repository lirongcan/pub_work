# 实用脚本

找到go文件的路径再去掉框架生成的文件再将文件内容通过管道输出，再查询文件内容中包含关键字上下60行的信息
find . -type f -name '*.go' | grep -v -E 'clients|thrift_gen|kitex_gen|\.csv|vendor|idl|.git|kite.go'| xargs grep --color -A 60 -B 60 -Iin -E 'courseId|goodsId|relatedId|MGetGoodsByRelatedId|GetGoodsByRelatedId'

tce实例内部关键字搜索（一条log实质上是一行）

cd /opt/tiger/toutiao/log/app;find . -type f -name '*.log.*' | xargs grep -
find . -type f -name '*.log.*' | xargs grep -vE 

# 查看mac本地的ip地址
ifconfig en0

直接输出字符串是: 
ifconfig en0 | grep 'inet ' | awk '{print $2}'

# 切换到root
sudo -i

# 文件描述符与流重定向

exec 数字<文件名 表示创建一个文件描述符，用于读取对应文件
如 
exec 4<test.txt
exec 5>test.txt
exec 6>>test.txt
<表示读取
>表示覆盖写
>>表示追加写


使用大于号对内容进行重定向
echo "test" >&5

&5表示文件描述符为5的覆盖写的文件（exec 5>test.txt定义的），>&5表示将流重定向到文件描述符为5的文件

文件描述符0，1，2分别默认表示stdin stdout stderr


# 文件权限问题
常用的linux文件权限：
444 r--r--r--
600 rw-------
644 rw-r--r--
666 rw-rw-rw-
700 rwx------
744 rwxr--r--
755 rwxr-xr-x
777 rwxrwxrwx
从左至右，1-3位数字代表文件所有者的权限，4-6位数字代表同组用户的权限，7-9数字代表其他用户的权限。
而具体的权限是由数字来表示的，读取的权限等于4，用r表示；写入的权限等于2，用w表示；执行的权限等于1，用x表示；
通过4、2、1的组合，得到以下几种权限：0（没有权限）；4（读取权限）；5（4+1 | 读取+执行）；6（4+2 | 读取+写入）；7（4+2+1 | 读取+写入+执行）
以755为例：
1-3位7等于4+2+1，rwx，所有者具有读取、写入、执行权限；
4-6位5等于4+1+0，r-x，同组用户具有读取、执行权限但没有写入权限；
7-9位5，同上，也是r-x，其他用户具有读取、执行权限但没有写入权限。



# 报警
(qps >= 100 and error_rate >= 0.0005) or (qps < 100 and qps >= 10 and error_rate >= 0.001) or (qps < 10 and qps >= 1 and error_rate >= 0.005) or (qps < 1 and qps > 0 and error_rate >= 0.01)



# gofmt

gofmt -w 目录





# rm删除文件或文件夹

-i 删除前逐一询问确认。
-f 即使原档案属性设为唯读，亦直接删除，无需逐一确认。
-r 将目录及以下之档案亦逐一删除。

rm  test.txt 
rm：是否删除 一般文件 "test.txt"? y  

rm  homework  
rm: 无法删除目录"homework": 是一个目录  

rm  -r  homework  
rm：是否删除 目录 "homework"? y 

rm -r * 删除当前目录下的所有文件和目录

文件一旦通过rm命令删除，则无法恢复，所以必须格外小心地使用该命令。



# alias为命令设置别名
alias 自定义快捷='命令'
alias add='git add .'
alias commit='git commit'
alias addcommit='git add .;git commit'

# 判断文件和目录是否存在
[]和test，两者是一样的，在命令行里test expr和[ expr ]的效果相同。test的三个基本作用是判断文件、判断字符串、判断整数。支持使用与或非将表达式连接起来。

[ -f filename ] && 如果存在怎么做 || 如果不存在怎么做
把选项f换成d就变成目录的判别

# date时间戳与时间
date -r1627725044 将时间戳转换为时间
date +%s 当前时间戳


# scp远程拷贝文件命令
scp
scp -2 lirongcan@10.227.78.117:远程文件路径 本地目录

-r: 递归复制整个目录

# tail
tail 参数 文件名
-f 循环读取
-q 不显示处理信息
-v 显示详细的处理信息
-c<数目> 显示的字节数
-n<行数> 显示文件的尾部 n 行内容
--pid=PID 与-f合用,表示在进程ID,PID死掉之后结束
-q, --quiet, --silent 从不输出给出文件名的首部
-s, --sleep-interval=S 与-f合用,表示在每次反复的间隔休眠S秒

tail 文件 默认显示最后10行
tail -n +20 文件名 从第20行到文件末尾
tail -c 10 文件名 显示文件最后10个字符


# cp

cp [options] source dest

cp [options] source... directory

-a：此选项通常在复制目录时使用，它保留链接、文件属性，并复制目录下的所有内容。其作用等于dpR参数组合。
-d：复制时保留链接。这里所说的链接相当于 Windows 系统中的快捷方式。
-f：覆盖已经存在的目标文件而不给出提示。
-i：与 -f 选项相反，在覆盖目标文件之前给出提示，要求用户确认是否覆盖，回答 y 时目标文件将被覆盖。
-p：除复制文件的内容外，还把修改时间和访问权限也复制到新文件中。
-r：若给出的源文件是一个目录文件，此时将复制该目录下所有的子目录和文件。
-l：不复制文件，只是生成链接文件。


# find命令
find   path   -option   [   -print ]   [ -exec/-execdir   -ok   command ]   {} \;（\;前是有空格的, {}代表匹配到的所有东西）

-exec 会运行指定的任何命令，而 -execdir 则从文件所在的目录运行指定的命令，而不是在运行find` 命令的目录运行指定的命令

find 根据下列规则判断 path 和 expression，在命令列上第一个 - ( ) , ! 之前的部份为 path，之后的是 expression。如果 path 是空字串则使用目前路径(mac不会)，如果 expression 是空字串则使用 -print 为预设 expression。

expression 中可使用的选项有二三十个之多，在此只介绍最常用的部份。
-exec，find命令对匹配的文件执行该参数所给出的shell命令。相应命令的形式为'command' {} \;，注意{ }和\之间的空格
-mount, -xdev : 只检查和指定目录在同一个文件系统下的文件，避免列出其它文件系统中的文件
-amin n : 在过去 n 分钟内被读取过
-anewer file : 比文件 file 更晚被读取过的文件
-atime n : 在过去n天内被读取过的文件
-cmin n : 在过去 n 分钟内被修改过
-cnewer file :比文件 file 更晚被更新的文件
-ctime n : 在过去n天内被修改过的文件
-empty : 空的文件-gid n or -group name : gid 是 n 或是 group 名称是 name
-ipath p, -path p : 路径名称符合 p 的文件，ipath 会忽略大小写
-name name, -iname name : 文件名称符合 name 的文件。iname 会忽略大小写
-size n : 文件大小 是 n 单位，b 代表 512 位元组的区块，c 表示字元数，k 表示 kilo bytes，w 是二个位元组。
-type c : 文件类型是 c 的文件。
d: 目录
c: 字型装置文件
b: 区块装置文件
p: 具名贮列
f: 一般文件
l: 符号连结
s: socket
-pid n : process id 是 n 的文件
你可以使用 ( ) 将expression分隔，并使用下列运算。
exp1 -and exp2
! expr
-not expr
exp1 -or exp2
exp1, exp2




# xargs
管道实现的是将前面的输出stdout作为后面的输入stdin，但是有些命令不接受管道的传递方式。例如：ls，这是为什么呢？因为有些命令希望管道传递过来的是参数，但是直接使用管道有时无法传递到命令的参数位。这时候就需要xargs，xargs实现的是将管道传递过来的stdin进行处理然后传递到命令的参数位置上

默认命令是echo

command | xargs -? command

-a file 从文件中读入作为 stdin
-e flag ，注意有的时候可能会是-E，flag必须是一个以空格分隔的标志，当xargs分析到含有flag这个标志的时候就停止。
-p 当每次执行一个argument的时候询问一次用户。
-n num 后面加次数，表示命令在执行的时候一次用的argument的个数，默认是用所有的。
-t 表示先打印命令，然后再执行。
-i 或者是-I，这得看linux支持了，将xargs的每项名称，一般是一行一行赋值给 {}，可以用 {} 代替。
-r no-run-if-empty 当xargs的输入为空的时候则停止xargs，不用再去执行了。
-s num 命令行的最大字符数，指的是 xargs 后面那个命令的最大命令行字符数。
-L num 从标准输入一次读取 num 行送给 command 命令。
-l 同 -L。
-d delim 分隔符，默认的xargs分隔符是回车，argument的分隔符是空格，这里修改的是xargs的分隔符。
-x exit的意思，主要是配合-s使用。。
-P 修改最大的进程数，默认是1，为0时候为as many as it can ，这个例子我没有想到，应该平时都用不到的吧。

例子:
cat test.txt | xargs
a b c d e f g h i j k l m n o p q r s t u v w x y z

cat test.txt | xargs -n3
-n 选项多行输出
a b c
d e f
g h i
j k l
m n o
p q r
s t u
v w x
y z


echo "nameXnameXnameXname" | xargs -dX
-d 选项可以自定义一个定界符
name name name name

sk.sh文件的内容:
echo $*


cat arg.txt | xargs -I {} ./sk.sh -p {} -l

-p aaa -l
-p bbb -l
-p ccc -l

ls *.txt | xargs -i mv {} /test 将所有的txt文件移动到/test目录下
用 rm 删除太多的文件时候，可能得到一个错误信息：/bin/rm Argument list too long. 用 xargs 去避免这个问题



# grep

grep 选项 pattern 文件/目录名...

-a 或 --text : 不要忽略二进制的数据。
-A<显示行数> 或 --after-context=<显示行数> : 除了显示符合范本样式的那一列之外，并显示该行之后的内容。
-b 或 --byte-offset : 在显示符合样式的那一行之前，标示出该行第一个字符的编号(整个文件的第几个字符)。
-B<显示行数> 或 --before-context=<显示行数> : 除了显示符合样式的那一行之外，并显示该行之前的内容。
-c 或 --count : 计算符合样式的列数。
-C<显示行数> 或 --context=<显示行数>或-<显示行数> : 除了显示符合样式的那一行之外，并显示该行之前后的内容。
-d <动作> 或 --directories=<动作> : 当指定要查找的是目录而非文件时，必须使用这项参数，否则grep指令将回报信息并停止动作。
-e<范本样式> 或 --regexp=<范本样式> : 指定字符串做为查找文件内容的样式。
-E 或 --extended-regexp : 将样式为延伸的正则表达式来使用。
-f<规则文件> 或 --file=<规则文件> : 指定规则文件，其内容含有一个或多个规则样式，让grep查找符合规则条件的文件内容，格式为每行一个规则样式。
-F 或 --fixed-regexp : 将样式视为固定字符串的列表。
-G 或 --basic-regexp : 将样式视为普通的表示法来使用。
-h 或 --no-filename : 在显示符合样式的那一行之前，不标示该行所属的文件名称。
-H 或 --with-filename : 在显示符合样式的那一行之前，表示该行所属的文件名称。
-i 或 --ignore-case : 忽略字符大小写的差别。
-l 或 --file-with-matches : 列出文件内容符合指定的样式的文件名称。
-L 或 --files-without-match : 列出文件内容不符合指定的样式的文件名称。
-n 或 --line-number : 在显示符合样式的那一行之前，标示出该行的列数编号。
-o 或 --only-matching : 只显示匹配PATTERN 部分。
-q 或 --quiet或--silent : 不显示任何信息。
-r 或 --recursive : 此参数的效果和指定"-d recurse"参数相同。
-s 或 --no-messages : 不显示错误信息。
-v 或 --invert-match : 显示不包含匹配文本的所有行。
-V 或 --version : 显示版本信息。
-w 或 --word-regexp : 只显示全字符合的列。
-x --line-regexp : 只显示全列符合的列。
-y : 此参数的效果和指定"-i"参数相同。

# sed

sed [options]... 'script' inputfile


-n：不输出模式空间内容到屏幕，即不自动打印
-e：多点编辑
-f /PATH/SCRIPT_FILE：从指定文件中读取编辑脚本
-r：支持使用扩展正则表达式
-i：直接编辑文件

script 地址定界

不给地址：对全文进行处理
单地址：
#：指定的行； $：最后一行

/pattern/：被此处模式所能够匹配到的每一行

编辑命令
a\ 
在当前行后面加入一行文本。
c\ 
用新的文本改变本行的文本。
d 
从模板块（Pattern space）位置删除行。
D 
删除模板块的第一行。
i\ 
在当前行上面插入文本。
h 
拷贝模板块的内容到内存中的缓冲区。
H 
追加模板块的内容到内存中的缓冲区
g 
获得内存缓冲区的内容，并替代当前模板块中的文本。
G 
获得内存缓冲区的内容，并追加到当前模板块文本的后面。
n 
读取下一个输入行，用下一个命令处理新的行而不是用第一个命令。
N 
追加下一个输入行到模板块后面并在二者间嵌入一个新行，改变当前行号码。
p 
打印模板块的行。
P（大写） 
打印模板块的第一行。
q 
退出Sed。
r file 
从file中读行。
t label 
if分支，从最后一行开始，条件一旦满足或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
T label 
错误分支，从最后一行开始，一旦发生错误或者T，t命令，将导致分支到带有标号的命令处，或者到脚本的末尾。
w file 
写并追加模板块到file末尾。
W file 
写并追加模板块的第一行到file末尾。
! 
表示后面的命令对所有没有被选定的行发生作用。
s/re/string 
用string替换正则表达式re。
= 
打印当前行号码。
# 
把注释扩展到下一个换行符以前。

以下的是替换标记
g表示行内全面替换。
p表示打印行。
w表示把行写入一个文件。
x表示互换模板块中的文本和缓冲区中的文本。
y表示把一个字符翻译为另外的字符（但是不用于正则表达式）


元字符集 /pattern/中
[A-Za-z0-9]
匹配对应范围内容
^ 
锚定行的开始 如：/^sed/匹配所有以sed开头的行。
$ 
锚定行的结束 如：/sed$/匹配所有以sed结尾的行。
. 
匹配一个非换行符的字符 如：/s.d/匹配s后接一个任意字符，然后是d。
* 
匹配零或多个字符 如：**love**。
x\{m\} 
重复字符x，m次，如：/0\{5\}/匹配包含5个o的行。
x\{m,\} 
重复字符x,至少m次，如：/o\{5,\}/匹配至少有5个o的行。
x\{m,n\} 
重复字符x，至少m次，不多于n次，如：/o\{5,10\}/匹配5--10个o的行。

例子：
sed -n 2p test 打印第 2 行内容

sed -n 2,5p test 打印第 2--5 行内容

sed -i 's/a/v/g' test 将文件中的 a 全部替换为 v
mac 上执行上述命令会报错 sed: 1: "test": undefined label 'est.txt'
解决方案：增加一个备份的追加名【sed -i '.bak' 's/a/v/g' test】
原因：mac强制要求备份，否则报错
当然可以不使用其他备份名字，只是用''，就可以只保留一份
sed -i '' 's/a/v/g' test
如果使用sed -i '.追加后缀名' 's/a/v/g' test则会将原文件内容拷贝到test.追加后缀名，然后新改动会在test中执行

sed -e '1,5d' -e 's/test/check/' example (-e)选项允许在同一行里执行多条命令

echo this is digit 7 in a number ｜ sed 'g / digit \([0-9]\)/\1 /'' 这条命令将digit7替换成7 \(pattern)\用于匹配子串，后续的\1代笔第一个匹配到的子串，\2表示第二个，以此类推

# awk

awk [options] 'script' file1 file2, ...

awk [options] 'PATTERN {acticon}' file1 file2, ...

格式说明：

pattern部分决定动作语句何时触发及触发事件：BEGIN、END
action 对数据进行处理，放在{}内指明：print、printf
最常用的是 print，默认以空白字符分隔
$0 代表整行，$1 代表第 1 段，$2 代表第 2 段，以此类推，$NF 代表最后一个字段，多个字段直接用逗号隔开

awk '{print $1, $2}' xxx.log

打印操作支持拼接打印，如：awk '{print "first" $1, $2}' xxx.log

选项

F: 输入分隔符，默认以空白字符分隔，通过 -F 选项来执行分隔符

例子：
awk -F '#' '{print $1,$2}' test

输入：
abc#bcd#123#456#789#hahah
1234#123456

输出：
abc bcd
1234 123456

v: 输出分隔符，默认情况下输出分隔符是空格，使用内置变量 OFS 来设定输出分隔符，需要加上 -v 选项

例子：
awk -F '#' -v OFS="-->" '{print $1,$2}' test

输出：
abc-->bcd
1234-->123456

awk 变量:

FS：输入字段分隔符，默认空白字符，一般需要加 -F

OFS：输出字段分隔符，默认是空格，一般需要加 -v

NF：分隔后的字段数量

NR：当前行的行号

pattern 模式：模式是条件，符合条件的行， awk 才会进行处理

关系运算模式：awk -F '#' 'NF==5 {print $1}' test

如果行的分段数量为5 的话，进行打印操作，其他的类似，如 NF>2，NF<4，$1==1234 等都是判断条件

# sort


# uniq


# cut

cut  [-bn] [file]
cut [-c] [file]
cut [-df] [file]

cut 命令从文件的每一行剪切字节、字符和字段并将这些字节、字符和字段写至标准输出。
如果不指定 File 参数，cut 命令将读取标准输入。必须指定 -b、-c 或 -f 标志之一。

-b ：以字节为单位进行分割。这些字节位置将忽略多字节字符边界，除非也指定了 -n 标志。
-c ：以字符为单位进行分割。
-d ：自定义分隔符，默认为制表符。
-f ：与-d一起使用，指定显示哪个区域。
-n ：取消分割多字节字符。仅和 -b 标志一起使用。如果字符的最后一个字节落在由 -b 标志的 List 参数指示的
范围之内，该字符将被写出；否则，该字符将被排除



# ps and 进程相关知识

每当开始一个进程，linux就会在目录/proc创建一个文件夹，文件夹名是pid

pid是当前进程号
ppid是parent process id是父进程号
stime 进程启动时的系统时间
tty 进程启动时终端设备
time 运行进程需要的累积cpu时间
cmd 启动程序名称或者命令

ps -aux 显示所有包含其他使用者的进程，包含CPU和MEM使用率信息

ps -ef 

参数 -e  显示运行在系统上的所有进程

参数 -f  扩展显示输出

ps -eLf 查看进线程信息

ps -T -p pid 查看对应pid的进程的所有线程信息，SID列是线程ID



# top

动态查看进程的命令

d : 改变显示的更新速度，或是在交谈式指令列( interactive command)按 s
q : 没有任何延迟的显示速度，如果使用者是有 superuser 的权限，则 top 将会以最高的优先序执行
c : 切换显示模式，共有两种模式，一是只显示执行档的名称，另一种是显示完整的路径与名称
S : 累积模式，会将己完成或消失的子进程 ( dead child process ) 的 CPU time 累积起来
s : 安全模式，将交谈式指令取消, 避免潜在的危机
i : 不显示任何闲置 (idle) 或无用 (zombie) 的进程
n : 更新的次数，完成后将会退出 top
b : 批次档模式，搭配 "n" 参数一起使用，可以用来将 top 的结果输出到档案内

在进行top命令的时候可以进行以下交互

d 调整刷新频率，单位是秒
n 调整查看的进程个数
q 退出top命令
i 不显示闲置的进程


top -c 增加列命令的启动命令或路径（command）

top -n 2 表示更新两次后终止更新显示，退出top命令

top -p 139 显示进程号为139的进程信息，CPU、内存占用率等

top -H动态查看进线程信息

top -H -p pid 动态查看某进程的线程信息


# ss
socket statisitcs的缩写，用来获取socket统计信息


-h, --help 帮助信息
-V, --version 程序版本信息
-n, --numeric 不解析服务名称
-r, --resolve        解析主机名
-a, --all 显示所有套接字（sockets）
-l, --listening 显示监听状态的套接字（sockets）
-o, --options        显示计时器信息
-e, --extended       显示详细的套接字（sockets）信息
-m, --memory         显示套接字（socket）的内存使用情况
-p, --processes 显示使用套接字（socket）的进程
-i, --info 显示 TCP内部信息
-s, --summary 显示套接字（socket）使用概况
-4, --ipv4           仅显示IPv4的套接字（sockets）
-6, --ipv6           仅显示IPv6的套接字（sockets）
-0, --packet         显示 PACKET 套接字（socket）
-t, --tcp 仅显示 TCP套接字（sockets）
-u, --udp 仅显示 UCP套接字（sockets）
-d, --dccp 仅显示 DCCP套接字（sockets）
-w, --raw 仅显示 RAW套接字（sockets）
-x, --unix 仅显示 Unix套接字（sockets）
-f, --family=FAMILY  显示 FAMILY类型的套接字（sockets），FAMILY可选，支持  unix, inet, inet6, link, netlink
-A, --query=QUERY, --socket=QUERY
      QUERY := {all|inet|tcp|udp|raw|unix|packet|netlink}[,QUERY]
-D, --diag=FILE     将原始TCP套接字（sockets）信息转储到文件
 -F, --filter=FILE   从文件中都去过滤器信息
       FILTER := [ state TCP-STATE ] [ EXPRESSION ]



# free

查看服务器内存使用情况

free -h 查看内存使用情况，带单位，显示查看结果
free -m 查看内存，不带单位

输出的字段含义
total 总计物理内存大小
used 已使用内存
free 可用内存
shared 多个进程共享的内存大小
buffers/cached 磁盘缓存的大小，可以清除

清除缓存
echo 1 > /proc/sys/vm/drop_caches --释放网页缓存
echo 2 > /proc/sys/vm/drop_caches --释放目录项和索引
echo 3 > /proc/sys/vm/drop_caches --释放网页缓存，目录项和索引




# 查看端口，实质上是进程打开的文件lsof


lsof打开的文件可以是：

1.普通文件

2.目录

3.网络文件系统的文件

4.字符或设备文件

5.(函数)共享库

6.管道，命名管道

7.符号链接

8.网络文件（例如：NFS file、网络socket，unix域名socket）

9.还有其它类型的文件，等等


命令参数：

-a 列出打开文件存在的进程

-c<进程名> 列出指定进程所打开的文件

-g  列出GID号进程详情

-d<文件号> 列出占用该文件号的进程

+d<目录>  列出目录下被打开的文件

+D<目录>  递归列出目录下被打开的文件

-n<目录>  列出使用NFS的文件

-i<条件>  列出符合条件的进程。（4、6、协议、:端口、 @ip ）

-p<进程号> 列出指定进程号所打开的文件

-u  列出UID号进程详情

-h 显示帮助信息

-v 显示版本信息

lsof -i:3306 查看使用端口3306的进程





# 创建文件链接ln

软链接，全称是软链接文件，英文叫作 symbolic link。这类文件其实非常类似于 Windows 里的快捷方式，这个软链接文件（假设叫 VA）的内容，其实是另外一个文件（假设叫 B）的路径和名称，当打开 A 文件时，实际上系统会根据其内容找到并打开 B 文件。

而硬链接，全称叫作硬链接文件，英文名称是 hard link。这类文件比较特殊，这类文件（假设叫 A）会拥有自己的 inode 节点和名称，其 inode 会指向文件内容所在的数据块。与此同时，该文件内容所在的数据块的引用计数会加 1。当此数据块的引用计数大于等于 2 时，则表示有多个文件同时指向了这一数据块。一个文件修改，多个文件都会生效。当删除其中某个文件时，对另一个文件不会有影响，仅仅是数据块的引用计数减 1。当引用计数为 0 时，则系统才会清除此数据块。

创建一个硬链接 ln 源文件名称 硬链接文件名称

创建一个软链接 ln -s 源文件名称 硬链接文件名称






















