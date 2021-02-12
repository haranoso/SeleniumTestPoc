const SlackUtil= require('./lib/SlackUtil');

let s = new SlackUtil();

const locfile = process.argv[2];

console.log(locfile);
( async () => {
  await s.postText(locfile);
  await s.postImage(locfile,locfile);
})();