const utils = require("../../utils/util.js")
const app = getApp()

// pages/index/home.js
Page({
  pageComponent: null,
  liveList: null,
  articleList: null, // 组件对象

  /**
   * 页面的初始数据
   */
  data: {
    globalData: app.globalData,

    canUse_OpenData: wx.canIUse('open-data'),
    /**
     * 页面属性
     */
    pageAttribute: {
      showTabbar: true, // 是否显示底部Tabbar
      tabbarIndex: 0, // 当前选中Tabbar索引
      scrollY: false, // 页面是否可滚动
      handleScrollUpper: false, // 是否监控滚动条顶部
      handleScrollLower: false, // 是否监控滚动条底部
      loadMoreData: false, // 是否可加载更多
      showPageMark: false, // 是否页面显示蒙版[防止误操作]

    },
    /**
     * 主显区公共属性
     */
    bodyData: {
      openLeftMenu: false, // 左侧菜单
      openRightMenu: false, // 右侧菜单
      showBodyMark: false, // 是否内容区显示蒙版[关闭弹出菜单]

      NotFoundDatas: '',
      city: app.globalData.currentCity, // 当前城市
    },
    searchAttribute: {
      page: 1, // 当前页数
      total: 5, // 显示搜索结果数量
      showResult: false,
      timer: null,
      searchText: '',
      result: [{
        id: '',
        name: '',
        intro: '',
        type: ''
      }]
    },

    /**
     * 滑动屏幕事件
     */
    touches: {
      toucheX: 0,
      toucheXNew: 0,
      toucheY: 0,
      toucheYNew: 0,

      tolerance: 12, // 垂直滑动容差值
      validity: undefined, // 是否有效滑动

      isToRight: undefined, // 手势水平移动方向 true:右滑动 false:左滑动
      isToBottom: undefined, // 手势垂直移动方向
    },
    /**
     * 推荐卡相关属性
     */
    cardAttribute: {
      initialize: false, // 页面是否已初始化
      pageSize: 5, // 每页数量
      page: 1, // 当前页面
      overPageData: false,
      dataList: [],
      animationDatas: {}, // 动画效果

      distance: {  // 距离
        title: '',
        latitude: 0,
        longitude: 0,
        name: '',
        address: '',
      }
    },
    /**
     * 生活圈相关属性
     */
    liveAttribute: {
      initialize: false, // 页面是否已初始化
      currentTypeIndex: 0,
      currentType: '',
      currentArea: '',

    },
    /**
     * 专题相关属性
     */
    articleAttribute: {
      initialize: false, // 页面是否已初始化
      typeId: '',
      typeName: '',

    },
    /**
     * 我的相关属性
     */
    aboutAttribute: {
      initialize: false, // 页面是否已初始化
    }

  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    if (!options) {
      options = {}
    }

    if (options.hasOwnProperty('city')) {
      app.globalData.currentCity = options.city
      this.setData({
        'bodyData.city': options.city
      })
    } else {
      this.setData({
        'bodyData.city': app.globalData.currentCity
      })
    }
    if (options.hasOwnProperty('tabbarIndex')){
      const index = parseInt(options.tabbarIndex)
      if (index >= 0 && index < 4){
        this.setData({
          'pageAttribute.tabbarIndex': index
        })
      }
      switch (index) {
        case 1:
          if (options.hasOwnProperty('type')) {
            this.setData({
              'liveAttribute.currentType': options.type
            })
          }
          if (options.hasOwnProperty('area')) {
            this.setData({
              'liveAttribute.currentArea': options.area
            })
          }
          break;
        case 2:
          if (options.hasOwnProperty('name')) {
            this.setData({
              'articleId': options.id,
              'articleName': options.name,
            })
          }
          break;
        default:

          break;
      }
    }

  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.pageComponent = this.selectComponent("#pageComponent")
    this.liveList = this.selectComponent("#liveList")
    this.articleList = this.selectComponent("#articleList")
    app.init(() => {
      this.setData({
        'globalData': app.globalData, // 全局数据
        'liveAttribute.currentTypeIndex': app.globalData.shopTypes[0].order, // 全局数据
      })
      if (utils.compareVersion(app.globalData.systemInfo.SDKVersion, '1.4.0') >= 0) {
        this.setData({
          canUse_OpenData: true
        })
      }
      this._init()
    })
  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    this.setData({
      'globalData': app.globalData
    })
    console.log("页面重新载入:", app.globalData.userInfo)
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
  onShareAppMessage: function () {
  
  },
  /**
   * 当前是tab页时，点击tab时触发
   */
  onTabItemTap: function (item) {
    app.Tools.Debug.Page.onTabItemTap(item)
    console.log(item)
    console.log(item.pagePath)
    console.log(item.text)
  },

  /*
   * 触摸开始
   */
  handleTouchStart: function (e) {
    //app.Tools.Debug.Logger.info('滑动开始')
    this.data.touches.toucheX = this.data.touches.toucheXNew = e.touches[0].pageX
    this.data.touches.toucheY = this.data.touches.toucheYNew = e.touches[0].pageY
    this.data.touches.validity = false
  },
  /*
   * 触摸移动
   */
  handleTouchMove: function (e) {
    //app.Tools.Debug.Logger.info('滑动中')
    let vertical = undefined // 垂直方向是否有效 true: 已改变 false 无改变
    let horizontal = undefined // 水平方向是否有效 true: 已改变 false 无改变
    let horizontal_ratio = this.data.pageAttribute.tabbarIndex == 1 ? 0.6 : 1
    let vertical_ratio = this.data.pageAttribute.tabbarIndex == 1 ? 3 : 0.8

    this.data.touches.toucheXNew = e.touches[0].pageX
    this.data.touches.toucheYNew = e.touches[0].pageY

    if (this.data.touches.toucheY < this.data.touches.toucheYNew) { // 手指从上向下移
      this.data.touches.isToBottom = true
      if (Math.abs(this.data.touches.toucheYNew - this.data.touches.toucheY) < this.data.touches.tolerance * vertical_ratio) { // 超出容差范围
        vertical = true
      } else {
        vertical = false
      }
    } else if (this.data.touches.toucheY > this.data.touches.toucheYNew) {// 手指从下向上移
      this.data.touches.isToBottom = false
      if (Math.abs(this.data.touches.toucheY - this.data.touches.toucheYNew) < this.data.touches.tolerance * vertical_ratio) { // 超出容差范围
        vertical = true
      } else {
        vertical = false
      }
    } else { // 没有改变
      vertical = undefined
    }

    if (this.data.touches.toucheX < this.data.touches.toucheXNew) { // 手指从左向右移动
      this.data.touches.isToRight = true
      if (Math.abs(this.data.touches.toucheXNew - this.data.touches.toucheX) > this.data.touches.tolerance * horizontal_ratio) {
        horizontal = true
      } else {
        horizontal = false
      }
    } else if (this.data.touches.toucheX > this.data.touches.toucheXNew) { // 手指从右向左移动
      this.data.touches.isToRight = false
      if (Math.abs(this.data.touches.toucheX - this.data.touches.toucheXNew) > this.data.touches.tolerance * horizontal_ratio) {
        horizontal = true
      } else {
        horizontal = false
      }
    } else {// 没有改变
      horizontal = undefined
    }

    if (this.data.pageAttribute.tabbarIndex == 0) {
      /**
       * 1.垂直和水平方向都有效
       * 2.水平方向有效, 垂直方向无改变
       * 3.垂直方向有效, 水平方向无改变
       */
      if (horizontal) {
        this.data.touches.validity = true
      } else {
        this.data.touches.validity = false
      }
    } else if (this.data.pageAttribute.tabbarIndex == 1) {
      if (horizontal === true && vertical !== false && this.data.touches.toucheY < 1050) { // 垂直和水平方向都有效
        this.data.touches.validity = true
      } else {
        this.data.touches.validity = false
      }
    }
  },
  /*
   * 触摸结束
   */
  handleTouchEnd: function (e) {
    // app.Tools.Debug.Logger.info('滑动结束')
    const validity = this.data.touches.validity // 取出备用

    // 重置 滑动屏幕事件监控值
    this.data.touches.toucheX = 0
    this.data.touches.toucheXNew = 0
    this.data.touches.toucheY = 0
    this.data.touches.toucheYNew = 0
    this.data.touches.validity = false
    app.Tools.Debug.Logger.info("是否有效滑动:", validity, this.data.touches.isToRight)

    if (validity) { // 是否有效滑动
      if (this.data.pageAttribute.tabbarIndex == 0) {
        this._setCardAnimation(e)
      } else if (this.data.pageAttribute.tabbarIndex == 1) {
        this._setLiveAnimation()
      } else{
        console.log("当前手势选项卡:", this.data.pageAttribute.tabbarIndex)
      }

    }
  },

  _setCardAnimation: function (e) {
    let animation_arr_temp = [] // 
    const animation_obj_temp = this.data.cardAttribute.animationDatas

    const currentIndex = e.currentTarget.dataset.index
    const itemOrder = e.currentTarget.dataset.order
    const dataLength = this.data.cardAttribute.dataList.length

    // app.Tools.Debug.Logger.info("推荐卡 当前项:", currentIndex, itemOrder)

    if (this.data.touches.isToRight) { // 向右滑动 [下一页]

      if (currentIndex == 1 && !this.data.cardAttribute.overPageData) { // 展示最后一项时开始载入下一页
        this.data.cardAttribute.page += 1
        this._getData_Home() // 获取下一页
      }

      if (currentIndex == 0) {
        if (this.data.cardAttribute.overPageData) {
          app.Tools.API_wx.showToast("您有选择障碍症吗？", 3000)
        }
        if (itemOrder > 0) {
          // 1.设置距离参数
          this.setData({
            'cardAttribute.distance.title': this.data.cardAttribute.dataList[itemOrder - 1].distance,
            'cardAttribute.distance.latitude': this.data.cardAttribute.dataList[itemOrder - 1].latitude,
            'cardAttribute.distance.longitude': this.data.cardAttribute.dataList[itemOrder - 1].longitude,
            'cardAttribute.distance.name': this.data.cardAttribute.dataList[itemOrder - 1].name,
            'cardAttribute.distance.address': this.data.cardAttribute.dataList[itemOrder - 1].address
          })
        }
        // 3. 重置数组动画元素
        this.data.cardAttribute.dataList.forEach((item, idx, array) => {
          animation_arr_temp[item.order] = wx.createAnimation({
            duration: 500,
            timingFunction: "step-start"
          })
          switch (idx) {
            case 1: // 第二项
              animation_arr_temp[item.order].top(0).left(0).width('100%').height('100%').opacity(0.8).rotate(4).step()
              break;
            case 2: // 第三项
              animation_arr_temp[item.order].top(0).left(0).width('100%').height('100%').opacity(0.5).rotate(-4).step()
              break;
            default:
              animation_arr_temp[item.order].top(0).left(0).width('100%').height('100%').opacity(1).rotate(0).step()
              break;
          }
          animation_obj_temp[item.order] = animation_arr_temp[item.order].export()
        })

      } else {
        // 1.设置距离参数
        const nextOrder = dataLength - itemOrder - 2
        //console.log("下一个序号为:", nextOrder, this.data.cardAttribute.dataList[nextOrder].name)
        this.setData({
          'cardAttribute.distance.title': this.data.cardAttribute.dataList[nextOrder].distance,
          'cardAttribute.distance.latitude': this.data.cardAttribute.dataList[nextOrder].latitude,
          'cardAttribute.distance.longitude': this.data.cardAttribute.dataList[nextOrder].longitude,
          'cardAttribute.distance.name': this.data.cardAttribute.dataList[nextOrder].name,
          'cardAttribute.distance.address': this.data.cardAttribute.dataList[nextOrder].address,
        })

        // 3. 改变动画终止参数
        animation_arr_temp[itemOrder] = wx.createAnimation({
          duration: 800,
          timingFunction: "ease"
        })
        animation_arr_temp[itemOrder + 1] = wx.createAnimation({
          duration: 300,
          timingFunction: "ease"
        })
        animation_arr_temp[itemOrder + 2] = wx.createAnimation({
          duration: 300,
          timingFunction: "ease"
        })
        animation_arr_temp[itemOrder + 3] = wx.createAnimation({
          duration: 300,
          timingFunction: "ease"
        })
        this.animation = animation_arr_temp

        animation_arr_temp[itemOrder].top(-120).left('150%').width(0).height(0).opacity(0).step()  // 当前项终止参数

        animation_obj_temp[itemOrder] = animation_arr_temp[itemOrder].export()

        animation_arr_temp[itemOrder + 1].rotate(0).opacity(1).step()
        animation_obj_temp[itemOrder + 1] = animation_arr_temp[itemOrder + 1].export()

        animation_arr_temp[itemOrder + 2].rotate(4).opacity(0.6).step()
        animation_obj_temp[itemOrder + 2] = animation_arr_temp[itemOrder + 2].export()

        animation_arr_temp[itemOrder + 3].rotate(-4).opacity(0.5).step()
        animation_obj_temp[itemOrder + 3] = animation_arr_temp[itemOrder + 3].export()

      }
      // 更新动画效果
      this.setData({
        'cardAttribute.animationDatas': animation_obj_temp,
      })
    } else { // 向左滑动 [上一页]
      if (itemOrder > 0) {
        // 1. 设置距离参数
        const preOrder = dataLength - itemOrder
        //console.log("上一个序号为:", preOrder, this.data.cardAttribute.dataList[preOrder].name)
        this.setData({
          'cardAttribute.distance.title': this.data.cardAttribute.dataList[preOrder].distance,
          'cardAttribute.distance.latitude': this.data.cardAttribute.dataList[preOrder].latitude,
          'cardAttribute.distance.longitude': this.data.cardAttribute.dataList[preOrder].longitude,
          'cardAttribute.distance.name': this.data.cardAttribute.dataList[preOrder].name,
          'cardAttribute.distance.address': this.data.cardAttribute.dataList[preOrder].address,
        })

        animation_arr_temp[itemOrder + 2] = wx.createAnimation({
          duration: 300,
          timingFunction: "ease",
          delay: 500
        })
        animation_arr_temp[itemOrder + 1] = wx.createAnimation({
          duration: 300,
          timingFunction: "ease",
          delay: 500
        })
        animation_arr_temp[itemOrder] = wx.createAnimation({
          duration: 300,
          timingFunction: "ease",
          delay: 500
        })
        animation_arr_temp[itemOrder - 1] = wx.createAnimation({
          duration: 500,
          timingFunction: "ease"
        })
        animation_arr_temp[itemOrder + 2].rotate(0).opacity(1).step()
        animation_obj_temp[itemOrder + 2] = animation_arr_temp[itemOrder + 2].export()

        animation_arr_temp[itemOrder + 1].rotate(-4).opacity(0.5).step()
        animation_obj_temp[itemOrder + 1] = animation_arr_temp[itemOrder + 1].export()

        animation_arr_temp[itemOrder].rotate(4).opacity(0.6).step()
        animation_obj_temp[itemOrder] = animation_arr_temp[itemOrder].export()

        //animation_arr_temp[itemOrder - 1].top(-800).step({ duration: 100 })
        //animation_arr_temp[itemOrder - 1].top(-120).left('-200%').step({ duration: 100 })
        animation_arr_temp[itemOrder - 1].rotate(0).top(0).left(0).width('100%').height('100%').opacity(1).step()
        animation_obj_temp[itemOrder - 1] = animation_arr_temp[itemOrder - 1].export()

        // 更新动画效果
        this.setData({
          'cardAttribute.animationDatas': animation_obj_temp,
        })
      } else {
        // 已滑动到页头
        app.Tools.API_wx.showToast("精选从这开始", 3000)
      }

    }

  },
  _setLiveAnimation: function () {
    if (this.data.touches.isToRight === true) { // 向右滑动,上一标签 [关闭RightMenu或打开LeftMenu]
      if (this.data.liveAttribute.currentTypeIndex > 0) {
        const current_index = this.data.liveAttribute.currentTypeIndex - 1
        this.setData({
          'liveAttribute.currentTypeIndex': current_index
        })
        this._init_Live({ type: this.data.globalData.shopTypes[current_index].name })
      } else {
        wx.showLoading({
          title: '', // 已到第一项
          mask: true,
          complete: () => {
            setTimeout(() => {
              wx.hideLoading()
            }, 2000)
          }
        })
      }
      /*
        // 屏蔽左右滑动展开菜单功能
        if (this.data.pageAttribute.openRightMenu) {
          this.setData({
            'pageAttribute.openRightMenu': false
          })
        } else if (!this.data.pageAttribute.openLeftMenu) {
          this.setData({
            'pageAttribute.openLeftMenu': true
          })
        }
      */
    } else if (this.data.touches.isToRight === false) { // 向左滑动, 下一标签 [关闭LeftMenu或打开RightMenu]
      if (this.data.liveAttribute.currentTypeIndex < this.data.globalData.shopTypes.length) {
        const current_index = this.data.liveAttribute.currentTypeIndex + 1
        this.setData({
          'liveAttribute.currentTypeIndex': current_index
        })
        this._init_Live({ type: this.data.globalData.shopTypes[current_index].name })
      } else {
        wx.showLoading({
          title: '', // 已到最后项
          mask: true,
          complete: () => {
            setTimeout(() => {
              wx.hideLoading()
            }, 2000)
          }
        })
      }
      /*
        // 屏蔽左右滑动展开菜单功能
        if (this.data.pageAttribute.openLeftMenu) {
          this.setData({
            'pageAttribute.openLeftMenu': false
          })
        } else if (!this.data.pageAttribute.openRightMenu) {
          this.setData({
            'pageAttribute.openRightMenu': true
          })
        }
      */
    } else {
      console.log("手势移动方向:", this.data.touches.isToRight, this.data.touches.isToBottom)
    }
  },
  /**
   * 页面初始化
   */
  _init: function () {
    //console.log("主页初始化:", this.data.pageAttribute.tabbarIndex)
    switch (this.data.pageAttribute.tabbarIndex) {
      case 1:
        this._init_Live()
        break;
      case 2:
        this._init_Article()
        break;
      case 3:
        this._init_About()
        break;
      default:
        this._init_Home()
      break;
    }
  },
  _init_Home: function() {
    wx.setNavigationBarTitle({ title: '新店推荐' }) // 动态设置当前页面的标题
    this.setData({
      'pageAttribute.scrollY': false, // 页面是否可滚动
      'pageAttribute.handleScrollUpper': false, // 是否监控滚动条顶部
      'pageAttribute.handleScrollLower': false, // 是否监控滚动条底部
      'pageAttribute.loadMoreData': false, // 是否可加载更多
      'pageAttribute.showPageMark': false, // 是否显示页面蒙版
    })
    if (!this.data.cardAttribute.initialize){
      this._getData_Home()
      this.setData({
        'cardAttribute.initialize': true
      })
    }
  },
  _init_Live: function (options) {
    wx.setNavigationBarTitle({ title: '生活圈' }) // 动态设置当前页面的标题
    this.setData({
      'pageAttribute.scrollY': true, // 页面是否可滚动
      'pageAttribute.handleScrollUpper': false, // 是否监控滚动条顶部
      'pageAttribute.handleScrollLower': true, // 是否监控滚动条底部
      'pageAttribute.loadMoreData': true, // 是否可加载更多
      'pageAttribute.showPageMark': false, // 是否显示页面蒙版
    })
    if (this.liveList) {
      if (options) { // 组件属性更新
        if (options.hasOwnProperty('type') && options.type !== '') {
          this.setData({
            'liveAttribute.currentType': options.type
          })
        }
      } else if (!this.data.liveAttribute.initialize) {
        this.liveList.init(app) // 组件初始化
        this.setData({
          'liveAttribute.initialize': true
        })
      }
    } else {
      app.Tools.Debug.Logger.info("生活圈 没有初始化组件liveList:", this.liveList)
    }
  },
  _init_Article: function () {
    wx.setNavigationBarTitle({ title: '专题' }) // 动态设置当前页面的标题
    this.setData({
      'pageAttribute.scrollY': true, // 页面是否可滚动
      'pageAttribute.handleScrollUpper': false, // 是否监控滚动条顶部
      'pageAttribute.handleScrollLower': true, // 是否监控滚动条底部
      'pageAttribute.loadMoreData': true, // 是否可加载更多
      'pageAttribute.showPageMark': false, // 是否显示页面蒙版
    })
    if (this.articleList) {
      if (!this.data.articleAttribute.initialize) {
        this.articleList.init(app) // 调用组件初始化方法
        this.setData({
          'articleAttribute.initialize': true
        })
      }
    } else {
      app.Tools.Debug.Logger.info("专题 没有初始化组件articleList:", this.articleList)
    }
  },
  _init_About: function () {
    wx.setNavigationBarTitle({ title: '我的' }) // 动态设置当前页面的标题
    this.setData({
      'pageAttribute.scrollY': false, // 页面是否可滚动
      'pageAttribute.handleScrollUpper': false, // 是否监控滚动条顶部
      'pageAttribute.handleScrollLower': false, // 是否监控滚动条底部
      'pageAttribute.loadMoreData': false, // 是否可加载更多
      'pageAttribute.showPageMark': false, // 是否显示页面蒙版
    })
    if (!this.data.aboutAttribute.initialize) {
      this.setData({
        'aboutAttribute.initialize': true
      })
    }
  },
  /**
   * Page组件到顶部 刷新页面
   */
  handlePageFresh: function (e) {
    console.log("Page组件到顶部:", e)
    this.pageComponent.handleScrollUpper()
  },
  /**
   * Page组件到底部 加载下一页
   */
  handlePageNext: function (e) {
    console.log("Page组件到底部:", e)
    if (this.liveList && this.data.pageAttribute.tabbarIndex == 1) {

      const loaded = this.liveList.nextPage()
      if (!loaded) {
        this.setData({
          'pageAttribute.loadMoreData': false, // 已加载完所有数据
        })
      }
    } else if (this.articleList && this.data.pageAttribute.tabbarIndex == 2) {
      const loaded = this.articleList.nextPage()
      if (!loaded) {
        this.setData({
          'pageAttribute.loadMoreData': false, // 已加载完所有数据
        })
      }
    } else {
      this.pageComponent.handleScrollLower()
    }
  },
  /**
   * Page组件滚动条
   */
  handlePageScroll: function (e) {
    //console.log("Page组件滚动条事件:", e)
  },
  /**
   * Page组件事件: 系统配置文件载入错误刷新事件
   */
  handleConfigLoading: function (e) {
    app.Tools.Debug.Logger.info('系统配置文件载入错误刷新事件:', e)
  },
  /**
   * Page组件 切换Tabbar
   */
  handleSwitchTab: function (e) {
    console.log("接收到切换Tabbar:", e)
    const selectIndex = e.detail.selectIndex
    if (this.data.pageAttribute.tabbarIndex !== selectIndex) {
      this.setData({
        'pageAttribute.tabbarIndex': selectIndex,
      })
      this.handleTapBodyMark(e) // 关闭菜单和蒙版
      this._init() // 重置页面属性
    }
  },
  /**
   * 文章列表组件响应事件 开始载入数据
   */
  handleLoadingArticleBegin: function () {
    this.setData({
      'pageAttribute.showPageMark': true
    })
  },
  /**
   * 文章列表组件响应事件 结束载入数据
   */
  handleLoadingArticleOver: function () {
    this.pageComponent.handleScrollLower()
    this.setData({
      'pageAttribute.showPageMark': false
    })
  },
  /**
   * 文章列表组件事件[已内部处理]
   */
  handleTapArticleType: function (e) {

  },
  /**
   * 文章列表组件事件[已内部处理]
   */
  handleTapArticleItem: function (e) {

  },
  /**
   * 生活圈列表组件响应事件 点击Banner
   */
  handleTapLiveBanner: function (e) {

  },
  /**
   * 生活圈列表组件响应事件 点击列表项
   */
  handleTapLiveListItem: function (e) {

  },

  /**
   * 生活圈列表组件响应事件 开始载入数据
   */
  handleLoadingLiveBegin: function () {
    this.setData({
      'pageAttribute.showPageMark': true
    })
  },
  /**
   * 生活圈列表组件响应事件 结束载入数据
   */
  handleLoadingLiveOver: function () {
    this.pageComponent.handleScrollLower()
    this.setData({
      'pageAttribute.showPageMark': false
    })
  },
  /**
   * 获取<用户资料>
   */
  handleGotUserInfo: function (e) {
    console.group("获取用户资料:", e)
    console.log("获取消息:", e.detail.errMsg)
    console.log("userInfo", e.detail.userInfo)
    console.log("rawData", e.detail.rawData)

    app.setUserInfo(e.detail)
    this.setData({
      globalData: app.globalData,
    })
    console.groupEnd()
  },
  /**
   * 用户轻触内容蒙版层
   */
  handleTapBodyMark: function (e) {
    app.Tools.Debug.Logger.info("用户轻触内容蒙版层", e)

    this._hideSearchResult()
    this._closeLeftMenu()
    this._closeRightMenu()

    this.setData({
      'bodyData.showBodyMark': false, // 关闭内容蒙版层
    })
  },

  /**
   * 关闭左侧菜单 区域菜单
   */
  _closeLeftMenu: function () {
    this.setData({
      'bodyData.openLeftMenu': false
    })
  },
  /**
   * 关闭右侧菜单 类型菜单
   */
  _closeRightMenu: function () {
    this.setData({
      'bodyData.openRightMenu': false
    })
  },
  /*
   * 用户点击一个推荐卡
   */
  handleTapCardItem: function (e) {
    this._hideSearchResult()
    const id = e.currentTarget.dataset.id
    wx.navigateTo({
      url: '/pages/mylive/detail?id=' + id
    })
  },
  /**
   * 用户点击推荐卡位置 显示地图
   */
  handleTapShopMap: function (e) {
    const latitude = e.currentTarget.dataset.latitude
    const longitude = e.currentTarget.dataset.longitude
    const name = e.currentTarget.dataset.name
    const address = e.currentTarget.dataset.address
    if (latitude && latitude > 0) {
      app.Tools.API_wx.openLocation(latitude, longitude, name, address)
    }
  },
  /**
   * 载入搜索列表下一页
   */
  handleSearchNext: function () {
    if (!this.data.searchAttribute.overPage) {
      this.setData({
        'searchAttribute.page': this.data.searchAttribute.page + 1
      })
      this._searchData()
    }
  },
  /**
   * 用户点击推荐卡 搜索项
   */
  handleTapSearchItem: function (e) {
    const id = e.currentTarget.dataset.id
    const itemType = e.currentTarget.dataset.type
    if (id != '') {
      this._hideSearchResult()
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
    }
  },
  /**
   * 监听搜索框获得焦点
   */
  handleFocusSearch: function (e) {
    if (this.data.bodyData.openLeftMenu) {
      this.setData({
        'bodyData.openLeftMenu': false,
        'bodyData.showBodyMark': false
      })
    }
  },
  /**
   * 监听搜索框提交
   */
  handleConfirmSearch: function (e) {

  },
  /**
   * 监听搜索框文字改动
   */
  handleSearchInput: function (e) {
    const text = e.detail.value

    if (this.data.searchAttribute.timer) {
      clearTimeout(this.data.searchAttribute.timer)
    }
    if (text == '') {
      this.setData({
        'searchAttribute.result': [],
        'searchAttribute.showResult': false,
        'bodyData.showBodyMark': false,
      })
    } else {
      this.setData({
        'searchAttribute.result': [],
        'searchAttribute.searchText': text,
        'searchAttribute.page': 1,
        'searchAttribute.overPage': false,
      })
      this.data.searchAttribute.timer = setTimeout(this._searchData, 600)
    }
  },
  /**
   * 隐藏搜索结果
   */
  _hideSearchResult: function () {
    this.setData({
      'searchAttribute.showResult': false,
      'bodyData.showBodyMark': false,
    })
  },
  /**
   * 用户点击生活圈 区域菜单[打开左侧菜单]
   */
  handleTapAreaMenu: function (e) {
    this._hideSearchResult()
    if (this.data.bodyData.openLeftMenu) {
      this.handleTapBodyMark(e) // 关闭菜单和蒙版
    } else {
      this.setData({
        'bodyData.openLeftMenu': true, // 开启左侧菜单
        'bodyData.openRightMenu': false, // 关闭右侧菜单
        'bodyData.showBodyMark': true, // 开启内容蒙版层
      })
    }
  },
  /**
   * 用户点击生活圈 类型菜单[打开右侧菜单]
   */
  handleTapTypeMenu: function (e) {
    // console.log('打开右侧')
    if (this.data.bodyData.openRightMenu) {
      this.handleTapBodyMark(e) // 关闭菜单和蒙版
    } else {
      this.setData({
        'bodyData.openLeftMenu': false, // 关闭左侧菜单
        'bodyData.openRightMenu': true, // 关闭右侧菜单
        'bodyData.showBodyMark': true, // 开启内容蒙版层
      });
    }
  },
  /**
   * 用户点击区域菜单项 [左侧菜单]
   */
  handleTapBtnCity: function (e) {
    const city = e.currentTarget.dataset.city

    this.handleTapBodyMark(e) // 关闭菜单和蒙版
    if (this.data.bodyData.city != city) {
      wx.reLaunch({
        url: '/pages/index/home?city=' + city + '&tabbarIndex=' + this.data.pageAttribute.tabbarIndex
      })
    }
  },
  /**
   * 用户点击店铺类型项 [右侧菜单]
   */
  handleTapShopTypes: function (e) {
    //console.log('点击生活圈类型:', e)
    const type_name = e.currentTarget.dataset.name
    const type_order = e.currentTarget.dataset.order

    this.handleTapBodyMark(e) // 关闭菜单和蒙版
    if (this.data.liveAttribute.currentTypeIndex != type_order) {
      this.setData({
        'liveAttribute.currentTypeIndex': type_order,
      })
      this._init_Live({ type: type_name })
      /*
      wx.navigateTo({
        url: '/pages/mylive/list?type=' + type_name,
        success: (res) => {
          console.log("打开成功:", res)
        },
        fail: (res) => {
          console.log("打开失败:", res)
        }
      })
      */
    }
  },

  /**
   * 选择我的菜单项
   */
  handleTapAboutMenuItem: function (e) {
    const tapType = e.currentTarget.dataset.id
    const needLogin = !app.globalData.sysUserLogined || app.globalData.userInfo.server_uid == ''
    switch (tapType) {
      case 'wallet':
        if (needLogin) {
          app.showLoginReminding()
        } else {
          app.jumpPage('/pages/aboutme/wallet')
        }
        break;
      case 'redpacket':
        if (needLogin) {
          app.showLoginReminding()
        } else {
          app.jumpPage('/pages/aboutme/redpacket')
        }
        break;
      case 'favorite':
        if (needLogin) {
          app.showLoginReminding()
        } else {
          app.jumpPage('/pages/aboutme/favorite')
        }
        break;
      case 'purchaseHistory':
        if (needLogin) {
          app.showLoginReminding()
        } else {
          app.jumpPage('/pages/aboutme/purchaseHistory')
        }
        break;
      case 'signin':
        if (needLogin) {
          app.showLoginReminding()
        } else {
          app.jumpPage('/pages/aboutme/signin')
        }
        break;
      case 'activity':
        if (needLogin) {
          app.showLoginReminding()
        } else {
          app.jumpPage('/pages/browser')
        }
        break;
      case 'service':
        wx.showActionSheet({
          itemList: ['400-007-9939'],
          success: function (res) {
            wx.makePhoneCall({
              phoneNumber: '4000079939' //仅为示例，并非真实的电话号码
            })
          },
          fail: function (res) {
            console.log(res.errMsg)
          }
        })
        break;
      case 'help':
        /*
        wx.navigateTo({
          url: '/pages/aboutme/help'
        })
        */
        app.jumpPage("/pages/recommend/detail?id=" + app.globalData.helpID)
        break;
      default:

        break;
    }

  },
  /**
   * 
   */
  handleFirstUsedHome: function () {
    app.globalData.userInfo.taskTotal = 1
    app.taskFirstUsed()

  },
  handleFirstUsedLive: function () {
    app.globalData.userInfo.taskTotal = 3
    app.taskFirstUsed()
  },
  /**
   * 获取搜索结果
   */
  _searchData: function () {
    const post_data = {
      page: this.data.searchAttribute.page,
      pageSize: this.data.searchAttribute.total,
      searchBody: this.data.searchAttribute.searchText
    }
    const success_server = res => {
      app.Tools.Debug.Logger.info("查询成功:", res)
      const temp_datas = this.data.searchAttribute.result
      const old_length = temp_datas.length
      if (res.data){
        if (res.data.length == 0) {
          if (old_length == 0) {
            this.setData({
              'searchAttribute.result': temp_datas,
              'searchAttribute.showResult': false,
              'bodyData.showBodyMark': false,
            })
          }
          this.setData({
            'searchAttribute.overPage': true
          })
        } else {
          res.data.forEach((item, index, array) => {
            temp_datas.push({
              id: item.pubId || '',
              name: item.pubName || '',
              intro: item.pubIntro || '',
              type: item.url || ''
            })
          })
          this.setData({
            'searchAttribute.result': temp_datas,
            'searchAttribute.showResult': true,
            'bodyData.showBodyMark': true,
          })
        }

      }

    }
    const fail_server = errorMessage => {
      app.Tools.Debug.Logger.info("查询失败:", errorMessage)
      app.showLoadDataError({
        title: '数据获取失败',
        content: '查询数据失败:' + errorMessage,
        retry: () => {
          this._getData()
        }
      })
    }
    app.Tools.API_server.search(post_data, success_server, fail_server)
  },

  /**
   * 获取页面数据
   */
  _getData_Home: function () {
    const post_data = {
      page: this.data.cardAttribute.page, // 当前页数,
      pageSize: this.data.cardAttribute.pageSize, // 每页显示数量
      longitude: this.data.globalData.userInfo.coordinate.longitude,
      latitude: this.data.globalData.userInfo.coordinate.latitude,
      cityName: this.data.bodyData.city, // 当前城市名
    }
    const success_server = (res) => {
      // app.Tools.Debug.Logger.info("推荐卡 数据载入成功:", res)
      if (res.data) {
        const temp_datas = this.data.cardAttribute.dataList
        const old_length = temp_datas.length

        if (res.data.length == 0) {
          if (old_length == 0) {
            this.setData({
              'bodyData.NotFoundDatas': '--没有数据--',
              'pageAttribute.loadMoreData': false,
            })
          }
          this.setData({
            'cardAttribute.overPageData': true
          })
        } else {
          for (let index in res.data) {
            const new_item = {
              id: res.data[index].pubId || '', // 店铺编号
              name: res.data[index].pubName || '', // 店铺名称
              avatar: res.data[index].headPortrait || '', // 店招
              background: res.data[index].headBackground || '', // 背景
              title: res.data[index].title || '', // 介绍标题
              desc: res.data[index].pubIntro || '', // 介绍原因
              pics: res.data[index].showPic || [], // 详细图片
              distance: res.data[index].showDistance || '',   // 距离提示
              latitude: res.data[index].latitude || '',   // 纬度
              longitude: res.data[index].longitude || '',   // 经度
              address: res.data[index].addr || '',   // 地址
              type: res.data[index].url || '',
              order: old_length + parseInt(index) //  选项卡序号
            }
            temp_datas.unshift(new_item)
          }
          // 设置数据
          this.setData({
            'cardAttribute.dataList': temp_datas,
            'bodyData.NotFoundDatas': '',
          })
          if (old_length == 0) {
            this.setData({
              'cardAttribute.distance.title': temp_datas[temp_datas.length - 1].distance,
              'cardAttribute.distance.latitude': temp_datas[temp_datas.length - 1].latitude,
              'cardAttribute.distance.longitude': temp_datas[temp_datas.length - 1].longitude,
              'cardAttribute.distance.name': temp_datas[temp_datas.length - 1].name,
              'cardAttribute.distance.address': temp_datas[temp_datas.length - 1].address
            })
            console.log("初始化地理位置信息", this.data.cardAttribute.distance.name)
          }
        }
      }
    }
    const fail_server = (errorMessage) => {
      // app.Tools.Debug.Logger.info("推荐卡 数据载入失败:", errorMessage)
      app.showLoadDataError({
        title: '数据获取失败',
        content: '新店推荐数据载入失败:' + errorMessage,
        retry: () => {
          this._getData_Home()
        }
      })
    }
    app.Tools.API_server.getHomeCardInfo(post_data, success_server, fail_server)
  }
})