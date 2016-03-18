#xlbase
# A Postgres-XL + Pacemaker Docker Image

# Deployment

#專案名稱 (Project Name)：
#xlbase
#模組名稱 (Module Name)：
#xlbase
#文件編號 (ID)：
#1
#版本 (Version)：
#1.0
#發佈日期 (Release Date)：
#2016/03/18


#硬體規格與系統需求 (依提供之十節點主機)
#	gtm主機：
#網路介面 * 2 (at least)
#CPU bound配置
#	gtmsby主機：
#網路介面 * 2 (at least)
#CPU bound配置
#	datanode / coordinator / gtmprx主機：
#網路介面 * 7 (at least)
#IO bound配置
#
#應用系統安裝
#OS：Ubuntu 14.04 / 16.04
#Docker：1.9.1以上
#zfs：待議

#controller (用以部署的機器) 準備並取得源碼以及編譯
sudo apt-get -y install expect  git
sudo wget -qO- https://get.docker.com/ | sh

git clone https://github.com/ingted/xlbase.git
cd xlbase
git checkout --track -b xlbase remotes/origin/backToOrigin
source alias/util-disable-status 1 1 1
./make.sh
source ~/.bashrc



#進行設定
#alias/dexxhosts
#
#C依賴E為h的設定值的B字段
#
#同一個dexxhosts可設定多組cluster，單一node可以同屬不同的cluster (D字段)
#但在建立cluster時僅最後建立的cluster會擁有此node
#F對應的container路徑設定位於alias/dexxconfigrepo，形如：
#其中#對應alias/dexxhostroles的第四字段
#其中%對應alias/dexxhostroles的第三字段
#
#
#alias/dexxconfigrepo
#第一字段僅為標示用
#
#第二字段為role，有
#gtm
#gtmsby
#gtmptx
#dn
#coor
#
#第三字段為master or slave
#
#第四字段為node id，假設一個cluster有三個coordinator node則此值最大為3，一個node可以對應到一個node master兩個node slave
#
#第五字段為 DATADIR
#
#第六字段為設定檔範本
#範本檔案位於alias，範本檔內容無作用，僅用其名去找後面的.param檔以及.example檔
#
#第七字段為設定檔檔名
#
#第八字段為xl版本號
#
#第九字段為cluster name
# 
#
#
#alias/dexxhostinfo
#
#
#
#alias/dexxhostroles
#
#第一字段為 hostname，對應 alias/dexxhosts 的 B
#
#第二字段為 nodeid，需小於 alias/dexxhostinfo 第三字段，若為docker host 請填0
#
#第三字段為 role，對應 alias/dexxconfigrepo 的 第二字段，若為docker host 請填docker
#
#第四字段對應第三字段，若為docker host 請填x
#
#第五字段為 master / slave 對應 alias/dexxconfigrepo 第三字段，若為docker host 請填x
#
#第六字段為 cluster name

#叢集安裝
cd mgmt
./mgmt-init-set-xl-config alpha #$cluster_name
#(修改 ./login.sh 當中的dns地址)
./login.part1.sh #(一台controller or noAnsible mode) ./login.part1.sh ansible test 1111 1 1
./login.sh #(noAnsible mode) ./login.sh ansible test 1111 1 "" 1
#(修改 ./mgmt-init-set-dhost 當中的 git 資訊)
./mgmt-init-set-dhost / alpha 0 0 #./mgmt-init-set-dhost /xl ansible 0 0
#./mgmt-init-set-dhost $tool_location $cluster_name $ifContainerUpdToolOnly $ifHostMake
./clogin.sh
	
# deprecated
  git clone https://github.com/ingted/xlbase.git
  cd xlbase
  git checkout --track -b xlbase remotes/origin/backToOrigin
  source alias/util-disable-status 1 1 1
  ./make.sh
  source ~/.bashrc
  docker run -it -v /opt/util:/opt --name util robotica/util:latest /sbin/my_init -- bash -l /util/get-tool

  cd alias
  echo "export PATH=\$PATH:$(pwd)" >> ~/.bashrc

