## 如何使用
>推荐fork仓库之后修改完配置文件提交到远程仓库,
>然后通过脚本拉取增加效率
```shell script
#在os中运行下载以下脚本
wget https://raw.githubusercontent.com/wumingzhiren/assembly-line-mk2/master/script
#运行默认拉取的仓库是https://github.com/wumingzhiren/assembly-line-mk2 
#github访问困难请使用以下脚本
wget https://gitee.com/is-anonymous-used-by-anyone/assembly-line-mk2/raw/master/script_gitee
#对应仓库为https://gitee.com/is-anonymous-used-by-anyone/assembly-line-mk2
#如果fork了想要拉取自己的仓库在script后面添加自己的仓库前缀
#e.g. 自定义仓库 script https://gitee.com/xxxxx/assembly-line/raw
#e.g. 自定义仓库和分支 script https://gitee.com/xxxxx/assembly-line/raw xxxx
#e.g. github script https://raw.githubusercontent.com/shoaky009/assembly-line xxxx
script
```


### 1.使用前准备

若您的GTNH版本为2123QF及以前，则无需进行以下下步骤。若您的GTNH版本高于2123QF，请进行此步骤以更新可能存在的流体及物品更新

#### 1.1建立流体数据
>
> 1. 按"e"打开nei界面，点击左下角扳手，并依次点击工具-数据存储-nei整合中的流体容器项
>
> 2. 在".minecraft\dumps\"文件夹中找到"fluidcontainer.csv"文件，使用记事本打开这个文件，以UTF-8格式另存，并剪切至其他文件夹备用。
>
> 3. 将以上文件内容覆盖"工作文件夹\assembly-line-mk2\conf\"文件夹中。

#### 1.2更新电路数据

>  打开"工作文件夹\assembly-line-mk2\recipe\"中的"chipDatabase.lua"文件，核对电路板的名称及物品id。若您的单机端或服务端未使用kiwi对应版本的汉化，请自行修改对应电路板的名称。


### 2.初始化&配置

#### 2.1运行initializer.lua并按照顺序放置转运器,程序会自动写入地址到config.lua
> 1. 原材料箱子相邻的转运器
> 
> 2. 16个位于输入总线下方的转运器
> 
> 3. 4个流体转运器
> 
> 4. 4个me流体接口
> 
> 设置完成后系统会自动重启
> 再次说明顺序很重要中途有任何错误都会导致程序无法运行 如果放错请ctrl+c退出重新来过

#### 2.2设置转运器与原材料箱的面
>具体sides的定义查看官网API https://ocdoc.cil.li/api:sides
```lua
config.chestInput.chestSourceSide = sides.top
```
#### 2.3设置转运器与材料输出到输入总线的箱子
```lua
config.chestInput.chestOutputSide = sides.west
```
#### 2.4设置转运器与熔物品的输出面
```lua
config.chestInput.moltenOutputSide = sides.north
```
#### 2.5设置流体输入输出面
```lua
config.fluidSourceSide = sides.down
config.fluidOutputSide = sides.up
```
#### 2.6设置用于输入总线的转运器的输入与输出方向
```lua
config.chestOutput.chestSourceSide = sides.down
config.chestOutput.chestOutputSide = sides.up
```

#### 2.7如果要用其他方法处理熔融流体，将下句中"true"改为"false
```lua
config.moltenCtrl = true
```

#### 2.8 其他OC组件
>1. 紧贴装配线主方块放置一个红石I/O端口并接入OC网络，配套安装一个"设备活跃探测覆盖板"以探测工作进程，并根据方向读取方向（若不安装覆盖板，程序仍可运行，但会有一定显示错误）
```lua
config.redStoneSide = sides.east
```
>2. 紧贴数据库接口放置一个适配器，在其中放置一个"物品栏控制器升级"，并根据方向配置数据库接口读取方向
```lua
config.flashSide = sides.north
```
>3. 在其他适配器中放置一个"超级数据库升级"

### 3.设置其他外围组件

#### 3.1 AE组件
>紧贴任意一个适配器放置ME控制器，并连接2.1中放置的四个ME流体接口。
>该AE子网中还需放置一个流体磁盘或其他流体存储设备,以暂存提取出的流体
>该AE子网通过一个流体存储总线（只读模式）读取主AE网络ME流体接口，以使用主网络中流体
#### 3.2 提取组件
>提取出流体应输入子网中任意一个ME流体接口
 
### 4.设置流体到db中

>所有配方中使用的流体均需设置，方法见后文5.1

### 5.配置完毕
>cd assembly-line-mk2
>
>main (启动完毕后每2秒会到箱子里匹配物品)
>
>Ctrl + C (关闭程序)

### 6.util说明

#### 6.1 db.lua
```shell
    #存储源材料箱第一个位置的物品到database
    util/db
    #存储源材料箱所有物品到database新增数据(注意不能超过81个 如果要支持81个要设置多个db)
    util/db all
    #打印所有database中的数据
    util/db readAll
    #清除所有database中的数据
    util/db clearAll
```
#### 6.2 readitem.lua
```shell
    #打印源材料箱的所有物品名称+damage
    util/readitem
    #打印源材料箱第一个位置的物品信息
    util/readitem allInfo
    #替换源材料箱为储罐 然后放入流体读取流体信息
    util/readitem readFluid
```

## 注意点

> 1. 请使用服务器及至少两个超级组件总线来运行此程序,组件达35个，需要组件总线来扩展

> 2. 请使用至少两根T3.5级存储器，该程序对内存需求较大

> 3. 如果遇到流体不够的情况下程序会一直循环 直到ae中有足够的流体供给到me流体接口中

> 4. 安装完毕正常运行后不要拆除任何oc的组件 否则地址会更变 你需要手动修改或者拆除所有oc转运器和me流体接口config.lua需要重新下载 然后运行initializer进行安装

> 5. 熔融物品写配方时，144mb整数倍的请使用锭形式，小于144mb的请使用多个螺栓形式


## 参考视频
https://www.bilibili.com/video/BV1iz4y1274d/

转换器相对于使用robot配置复杂,造价昂贵(相对来说 其实对iv来说都还行)
优势在于传输快,个人感觉机器人走得太慢了所以没有用
欢迎提出建议改进
