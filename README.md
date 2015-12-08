#xlbase
  A Postgres-XL + Pacemaker Docker Image

# Deployment
  git clone https://github.com/ingted/xlbase.git
  cd xlbase
  git checkout --track -b xlbase remotes/origin/backToOrigin
  source alias/util-disable-status 1 1 1
  ./make.sh

  docker run -it -v /opt/util:/opt --name util robotica/util:latest /sbin/my_init -- bash -l /util/get-tool

  cd alias
  echo "export PATH=\$PATH:$(pwd)" >> ~/.bashrc

