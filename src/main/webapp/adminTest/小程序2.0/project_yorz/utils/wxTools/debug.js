function Person (name, age) {
  this.name = name
  this.age = age
  this.show = () => {
    console.log("姓名:"+ this.name, "年龄:"+this.age)
  }
}
Person.prototype = {
  getName: function () {
    return this.name
  },
  getAge: function () {
    return this.age
  }
}

function App_Debug(isDebug) {
  var debug = isDebug || false

  /**
   * 生命周期函数--监听小程序初始化  当小程序初始化完成时，会触发 onLaunch（全局只触发一次）
   */
  this.App_onLaunch = (options) => {
    if (debug == false) {
      return
    }
    this._showOption(options);
  }
  /**
   * 生命周期函数--监听小程序显示  当小程序启动，或从后台进入前台显示，会触发 onShow
   */
  this.App_onShow = (options) => {
    if (debug == false) {
      return
    }
    this._showOption(options);
  }
  /**
   * 生命周期函数--监听小程序隐藏 当小程序从前台进入后台，会触发 onHide
   */
  this.App_onHide = () => {

  }
  /**
   * 错误监听函数	当小程序发生脚本错误，或者 api 调用失败时，会触发 onError 并带上错误信息
   */
  this.App_onError = () => {

  }
  /**
   * 页面不存在监听函数	当小程序出现要打开的页面不存在的情况，会带上页面信息回调该函数，详见下文
   */
  this.App_onPageNotFound = (res) => {
    if(this.debug === false) {
      return
    }
    console.log("onPageNotFound:", res)
    console.log("path[String]不存在页面的路径:", res.path)
    console.log("query[Object]不存在页面的路径:", res.query)
    console.log("isEntryPage[Boolean]是否本次启动的首个页面:", res.isEntryPage)
  }
  this._showOption = (options) => {
    console.log("App_onLaunch:", options)
    console.log("path[String]打开小程序的路径", options.path)
    console.log("query[Object]打开小程序的query", options.query)
    console.log("scene[Number]打开小程序的场景值", options.scene)
    console.log("shareTicket[String]shareTicket", options.shareTicket)
    if (options.hasOwnProperty("referrerInfo")) {
      console.log("referrerInfo[Object]当场景为由从另一个小程序或公众号或App打开时，返回此字段", options.referrerInfo)
      if (options.referrerInfo.hasOwnProperty("appId")) {
        console.log("referrerInfo.appId[String]打开小程序的路径", options.referrerInfo.appId)
        console.log("referrerInfo.extraData[Object]来源小程序传过来的数据，scene=1037或1038时支持", referrerInfo.extraData)
      }
    }
  }
}

const Page_Debug = {
  onTabItemTap: function(item){
    console.log("当前是tab页时，点击tab时触发", item)
  }
}

/**
 * 日志记录
 * Debug.Logger.info()
 */
function App_Logger(isDebug) {
  const debug = isDebug || false
  /**
   * 调试记录处理方式
   */
  this.info = (...res) => {
    if (debug) {
      //console.group("debugRecord")
      console.log("    调试输出:", res)
      // res.forEach((element, index, array) => {
      //   console.log("    调试输出forEach:", element, index, array)
      // })
      //console.groupEnd()
    } else {
      // 调用小程序日志记录
    }
  }
}


module.exports = {
  App: new App_Debug(false), // 是否控制台输出
  Page: Page_Debug,
  Person: new Person("开开", 18),
  Logger: new App_Logger(false) // 显示控制台输出或日志输出
}
