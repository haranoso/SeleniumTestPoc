const FileUtil= require('./lib/FileUtil');

const sample=require('./sample');

let path = process.argv[3];
let browser = process.argv[2];

let width = 375;
let height = 967;

var fu = new FileUtil();
fu.createPath(path);

try{
    (async() =>{
        // 独自に用意したテストクラスをここで呼び出す。
        // webdriverは流用せず各テストクラスで作成、破棄するイメージ。
        // await test(browser,path,width,height);
        await sample(browser,path);
    })();
}
catch(err){
    console.log('test fault!');
}

