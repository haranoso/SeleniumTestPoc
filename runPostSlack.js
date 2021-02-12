const SlackUtil= require('./lib/SlackUtil');
const LineReader= require('./lib/LineReader');
// const { sleep } = require('sleep');
var sleep = require('sleep');

let s = new SlackUtil();

const file = process.argv[2];


const postBorderMin = 0.1;
const postBorderMax = 13.0;

( async () => {
    await s.postText('post START');

    const lr = new LineReader(file);
    
    //reader.next()がfalseを返すまでループ
    while(lr.next()){
        const columns = lr.line.split(',');
        const misMatchPercentage = parseFloat(columns[0]);
        const filePath = columns[1];
        var message = '['+lr.count+']  '+misMatchPercentage+'%  '+filePath;
        await s.postText(message);
        // console.log('cnsl>> ' + message);
        if( misMatchPercentage >= postBorderMin && misMatchPercentage < postBorderMax){
          await s.postImage(filePath,filePath);
          sleep.msleep(2000);
        }
        sleep.msleep(1000);
        // console.log(lr.line, lr.count);
    }
    await s.postText('post END');


})();

        
    

