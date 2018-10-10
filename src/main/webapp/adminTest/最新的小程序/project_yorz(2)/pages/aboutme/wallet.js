// pages/aboutme/wallet.js
const app = getApp()

Page({

  /**
   * 页面的初始数据
   */
  data: {
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径
    resourceServer: app.globalData.resourceServer, // 服务器资源路径

    globalData: app.globalData,
    NotFoundData: '',
    canUse_OpenData: wx.canIUse('open-data'),

    pageSize: 5,
    currentAttribute: {
      page: 1, // 当前页面
      overPage: false, // 是否已经载入完
      balance: 0,
    },
    dataList: [
      /*
      {
        id: '5b52e3ae0be7101658c237bb', // 文章id
        shopPhoto: '5b39e96ed6c4595cb22dbd0f.png',
        name: '战虎老火锅尊享优惠', // 红包名
        title: '战虎老火锅 20.0元', // 红包属性
        amount: '20.0元',
        address: '渝中区金石岗2号附9号', // 地址
        type: 'mylive',
        date: '09-27', // 时间
        label: '火锅', // 标签
        status: true,
        rule: '', // 使用规则
      },
      {
        id: '5b52e3ae0be7101658c237bc', // 文章id
        shopPhoto: '5b2774b07d170b65bfd57ac1.png',
        name: '十三椒老坛酸菜鱼尊享优惠', // 红包名
        title: '十三椒老坛酸菜鱼 15.0元', // 红包属性
        amount: '15.0元',
        address: '南岸区弹子石CBD泽科星泽汇购物中心3楼', // 地址
        type: 'mylive',
        date: '09-27', // 时间
        label: '川菜', // 标签
        status: true,
        rule: '', // 使用规则
      }
      */
    ],
    showRules: {
      info: [],
      enabled: false,
    },
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    console.log("当前用户昵称:", app.globalData.userInfo.nickName)


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
  onShow: function (options) {
  
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
  tapBtnJumpToShop: function(e) {
    const id = e.currentTarget.dataset.id
    app.jumpPage('/pages/mylive/detail?id=' + id)
  },
  handleTapUsedRule: function(e) {
    const rule = e.currentTarget.dataset.rule
    this.setData({
      'showRules.info': rule.split('\r\n'),
      'showRules.enabled': true
    })
    console.log("显示使用规则")
  },
  handleTouchMoveMark: function(e){

  },
  handleTapCloseMessage: function(e) {
    this.setData({
      'showRules.enabled': false
    })
  },
  handleFirstUsedWallet: function () {
    app.globalData.userInfo.taskTotal = 2
    app.taskFirstUsed()
  },
  _init: function() {
    this.setData({
      'currentAttribute.page': 1,
      'currentAttribute.overPage': false,
      'dataList': []
    })

    this._getData()
  },
  _getData: function(){
    const post_data = {
      page: this.data.currentAttribute.page,
      pageSize: this.data.pageSize,
      userId: app.globalData.userInfo.server_uid
    }
    const success_server = (resData) => {
      console.log("获取<我的钱包>成功:", resData)
      if (resData.data) {
        let temp_datas = this.data.dataList

        let old_length = temp_datas.length
        if (old_length > 0) {
          old_length += 1
        }
        if (resData.data.length == 0) {
          if (old_length == 0) {
            this.setData({
              NotFoundData: '--没有数据--',
            })
          }
          this.setData({
            'currentAttribute.overPage': true
          })
        } else {
          resData.data.forEach((item, index, array) => {
            temp_datas.push({
              id: item.pubId || old_length + index,
              index: old_length + index,
              date: item.date || '', // 消费时间
              shopPhoto: item.pic || '',
              name: item.name || '', // 店铺名称
              title: item.title || '', // 属性
              address: item.addr || '', // 地址
              label: item.label || '', // 标签
              type: item.url,
              status: parseInt(item.merchantState) == 1 ? true : false, // 商家状态 1:正常 other:下架
              rule: item.usageRule || '', // 使用规则
            })
          })
          this.setData({
            'dataList': temp_datas,
            'NotFoundData': '',
          })
        }
      }
      if (resData.balance){
        this.setData({
          'currentAttribute.balance': resData.balance
        })
      }
    }
    const fail_server = (errorMessage) => {
      console.log("获取<我的钱包>错误", errorMessage)

      app.showLoadDataError({
        title: '数据获取失败',
        content: '我的钱包数据载入失败:' + errorMessage,
        retry: () => {
          this._getData()
        }
      })
    }
    app.Tools.API_server.getWallet(post_data, success_server, fail_server)
  }
})