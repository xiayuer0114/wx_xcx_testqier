
/**
 * 微信界面相关操作
 */
const Interface = {
  /**
   * 设置导航栏文字
   */
  setNavigationBar: (title, fontColor = '#ffffff', backgroundColor = '#ffffff') => {
    wx.setNavigationBarTitle({ title: title }) // 动态设置当前页面的标题
    wx.setNavigationBarColor({
      frontColor: fontColor,
      backgroundColor: backgroundColor,
      animation: {
        duration: 400,
        timingFunc: 'easeIn'
      }
    })
  },
  /**
   * 设置小程序置顶是显示的文字
   */
  setTopText: (title) =>{
    wx.setTopBarText({
      text: title
    })
  },
  /**
   * 页面滚动到
   */
  pageScrollTo: (scrollNum) => {
    wx.pageScrollTo({
      scrollTop: scrollNum || 0,
      duration: 300 // 滚动动画的时长,默认300ms
    })
  }

}

module.exports = Interface