#!/bin/bash

GOTRACECMD="docker run --rm -it  -p 2000:2000  -v \$PWD:/go divan/golang:gotrace1.8"

if [ $# -eq 0 ]; then
    echo -e "Usage: Require go file pathname(some code enable trace goroutines)\n\
    Shell : sh gotrace.sh goroutines.go\n\
    Docker: $GOTRACECMD goroutines.go\n\
            (you need build image locally first: docker build . -t divan/golang:gotrace1.8)"
    exit;
fi

if [ "$GOOS" == "linux" ]; then # build on docker container
    gotrace $1
else # build on local machine
    exist=$(docker images|grep divan/golang |grep gotrace1.8|wc -l)
    if [ $exist -eq 0 ]; then
        echo "build image divan/golang:gotrace1.8"
        {
            workspace=$(cd $(dirname $0) && pwd -P)
            cd $workspace
            if [ ! -f "Dockerfile" ]; then 
                curl -o Dockerfile "https://gist.githubusercontent.com/NewbMiao/f4340b483e3dfc057911cba8e7a37562/raw/7b8ab53511af85f614d3354b2da40ec9c21c5e76/Dockerfile"
            fi
            docker build . -t  divan/golang:gotrace1.8
        }
    fi
    eval $GOTRACECMD $1
fi

