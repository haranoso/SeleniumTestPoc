const Utils = require('./lib/TestUtil');
const SlackUtil= require('./lib/SlackUtil');

let s = new SlackUtil();

require('chromedriver');
require('geckodriver');

var assert = require('assert');

const webdriver = require('selenium-webdriver');
const { Builder, By, Key,until } = webdriver;
// const {Builder, By, Key, until , Actions } = require('selenium-webdriver');


const config = {};
config.url = 'https://www.google.co.jp/';
config.outdir = 'ss';




module.exports = async function (browser,path){
    s.postText('check Start');
    const capabilities = webdriver.Capabilities.chrome();
    capabilities.set('chromeOptions', {
        args: [
            '--headless',
            '--no-sandbox',
            '--disable-gpu',
            `--window-size=1980,1200`
            // other chrome options
        ]
    });
    driver = await new Builder().forBrowser(browser).withCapabilities(capabilities).build();

    let u = new Utils(driver);
    (function ( browser ){
        test('test001');
    }(browser));

    // テストその1
    async function test(name){
        const scrDir = path+'/'+browser+'/'+name;

        try {
            await driver.get(config.url);

            await u.waitForLoadBy(By.name('q'));
        
            u.takeScr(scrDir,name+'-001.jpg');
        
            await driver.findElement(By.name("q")).sendKeys('selenium javascript',Key.ENTER);
            await u.takeScr(scrDir,name+'-002.jpg');
        
            await u.waitForLoadBy(By.id('pnnext'));
            await u.scrollBy(By.id("pnnext"));
            await u.takeScr(scrDir,name+'-003.jpg');

            await u.clickBy(By.id("pnnext"));
            await u.takeScr(scrDir,name+'-004.jpg');

            await u.waitForLoadBy(By.id('pnnext'));
            await u.takeScr(scrDir,name+'-005.jpg');

            var elmlast = null;
            var elements = driver.findElements(By.partialLinkText("Selenium"));
            for(let elm of (await elements)) {
              elmlast = elm;
            }
            if(elmlast!= null){
                await elmlast.click();
                await u.takeScr(scrDir,name+'-006.jpg');
            }
            console.log(name+ ' done');
        }
        catch(err){
            u.log(err);
            s.postText(err.stack);
            console.log(name+ ' fault');
        }
        finally {
            await driver.quit();
        }
        s.postText('check finish');
    }
}