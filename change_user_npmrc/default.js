const fs = require('fs');
const path = require('path');
const os = require('os');

const userNpmrcPath = path.join(os.homedir(), '.npmrc');

fs.writeFileSync(userNpmrcPath, '', 'utf8');
console.log(`* 修改${userNpmrcPath}文件内容为空`);