# change_user_npmrc

一个用于更改 npmrc 配置的命令行工具

## 安装
```shell
npm install -g change_user_npmrc
```
如遇安装 404 问题，需修改 `.npmrc` 文件的镜像源

## 命令
- ly-cn
- ly-cnd


## 使用方法
1. 在用户目录下创建 `.npmrc-ly-` 开头的文件，文件名即为配置类型，比如 `.npmrc-ly-company` | `.npmrc-ly-personal`
2. 执行全局命令 `ly-cn <configType>`，查看已配置的类型
3. 执行全局命令 `ly-cnd`，可将 `.npmr`置空

## 举例
1. 在用户目录下创建 .npmrc-ly-company 文件 和 .npmrc-ly-personal 文件，并写入配置
```shell
cd ~
touch .npmrc-ly-company
touch .npmrc-ly-personal
echo "registry=https://registry.npmmirror.com" > .npmrc-ly-company
echo "registry=https://registry.npmmirror.com" > .npmrc-ly-personal
```

2. 执行命令 `ly-cn company`，将.npmrc 文件内容修改为公司npm源配置
```shell
ly-cn company
```

3. 执行命令 `ly-cnd`，将.npmrc 文件内容修改为空
```shell
ly-cnd
```

