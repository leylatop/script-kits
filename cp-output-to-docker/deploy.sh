#!/bin/bash

# 定义变量
REMOTE_HOST="archvm"
REMOTE_PATH="/home/mb"
DOCKER_CONTAINER="imock-jc_js-brand_1"
DOCKER_APP_PATH="/app/imock/bin"
LOCAL_OUTPUT_DIR="output-gitignore"

echo "开始部署流程..."

CURRENT_TIME=$(date +%Y%m%d%H%M%S)
# 1. 执行打包
echo "1. 执行打包..."
# 删除 output-gitignore 和 nextjs-dist-gitignore 文件夹
# echo "1.1 删除 output-gitignore 和 nextjs-dist-gitignore 文件夹"
# rm -rf output-gitignore nextjs-dist-gitignore

# echo "1.2 执行打包..."
# npm run script-pack
# if [ $? -ne 0 ]; then
#     echo "打包失败！"
#     exit 1
# fi

# 2. 复制文件到远程服务器
echo "2. 复制文件到远程服务器..."
# 压缩
tar -zcf ${LOCAL_OUTPUT_DIR}-${CURRENT_TIME}.tar.gz ${LOCAL_OUTPUT_DIR}

# 打印压缩文件大小
echo "压缩文件大小：$(du -sh ${LOCAL_OUTPUT_DIR}-${CURRENT_TIME}.tar.gz | awk '{print $1}')"

# 传输
scp -r ${LOCAL_OUTPUT_DIR}-${CURRENT_TIME}.tar.gz ${REMOTE_HOST}:${REMOTE_PATH}/
if [ $? -ne 0 ]; then
    echo "文件传输到远程服务器失败！"
    exit 1
fi

# 3. 在远程服务器上执行docker操作
echo "3. 在远程服务器上执行docker操作..."
# 将压缩包复制到容器中
ssh -T ${REMOTE_HOST} << EOF
    echo "3.1 将压缩包复制到容器中的${DOCKER_APP_PATH}目录下"
    sudo docker cp ${REMOTE_PATH}/${LOCAL_OUTPUT_DIR}-${CURRENT_TIME}.tar.gz ${DOCKER_CONTAINER}:${DOCKER_APP_PATH}/

    echo "3.2 将旧的文件夹复制一份，重命名为mb-brand-${CURRENT_TIME} 备份"
    sudo docker exec ${DOCKER_CONTAINER} cp -r ${DOCKER_APP_PATH}/mb-brand ${DOCKER_APP_PATH}/mb-brand-${CURRENT_TIME}

    echo "3.2 解压容器中压缩包到${DOCKER_APP_PATH}/mb-brand下"
    sudo docker exec ${DOCKER_CONTAINER} tar -xzf ${DOCKER_APP_PATH}/${LOCAL_OUTPUT_DIR}-${CURRENT_TIME}.tar.gz --strip-components=1 -C ${DOCKER_APP_PATH}/mb-brand

    # 重启容器
    echo "4. 重启容器..."
    sudo docker restart ${DOCKER_CONTAINER}
EOF


echo "部署完成！"
