#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');
// 获取homedir下以.npmrc-ly- 开头的所有文件
const npmrcFiles = fs.readdirSync(os.homedir()).filter(file => file.startsWith('.npmrc-ly-'));
if(npmrcFiles.length === 0) {
  console.error(`* 当前用户下没有以.npmrc-ly- 开头的npmrc文件，请先在${os.homedir()}目录下创建 以.npmrc-ly- 开头的文件`);
  process.exit(1);
}
const npmrcConfigPathMap = {}
npmrcFiles.forEach(file => {
  const configType = file.slice(10);
  const configPath = path.join(os.homedir(), file);
  npmrcConfigPathMap[configType] = configPath;
});
console.log(`* 当前已配置npmrc文件: ${npmrcFiles.join(', ')}`);

function changeUserNpmrc(configType) {
  const contentPath = npmrcConfigPathMap[configType];
  if(!fs.existsSync(contentPath)) {
    console.error(`* ${contentPath} 文件不存在, 请先创建 ${contentPath} 文件`);
    process.exit(1);
  }
  const content = fs.readFileSync(contentPath, 'utf8');
  if (!content) {
    console.error(`* ${contentPath} 文件内容为空, 请先创建 ${contentPath} 文件`);
    process.exit(1);
  }
  const userNpmrcPath = path.join(os.homedir(), '.npmrc');
  const beforeContent = fs.readFileSync(userNpmrcPath, 'utf8');
  console.log(`* 修改前.npmrc 文件内容: ${beforeContent}`);
  try {
    // 手动添加换行符
    fs.writeFileSync(userNpmrcPath, content+'\n', 'utf8');
    console.log(`* 修改后.npmrc 文件内容: ${content}`);
    console.log(`* 修改成功`);
  } catch (err) {
    console.error(`* 修改失败: ${err.message}`);
    process.exit(1);
  }
}

// 命令行参数处理
const args = process.argv.slice(2); // 从第二个参数开始
const command = args[0];
if(command !== 'change-npmrc') {
  console.error(`* 请输入 npm run change-npmrc <configType> 来更改 npmrc 配置`);
  console.error(`* 可选配置参数: ${Object.keys(npmrcConfigPathMap).join(', ')}`);
  process.exit(1);
}
const configType = args[1];
if(!configType) {
  console.error(`* 请输入配置类型, 可选配置参数: ${Object.keys(npmrcConfigPathMap).join(', ')}`);
  process.exit(1);
}

if(!npmrcConfigPathMap[configType]) {
  console.error(`* ${configType} 不是一个有效的配置类型`);
  console.error(`* 可选配置参数: ${Object.keys(npmrcConfigPathMap).join(', ')}`);
  process.exit(1);
}

changeUserNpmrc(configType);