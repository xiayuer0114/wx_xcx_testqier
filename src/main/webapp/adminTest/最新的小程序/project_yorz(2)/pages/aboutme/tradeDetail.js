const utils = require("../../utils/util.js")
const app = getApp()

// pages/aboutme/tradeDetail.js 交易明细
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
    dataList:[]
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
    wx.setNavigationBarTitle({ title: '我的钱包' }) // 动态设置当前页面的标题

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
  
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
  onShareAppMessage: function () {
  
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
      console.log("获取<交易明细>成功:", resData)
      if (resData.data) {
        let temp_datas = this.data.dataList
        let old_length = temp_datas.length
        if (resData.data.length == 0) {
          this.setData({
            'currentAttribute.overPage': true
          })
        } else {
          resData.data.forEach((item, index, array) => {
            let amount = parseFloat(item.money).toFixed(2)
            if (amount > 0){
              amount = '+' + amount
            }
            temp_datas.push({
              id: old_length + index,
              date: item.date,
              name: item.name,
              amount: amount
            })
          })
          this.setData({
            'dataList': temp_datas
          })
        }
      }
    }
    const fail_server = (errorMessage) => {
      console.log("获取<交易明细>错误", errorMessage)

      app.showLoadDataError({
        title: '数据获取失败',
        content: '我的交易明细载入失败:' + errorMessage,
        retry: () => {
          this._getData()
        }
      })
    }
    app.Tools.API_server.getTransactionRecord(post_data, success_server, fail_server)
  }
})