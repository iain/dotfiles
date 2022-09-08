function run-elasticsearch
  docker start elasticsearch || docker run --name elasticsearch --detach --publish 9200:9200 -e "discovery.type=single-node" elasticsearch:7.10.1
end
