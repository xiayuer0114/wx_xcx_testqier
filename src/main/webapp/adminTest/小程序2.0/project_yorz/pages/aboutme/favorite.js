const app = getApp()
// pages/aboutme/favorite.js
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
        date: '06-19',
        shopPhoto: '5b25d7687d170b4f5cc5c4ec.png',
        name: '八零年代江湖菜',
        amount: '89.0',
        address: '渝北区红锦大道红旗河沟渝通宾馆背后龙湖',
        label: '餐厅',
        type: 'mylive',
      }, {
        id: '5b25d1d97d170b4f5cc5c4a0',
        date: '05-01',
        shopPhoto: '5b25f43b7d170b52660666c3.png',
        name: '雾里咖啡',
        amount: '29.0',
        address: '南岸区南滨路80号附1号',
        label: '咖啡厅',
        type: 'mylive',
      }
      */
    ]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    if (options && options.title){
      this.setData({
        title: options.title
      })
    }

    app.init(() => {
      this.setData({
        globalData: app.globalData, // 全局数据
      })
      if (app.globalData.sysUserLogined || app.globalData.userInfo.server_uid != ''){
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
    wx.setNavigationBarTitle({ title: '我的收藏' }) // 动态设置当前页面的标题

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
  tapBtnJumpToShop: function (e) {
    const id = e.currentTarget.dataset.id
    const itemType = e.currentTarget.dataset.type
    switch (itemType) {
      case 'pages/mylive/detail':
        app.jumpPage('/pages/mylive/detail?id=' + id)
        break
      case 'pages/recommend/detail':
        app.jumpPage('/pages/recommend/detail?id=' + id)
        break
      default:
        break
    }
  },
  _init: function(){
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
    const success_server = (resData) =>{
      console.log("获取<我的收藏>成功:", resData)
      if(resData.data){
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
              date: item.date, // 日期
              shopPhoto: item.pic, // 图片
              name: item.name, // 商家名称|文章标题
              amount: parseInt(item.avg) , //人均消费(可能为空)
              address: item.addr, // 地址(可能为空)
              label: item.label, // 标签
              type: item.url, 
            })
          })
          this.setData({
            'dataList': temp_datas,
            'NotFoundData': '',
          })
        }
      }
    }
    const fail_server = (errorMessage) => {
      console.log("获取<我的收藏>错误:", errorMessage)

      app.showLoadDataError({
        title: '数据获取失败',
        content: '我的收藏数据载入失败:' + errorMessage,
        retry: () => {
          this._getData()
        }
      })
    }
    app.Tools.API_server.getFavorite(post_data, success_server, fail_server)
  }
})