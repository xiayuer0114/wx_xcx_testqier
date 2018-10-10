const WxParse = require('../../utils/wxParse/wxParse.js');

const app = getApp()
// pages/mylive/detail.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    resourceServer: app.globalData.resourceServer, // 服务器资源路径
    resourceLocal: app.globalData.resourceLocal, // 本地资源路径

    globalData: app.globalData, 

    canShare: true, // 是否允许分享
    canCollect: false, // 是否可收藏
    haveCollect: false, // 是否已收藏

    shop: { // 店铺信息
      name: "", // 店铺名称
      sign: "",  // 店铺标志
      price: "", // 消费水平
      businessHours: "", // 营业时间
      phone: "", // 联系电话
      address: "", // 店铺地址
      distances: "", // 需根据坐标获取路程
      coordinate: { // 店铺坐标信息
        latitude: "", // 纬度
        longitude: "", // 经度
        altitude: "" // 高度
      },
    },
    article: { // 文章信息
      id: '',
      title: '',  // 文章标题
      subTitle: '',
      author: '', // 作者 [接口弃用]
      photography: '', // 摄影师 [接口弃用]
      collected: false, // 是否收藏
      images: [], // 图片
      video: {
        id: '',
        source: ''
      }, // 视频地址
      detail: [
        {
          name: 'p',
          attrs: {
            class: 'p_class',
            style: 'line-height: 24px; padding:16px 0; color: #848484; font-size: 14px;'
          },
          children: [{
            type: 'text',
            text: '有这样一种店——店面好看，颜值满分；服务很棒，舒适满分；东西好吃，美味满分。平日没事就喜欢去这里坐一坐，歪果仁出门吃饭也认准这一家。这样的店重庆都不多，而我们恰好找到了一家——Restaurant A，一家早已成为重庆网红地的法式西餐厅。'
          }]
        }, {
          name: 'img',
          attrs: {
            class: 'img_class',
            style: '',
            src: 'https://tiesh.liebianzhe.com/attachFiles/20180608/5b1a549b7d170b3af2283fe3/5b209670d6c4590459fff8b8'
          }
        }, {
            name: 'p',
            attrs: {
              class: 'p_class',
              style: 'line-height: 24px; padding:16px 0; color: #848484; font-size: 14px;'
            },
            children: [{
              type: 'text',
              text: 'Inernational，一定不是说说而已。开在鎏嘉码头的法式西餐厅，也接收着来来往往的食客的洗礼，重庆的码头文化和五湖四海的文化交融，这里精英荟萃，或许这里就是重庆国际窗口的一个小缩影。'
            }]
          }
      ], // 文章详情
      tigs: [ // 标签
        /*
        {
          id:"1",
          type: "12",
          title: "西餐"
        }, {
          id: "2",
          type: "13",
          title: "法式"
        }
        */
      ]
    }
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    console.log("文章详情页加载:", options)


    if (options && options.id) {
      this.data.article.id = options.id // 页面传递的编号
    } else {
      wx.showModal({
        title: '获取失败',
        content: '内容获取失败,请重试!',
        showCancel: false,
        confirmText: '返回',
        success: res => {
          if (res.confirm) {
            wx.navigateBack({ delta: 1 })
          }
        }
      })
    }

    app.init(() => {
      this.setData({
        globalData: app.globalData, // 全局数据
      })
      console.log("广告:", app.globalData.advertisement)
      if (app.globalData.advertisement.length == 0){
        app.getAdvertisement()
      }
      this._init()
    })


    /*
    // 滚动到指定位置
    wx.pageScrollTo({
      scrollTop: 300,
      duration: 300
    })
    */
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    wx.setNavigationBarTitle({ title: '生活圈' }) // 动态设置当前页面的标题
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function (options) {
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
  
  },
  
  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function (options) {
    console.log("用户点击右上角分享", options)

    if (options.from === 'button') {
      console.log("来自页面内转发按钮", options.target)
    }

    return {
      title: this.data.article.title,
      path: '/pages/mylive/detail?id=' + this.data.article.id,
      //imageUrl: this.data.resourceServer + this.data.article.images[0]
    }
  },

  /**
   * 拨打商家电话
   */
  tapBtnMakeCall: function (e) {
    if(app.globalData.userInfo.isNewUser) {
      app.globalData.userInfo.taskTotal = 4
      this.setData({
        'globalData.userInfo.taskTotal': 4
      })
    } else {
      wx.makePhoneCall({
        phoneNumber: this.data.shop.phone
      })
    }
  },
  /**
   * 打开商家地图
   */
  tapBtnOpenLocation: function (e) {
    if (app.globalData.userInfo.isNewUser) {
      app.globalData.userInfo.taskTotal = 5
      this.setData({
        'globalData.userInfo.taskTotal': 5,
        'globalData.userInfo.isNewUser': false
      })
      app.taskFirstUsed()
    } else {
      wx.openLocation({
        latitude: this.data.shop.coordinate.latitude, // 纬度
        longitude: this.data.shop.coordinate.longitude, // 经度
        scale: 18, // 缩放比例,范围5~18,默认为18
        name: this.data.shop.name, // 位置名
        address: this.data.shop.address, // 地址的详细说明
      })
    }
  },
  /**
   * 点击收藏
   */
  tapBtnFavorite: function(e){
    console.log("点击了收藏按钮")
    const post_data = {
      userId: this.data.globalData.userInfo.server_uid, // 用户编号
      pubId: this.data.article.id
    }
    const callback_success = (resData) => {
        console.log("添加收藏夹成功:", resData)
        if(resData.handing) {
          this.setData({
            'article.collected': !this.data.article.collected
          })
        }
    }
    const fail_callback = (resData) => {
      console.log("添加收藏夹失败:", resData)
    }
    app.Tools.API_server.postFavoriteArticle(post_data, callback_success, fail_callback)

  },
  /**
   * 点击标签
   */
  tapBtnTags: function (e) {
    const title = e.currentTarget.dataset.title
    console.log("即将跳转到:", title)
    wx.navigateTo({
      url: '/pages/mylive/list?type=' + title,
      success: (res) => {
        console.log("跳转成功:", res)
      },
      fail: (res) => {
        console.log("跳转失败:", res)
      }
    })
  },
  /**
   * 点击广告图
   */
  hanldTapAd: function (e) {
    const id = e.currentTarget.dataset.id
    const itemType = e.currentTarget.dataset.type
    switch (itemType) {
      case 'pages/mylive/detail':
        wx.navigateTo({
          url: '/pages/mylive/detail?id=' + id
        })
        break
      case 'pages/recommend/detail':
        wx.navigateTo({
          url: '/pages/recommend/detail?id=' + id
        })
        break
      default:
        break
    }
  },
  /**
   * 页面数据初始化
   */
  _init: function () {

    this._getArticleDetail()
  },
  /**
   * 获取文章详情数据
   */
  _getArticleDetail: function () {
    const req_data = {
      pubId: this.data.article.id, // 文章编号
      userId: this.data.globalData.userInfo.server_uid, // 用户编号
      longitude: this.data.globalData.userInfo.coordinate.longitude, // 用户的经度
      latitude: this.data.globalData.userInfo.coordinate.latitude // 用户的纬度
    }
    const callback_success = (resData) => {
      if (resData){
        //console.groupCollapsed("文章解析:")
        //console.log('原始文章内容:', resData.data.pubContent)
        WxParse.wxParse('article.detail', 'html', resData.data.pubContent, this, 5)   // 解析HTML
        //console.groupEnd()

        this.setData({
          'shop.name': resData.data.name || '',
          'shop.sign': resData.data.headPortrait || '',
          'shop.price': parseInt(resData.data.avg) || '0',
          'shop.businessHours': resData.data.businessHours || '',
          'shop.phone': resData.data.phone || '',
          'shop.address': resData.data.addr || '',
          'shop.distances': resData.data.distance || '',
          'shop.coordinate.latitude': resData.data.latitude || '',
          'shop.coordinate.longitude': resData.data.longitude || '',
        })
        this.setData({
          'article.id': resData.data.pubId || this.data.article.id,
          'article.title': resData.data.pubTitle || '',
          'article.subTitle': resData.data.pubSubhead || '',
          'article.video.source': resData.data.video || '',
          'article.collected': resData.data.beCollected == 1 ? true : false,
        })

        let temp_images = []
        if (resData.data.pubPics) {
          resData.data.pubPics.forEach((item, index, array) => {
            temp_images.push(item)
          })
        }
        this.setData({
          'article.images': temp_images
        })
        let temp_labels = []
        if (resData.data.labelList) {
          resData.data.labelList.forEach((item, index, array) => {
            temp_labels.push({
              id: index,
              title: item,
              type: ''
            })
          })
        }
        this.setData({
          'article.tigs': temp_labels
        })
      }
    }
    const fail_callback = errorMessage => {

      console.log("获取生活圈详情错误:", errorMessage)
      app.showLoadDataError({
        title: '数据获取失败',
        content: '生活圈详情载入失败:' + errorMessage,
        retry: () => {
          this._getArticleDetail()
        }
      })
    }
    const complete_callback = (resData) => {
      wx.hideLoading()
    }

    wx.showLoading({ // 显示加载框
      title: '内容呈现中...',
      mask: true,
      success: () => { },
      fail: () => { },
      complete: () => { }
    })
    app.Tools.API_server.getArticleDetail(req_data, callback_success, fail_callback, complete_callback)
  },
})