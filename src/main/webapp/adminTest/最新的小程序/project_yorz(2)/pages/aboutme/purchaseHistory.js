const app = getApp()
// pages/aboutme/purchaseHistory.js 消费记录
Page({

  /**
   * 页面的初始数据
   */
  data: {
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径
    resourceServer: app.globalData.resourceServer, // 服务器资源路径

    globalData: app.globalData,
    NotFoundData: '',

    pageSize: 10,
    currentAttribute: {
      page: 1, // 当前页面
      overPage: false, // 是否已经载入完
    },
    dataList: [
      /*
      {
        id: '5b25d7397d170b4f5cc5c4d8',
        shopPhoto: '5b25d7687d170b4f5cc5c4ec.png',
        name: '痴小鱼餐厅(江北区)', // 商家名
        amount: '89.0', // 抵扣金额
        used: '260.0', // 消费
        date: '06-19',
        label: '餐厅',
        type: 'mylive',
        status: false,
      }, {
        id: '5b25d1d97d170b4f5cc5c4a0',
        shopPhoto: '5b25f43b7d170b52660666c3.png',
        name: '丝路香妃', // 商家名
        amount: '20.33',// 抵扣金额
        used: '188.0', // 消费金额
        date: '05-01',
        label: '新疆菜',
        type: 'mylive',
        status: false,
      }, {
        id: '5b52e3ae0be7101658c237bc',
        shopPhoto: '5b2774b07d170b65bfd57ac1.png',
        name: '十三椒老坛酸菜鱼', // 商家名
        amount: '76.03',// 抵扣金额
        used: '345.0', // 消费金额
        date: '04-21',
        label: '川菜',
        type: 'mylive',
        status: true,
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
    wx.setNavigationBarTitle({ title: '消费记录' }) // 动态设置当前页面的标题

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
  tapBtnJumpToShop: function (e) {
    const id = e.currentTarget.dataset.id
    app.jumpPage('/pages/mylive/detail?id=' + id)
  },
  _init: function () {
    this.setData({
      'currentAttribute.page': 1,
      'currentAttribute.overPage': false,
      //'dataList': []
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
      console.log("获取<我的消费记录>成功:", resData)
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
              id: item.pubId,
              index: old_length + index,
              date: item.date, // 消费时间
              shopPhoto: item.pic,
              name: item.name, // 商家名称
              amount: item.dikou, // 抵扣金额
              used: item.xiafei,  // 消费金额
              label: item.label, // 标签
              type: item.url,
              status: parseInt(item.merchantState) == 1 ? true : false, // 商家状态 1:正常 other:下架
            })
          })
          this.setData({
            'dataList': temp_datas,
            'NotFoundData': '',
          })
        }
      }
    }
    const fail_server = (res) => {
      console.log("获取<我的消费记录>错误", res)
      app.showLoadDataError({
        title: '数据获取失败',
        content: '消费记录数据载入失败:' + errorMessage,
        retry: () => {
          this._getData()
        }
      })
    }
    app.Tools.API_server.getPurchaseHistory(post_data, success_server, fail_server)
  }

  
})