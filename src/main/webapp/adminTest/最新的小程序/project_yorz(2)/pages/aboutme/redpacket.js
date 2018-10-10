const app = getApp()
// pages/aboutme/redpacket.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径
    resourceServer: app.globalData.resourceServer, // 服务器资源路径

    globalData: app.globalData,

    pageSize: 10,
    currentAttribute: {
      page: 1, // 当前页面
      overPage: false, // 是否已经载入完
    },
    dataList:[
      /*
      {
        id: '5b52e3ae0be7101658c237bb', // 红包id
        shopPhoto: '5b39e96ed6c4595cb22dbd0f.png',
        name: '台塑王品', // 红包名
        amount:'CNY50',
        explain: '此红包可转赠微信好友使用', // 地址
        label: '火锅' // 标签
      },
      {
        id: '5b52e3ae0be7101658c237bb', // 红包id
        shopPhoto: '5b39e96ed6c4595cb22dbd0f.png',
        name: '台塑王品', // 红包名
        amount: 'CNY50',
        explain: '此红包可转赠微信好友使用', // 说明
        label: '火锅' // 标签
      },
      */
    ]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {

    app.init(() => {
      this.setData({
        globalData: app.globalData, // 全局数据
      })
      if (app.globalData.sysUserLogined || app.globalData.userInfo.server_uid != '') {
        this._init()
      } else {
        app.showLoginReminding()
      }
    })
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    wx.setNavigationBarTitle({ title: '红包转赠' }) // 动态设置当前页面的标题
  
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    wx.showShareMenu({
      withShareTicket: true
    }) // 显示当前页面的转发按钮

  },

  /**
   * 生命周期函数--监听页面隐藏
   */
  onHide: function () {
  
  },

  /**
   * 生命周期函数--监听页面卸载
   */
  onUnload: function () {
  
  },

  /**
   * 页面相关事件处理函数--监听用户下拉动作
   */
  onPullDownRefresh: function () {
  
  },

  /**
   * 页面上拉触底事件的处理函数
   */
  onReachBottom: function () {
    if (!this.data.currentAttribute.overPage) {
      this.data.currentAttribute.page += 1

      this._getData()
    } else {
      // 已加载完所有数据
    }
  },

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function (options) {
    console.log("用户点击右上角分享", options)
    const shareInfo = {
      title: '',
      path: '',
      imageUrl: ''
    }
    if (options.from == 'button') {
      console.log("来自页面内转发按钮", options.target)
      shareInfo.title = '赠与你一个《' + options.target.dataset.title + '》的红包'
      shareInfo.path = '/pages/index/index?uid=' + app.globalData.userInfo.server_uid + '&packetId=' + options.target.dataset.id
      shareInfo.imageUrl = options.target.dataset.photo
    } else if (options.from == 'menu') {
      shareInfo.title = '这里的许多红包等待你打开'
      shareInfo.path = '/pages/index/index?uid=' + app.globalData.userInfo.server_uid
    }

    return shareInfo
  },

  _init: function () {
    this.setData({
      'currentAttribute.page': 1,
      'currentAttribute.overPage': false,
      'dataList': []
    })

    this._getData()
  },
  _getData: function () {
    const post_data = {
      page: this.data.currentAttribute.page,
      pageSize: this.data.pageSize,
      userId: app.globalData.userInfo.server_uid
    }
    const success_server = (resData) => {
      console.log("获取<我的红包>成功:", resData)
      if (resData.data) {
        let temp_datas = this.data.dataList

        const old_length = temp_datas.length
        if (resData.data.length == 0) {
          this.setData({
            'currentAttribute.overPage': true
          })
        } else {
          resData.data.forEach((item, index, array) => {
            temp_datas.push({
              id: item.redId, // 红包id
              index: old_length + index,
              shopPhoto: item.pic, // 小图片地址
              name: item.name, // 红包名
              title: item.title, // 红包属性
              label: item.label, // 标签
              explain: '此红包可转赠微信好友使用', 
            })
          })
          this.setData({
            'dataList': temp_datas
          })
        }
      }
    }
    const fail_server = (errorMessage) => {
      console.log("获取<我的红包>错误", errorMessage)
      app.showLoadDataError({
        title: '数据获取失败',
        content: '我的红包数据载入失败:' + errorMessage,
        retry: () => {
          this._getData()
        }
      })
    }
    app.Tools.API_server.getRedPacket(post_data, success_server, fail_server)
  }
})