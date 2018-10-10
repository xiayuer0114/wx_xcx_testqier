// components/my_live.js
Component({
  options: {
    multipleSlots: true // 在组件定义时的选项中启用多slot支持
  },
  /**
   * 组件的属性列表
   */
  properties: {
    area: {
      type: String,
      value: '',
      observer: function (newValue, oldValue, changePath) {
        //console.log("改变区域属性:", newValue, oldValue, changePath)
        if (this.data.app != null) {
          this._initArea()
        }
      }
    },
    types: {
      type: String,
      value: '',
      observer: function(newValue, oldValue, changePath){
        //console.log("改变类型属性:", newValue, oldValue, changePath)
        if(this.data.app != null){
          if (newValue == '商圈') {
            this._initTrade()
          } else {
            this._initType()
          }
        }
      }
    },
    banner: { // 是否允许显示Banner
      type: Boolean,
      value: false,
      observer: function (newValue, oldValue, changedPath) {
        //console.log("改变显示Banner属性:", newValue, oldValue, changedPath)
      }
    },
  },

  /**
   * 组件的初始数据
   */
  data: {
    app: null,
    NotFoundData: '',

    showBanner: true,
    banner: {
      id: '', // 文章编号
      pic: '', // banner图片
      type: '', // 跳转地址,应该跳转到某个分类下
    },

    pageSize: 5, // 每页数量
    currentAttribute: {
      page: 1, // 当前页面
      overPage: false, // 是否已经载入完
      city: '', // 当前城市
      area: '', // 当前区域
      type: '', // 当前类型
      showArea: true, // 是否限定区域  true: 商圈列表 false: 商圈[区域]店铺
      showType: false, // 是否限定类型 true: 限制类型 false: 不限制类型
    },

    dataList: [
      /*
        {
          id: '5b2ce6c17d170b7713b72b86',
          url: '',
          image: 'mylive_list1.png',
          title: "这家法餐厅，早已是重庆网红地",  // 文章标题
          address: "3K 解放碑",
          people: '888',
          message: '消费YORZ红包'
        }, {
          id: '5b529c805ff47d16b06a3eaf',
          url: '',
          image: 'mylive_list2.png',
          title: "这家法餐厅，早已是重庆网红地",  // 文章标题
          address: "5868.9km 鎏嘉码头", // 需根据坐标获取路程
          people: '888',
          message: '消费YORZ红包'
        }
      */
    ]
  },

  /**
   * 组件的方法列表
   */
  methods: {
    _handleTapListItem: function (e) {
      // console.log('点击生活圈列表:', e)
      const id = e.currentTarget.dataset.id
      const area = e.currentTarget.dataset.area
      const eventDetail = {
        id: id,
        area: area
      } // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      this.triggerEvent('tapItem', eventDetail, eventOption)

      if (this.data.currentAttribute.showArea && this.data.currentAttribute.area == '商圈') {
        wx.navigateTo({
          url: '/pages/mylive/list?area=' + area,
          success: (res) => {
            this.data.app.Tools.Debug.Logger.info("区域列表跳转成功:", res)
          },
          fail: (res) => {
            this.data.app.Tools.Debug.Logger.info("区域列表跳转失败:", res)
          }
        })
      } else {
        wx.navigateTo({
          url: '/pages/mylive/detail?id=' + id,
          success: (res) => {
            this.data.app.Tools.Debug.Logger.info("店铺详情跳转成功:", res)
          },
          fail: (res) => {
            this.data.app.Tools.Debug.Logger.info("店铺详情跳转失败:", res)
          }
        })
      }
    },
    /**
     * 点击banner
     */
    _handleTapBanner: function (e) {
      const id = e.currentTarget.dataset.id
      const itemType = e.currentTarget.dataset.type

      const eventDetail = {
        id: id,
        type: itemType
      } // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      this.triggerEvent('tapBanner', eventDetail, eventOption)

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
     * 初始化组件数据
     */
    init: function(app){
      this.setData({
        app: app,
      })
      if(this.properties.area != ''){
        this._initArea() // 显示地区店铺
      } else if (this.properties.types != '' && this.properties.types != '商圈') {
        this._initType() // 显示类型
      } else {
        this._initTrade()  // 显示商圈
      }
    },
    /**
     * 下一页数据
     */
    nextPage: function (callback) {
      if (!this.data.currentAttribute.overPage) {
        this.setData({
          'currentAttribute.page': this.data.currentAttribute.page + 1
        })

        this._getList(callback)
        return true
      } else {
        return false // 已加载完所有数据
      }
    },
    /**
     * 刷新数据
     */
    refresh: function () {

    },
    /**
     * 转发信息
     */
    shareInfo: function () {
      return {
        title: '',
        path: '',
        imageUrl: ''
      }
    },
    /**
     * 初始化商圈
     */
    _initTrade: function () {
      this.setData({
        'currentAttribute.area': '商圈',
        'currentAttribute.showArea': true,
        'currentAttribute.type': '',
        'currentAttribute.showType': false,
        'showBanner': true,
        'currentAttribute.city': this.data.app.globalData.currentCity,
        'currentAttribute.page': 1,
        'currentAttribute.overPage': false,
        dataList: [],
      })
      wx.setNavigationBarTitle({ title: '商圈' }) // 动态设置当前页面的标题
      this._getList()
    },
    /**
     * 初始化区域
     */
    _initArea: function() {
      this.setData({
        'currentAttribute.area': this.properties.area,
        'currentAttribute.showArea': true,
        'currentAttribute.type': '',
        'currentAttribute.showType': false,
        'showBanner': false,
        'currentAttribute.city': this.data.app.globalData.currentCity,
        'currentAttribute.page': 1,
        'currentAttribute.overPage': false,
        dataList: [],
      })
      wx.setNavigationBarTitle({ title: this.properties.area }) // 动态设置当前页面的标题
      this._getList()
    },
    /**
     * 初始化店铺类型
     */
    _initType: function() {
      this.setData({
        'currentAttribute.area': '',
        'currentAttribute.showArea': false,
        'currentAttribute.type': this.properties.types,
        'currentAttribute.showType': true,
        'showBanner': true,
        'currentAttribute.city': this.data.app.globalData.currentCity,
        'currentAttribute.page': 1,
        'currentAttribute.overPage': false,
        dataList: [],
      })
      wx.setNavigationBarTitle({ title: this.properties.types }) // 动态设置当前页面的标题
      this._getList()
    },
    /**
     * 获取数据
     */
    _getList: function (callback = () => { }) {
      /**
       * 组件事件发送属性设置
       */
      const eventDetail = {} // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项

      /**
       * 根据类型获取不同的接口
       */
      const post_data = {
        cityName: this.data.currentAttribute.city, // 当前城市名
        page: this.data.currentAttribute.page, // 当前页数
        pageSize: this.data.pageSize, // 每页显示数量
        longitude: this.data.app.globalData.userInfo.coordinate.longitude,
        latitude: this.data.app.globalData.userInfo.coordinate.latitude
      }
      const success_server = (resData) => {
        this.data.app.Tools.Debug.Logger.info("生活圈 获取列表数据成功:", resData)
        if (resData.data) {
          let temp_list = this.data.dataList
          const old_length = temp_list.length
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
              const new_live_item = {
                id: item.id || '',
                index: old_length + index,
                url: item.url || '',
                image: item.headBackground || 'default',
                area: item.shangQuanName || '',
                title: item.title_one || '',
                address: item.title_two || '',
                people: item.renShu || 0,
                message: '消费YORZ红包'
              }
              temp_list.push(new_live_item)
            })
            this.setData({
              dataList: temp_list,
              'NotFoundData': '',
            })
          }
        }
      }
      const fail_server = (errorMessage) => {
        this.data.app.Tools.Debug.Logger.info("获取生活圈列表错误:", errorMessage)
        app.showLoadDataError({
          title: '数据获取失败',
          content: '生活圈数据载入失败:' + errorMessage,
          retry: () => {
            this._getList()
          }
        })
      }
      const complete_server = () => {
        this.triggerEvent('loadOver', eventDetail, eventOption)
        wx.hideLoading()
      }

      this.triggerEvent('loadBegin', eventDetail, eventOption)
      wx.showLoading({
        title: "",  // 数据加载中
        mask: true
      })
      console.log("当前属性", this.data.currentAttribute)
      if (this.data.currentAttribute.showType) {
        // 3.附近分类
        post_data.labelName = this.data.currentAttribute.type
        if (this.properties.banner) {
          this._getAD(this.data.currentAttribute.type)
        }
        this.data.app.Tools.API_server.getMyliveShop(post_data, success_server, fail_server, complete_server)
      } else if (this.data.currentAttribute.showArea) {
        if (this.data.currentAttribute.area == '商圈') {
          // 1.获取商圈
          this._getAD(this.data.currentAttribute.area)
          this.data.app.Tools.API_server.getMyliveArea(post_data, success_server, fail_server, complete_server)
        } else {
          // 2.商圈店铺
          post_data.shangQuanName = this.data.currentAttribute.area
          this.data.app.Tools.API_server.getMyliveAreaShop(post_data, success_server, fail_server, complete_server)
        }
      }
    },
    /**
     * 获取生活圈的广告图
     */
    _getAD: function (labelName) {
      const post_data = { 
        labelName: labelName,
        cityName: this.data.currentAttribute.city // 当前城市名
      }
      const success_server = (resData) => {
        this.data.app.Tools.Debug.Logger.info("载入生活圈banner数据成功:", resData.data)
        this.setData({
          'banner.id': resData.data.id,
          'banner.pic': resData.data.pic,
          'banner.type': resData.data.url,
        })
      }
      const fail_server = (res) => {
        this.data.app.Tools.Debug.Logger.info("载入生活圈banner数据错误", res)
      }
      this.data.app.Tools.API_server.getMyliveBanner(post_data, success_server, fail_server)
    },
  }
})
