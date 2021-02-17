const FileUtil= require('./lib/fileUtil');
const ImageUtil= require('./lib/ImageUtil');
const SlackUtil= require('./lib/SlackUtil');

let s = new SlackUtil();
let fu = new FileUtil();

let base = process.argv[2];
let baseDiff = process.argv[3];

var dirs = fu.getLS(base).split('\n');

var diffdir = baseDiff;
fu.createPath(baseDiff);
fu.createPath(diffdir);

var ret = fu.getAllFiles(base+'/'+dirs[0]);

( async () => {
    let i = new ImageUtil();
    var ary = [];
    await s.postText('check START');
    await s.postText(ret.length+' files '+dirs[0] );

    let diff = ( async (filename,baseDir,compareDir) => {
        var diffB = filename.replace(baseDir,compareDir);
        ret = await i.imageDiff(
            filename,
            diffB,
            diffdir,
            (async (file,misMatchPercentage) =>{
                console.log(misMatchPercentage+','+file);
            })
        );
    })
    ret.forEach(async (filename) => await diff(filename,dirs[0],dirs[1]));
    await s.postText('check END');

})();

        
    

