#!/bin/bash

exist=$(docker images|grep divan/golang |grep gotrace1.8|wc -l)
if [ $exist -eq 0 ]; then
    echo "build image divan/golang:gotrace1.8"
    {
        workspace=$(cd $(dirname $0) && pwd -P)
        cd $workspace
        if [ ! -f "Dockerfile" ]; then 
            curl -o Dockerfile "https://gist.githubusercontent.com/NewbMiao/f4340b483e3dfc057911cba8e7a37562/raw/9e97aa713ac7be673a5f938c1e57bd5fcfad8af3/Dockerfile_gotrace1.8" 
        fi
        docker build . -t  divan/golang:gotrace1.8
    }
fi
if [ $# -eq 0 ]; then
    echo "Require go file pathname";
    echo "Usage: sh gotrace.sh someFileWithTraceEnableGoroutines.go"
    exit;
fi
docker run -p 2000:2000  -v $PWD:/go divan/golang:gotrace1.8 gotrace $1