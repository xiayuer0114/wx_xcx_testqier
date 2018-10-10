const util = require("../utils/util.js")
// components/page.js
Component({
  options: {
    multipleSlots: true // 在组件定义时的选项中启用多slot支持
  },
  /**
   * 组件的属性列表
   */
  properties: {
    scrollY: { // 是否允许垂直滚动
      type: Boolean,
      value: true,
      observer: function(newValue, oldValue, changedPath){
        //console.log("改变滚动条属性:", newValue, oldValue, changedPath)
      }
    },
    showTopMenu: {
      type: Boolean,
      value: true,
      observer: function (newValue, oldValue, changedPath) {
        //console.log("改变顶部导航属性:", newValue, oldValue, changedPath)
      }
    },
    showTabbar: {
      type: Boolean,
      value: true,
      observer: function (newValue, oldValue, changedPath) {
        //console.log("改变底部导航属性:", newValue, oldValue, changedPath)
      }
    },
    handleScrollUpper: { // 是否监听顶部刷新
      type: Boolean,
      value: true,
      observer: function (newValue, oldValue, changedPath) {
        //console.log("改变监听顶部属性:", newValue, oldValue, changedPath)
        this.setData({
          handleUpper: newValue
        })
      }
    },
    handleScrollLower: { // 是否监听底部加载
      type: Boolean,
      value: true,
      observer: function (newValue, oldValue, changedPath) {
        //console.log("改变监听底部属性:", newValue, oldValue, changedPath)
        this.setData({
          handleLower: newValue
        })
      }
    },
    tabbarSelectIndex: {
      type: Number,
      value: 0,
      observer: function (newValue, oldValue, changedPath) {
        //console.log("改变Tabbar选中属性:", newValue, oldValue, changedPath)
        this.setData({
          'tabbar.selectIndex': newValue
        })
      }
    },
    showError: {
      type: Boolean,
      value: false,
      observer: (newVal, oldVal, changedPath) => { // 值被更改时的响应函数

      }
    },
    showMessage: {
      type: String,
      value: '未知的服务器错误'
    },
    showLoading: {
      type: Boolean,
      value: false,
      observer: (newVal, oldVal, changedPath) => { // 值被更改时的响应函数

      }
    },
    backUrl: {
      type: String,
      value: '/pages/index/home'
    }
  },

  /**
   * 组件的初始数据
   */
  data: {
    debug: false,
    handleUpper: true, // 是否监听顶部刷新
    handleLower: true, // 是否监听底部加载
    systemInfo: {
      brand: '', //	手机品牌	1.5.0
      model: '', //	手机型号
      pixelRatio: '', //	设备像素比
      screenWidth: '', //	屏幕宽度	1.1.0
      screenHeight: '', //	屏幕高度	1.1.0
      windowWidth: '', //	可使用窗口宽度
      windowHeight: '', //	可使用窗口高度
      statusBarHeight: '', //	状态栏的高度	1.9.0
      language: '', //	微信设置的语言
      version: '', //	微信版本号
      system: '', //	操作系统版本
      platform: '', //	客户端平台
      fontSizeSetting: '', //	用户字体大小设置。以“我-设置-通用-字体大小”中的设置为准，单位：px	1.5.0
      SDKVersion: '', //	客户端基础库版本
    },
    tabbar: {
      showIcon: true,
      showTitle: false,
      selectIndex: 0,
      data: [{
          id: 1,
          index: 0,
          title: '推荐卡',
          icon: '/resources/1.png',
          selectIcon: '/resources/1_1.png',
          url: '/pages/index/index'
        }, {
            id: 2,
            index: 1,
            title: '生活圈',
            icon: '/resources/2.png',
            selectIcon: '/resources/2_1.png',
            url: '/pages/mylive/index'
        }, {
            id: 3,
            index: 2,
            title: '专题',
            icon: '/resources/3.png',
            selectIcon: '/resources/3_1.png',
            url: '/pages/recommend/index'
        }, {
            id: 4,
            index: 3,
            title: '我的',
            icon: '/resources/4.png',
            selectIcon: '/resources/4_1.png',
            url: '/pages/aboutme/index'
        }]
    }
  },
  /**
   * 组件生命周期函数 -在组件实例进入页面节点树时执行，注意此时不能调用setData
   */
  created: function () {
    console.log("组件created:", this.properties.tabbarSelectIndex, this.data.tabbar.selectIndex)
  },
  /**
   * 组件生命周期函数 -在组件实例进入页面节点树时执行
   */
  attached: function () {
    console.log("组件attached:", this.properties.tabbarSelectIndex, this.data.tabbar.selectIndex)
  },
  /**
   * 组件生命周期函数 -在组件布局完成后执行，此时可以获取节点信息
   */
  ready: function () {
    console.log("组件ready:", this.properties.tabbarSelectIndex, this.data.tabbar.selectIndex)
    this._getSystemInfo()
  },
  /**
   * 组件生命周期函数 -在组件实例被移动到节点树另一个位置时执行
   */
  moved: function () {

  },
  /**
   * 组件生命周期函数 -在组件实例被从页面节点树移除时执行
   */
  detached: function () {

  },
  /**
   * 组件的方法列表
   */
  methods: {
    handleScrollUpper: function () {
      this.setData({
        'handleUpper': true
      })
    },
    handleScrollLower: function () {
      this.setData({
        'handleLower': true
      })
    },
    _handleScrollUpper: function (e) {
      if (this.data.handleUpper) {
        this.setData({
          'handleUpper': false
        })
        const eventDetail = {} // detail对象，提供给事件监听函数
        const eventOption = {} // 触发事件的选项
        this.triggerEvent('refresh', eventDetail, eventOption)
      }
    },
    _handleScrollLower: function (e) {
      if (this.data.handleLower) {
        this.setData({
          'handleLower': false
        })
        const eventDetail = {} // detail对象，提供给事件监听函数
        const eventOption = {} // 触发事件的选项
        this.triggerEvent('nextpage', eventDetail, eventOption)
      }
    },
    _handleScroll: function (e) {
        const eventDetail = {
          event: e
        } // detail对象，提供给事件监听函数
        const eventOption = {} // 触发事件的选项
      this.triggerEvent('scroll', eventDetail, eventOption)

    },
    _handleRefreshPage: function () {
      const onRefreshDetail = {  // detail对象，提供给事件监听函数
        fun: "其他信息"
      }
      const onRefreshOption = { // 触发事件的选项
        bubbles: true, // 事件是否冒泡
        composed: true, // 事件是否可以穿越组件边界，为false时，事件将只能在引用组件的节点树上触发，不进入其他任何组件内部
        capturePhase: false, // 是否拥有捕获阶段
      }
      this.triggerEvent('errorback', onRefreshDetail, onRefreshOption)

      if (this.properties.backUrl) {
        wx.reLaunch({
          url: this.properties.backUrl
        })
      }
    },
    /**
     * Tabbar点击事件
     */
    _handleTapTabbarItem: function (e) {
      const id = e.currentTarget.dataset.id
      const index = e.currentTarget.dataset.index
      console.log("Tabbar点击事件：", e, index, this.data.tabbar.selectIndex)
      if (index !== this.data.tabbar.selectIndex) {
        const onRefreshDetail = {  // detail对象，提供给事件监听函数
          selectId: id,
          selectIndex: index,
        }
        const onRefreshOption = { // 触发事件的选项
          bubbles: false, // 事件是否冒泡
          composed: false, // 事件是否可以穿越组件边界，为false时，事件将只能在引用组件的节点树上触发，不进入其他任何组件内部
          capturePhase: false, // 是否拥有捕获阶段
        }
        this.triggerEvent('switchtab', onRefreshDetail, onRefreshOption)

        this.setData({
          'tabbar.selectIndex': index
        })
        /* // 屏蔽跳转
        wx.reLaunch({
          url: this.data.tabbar.data[index].url,
          success: (res) => {
            console.log('Tabbar switchTab成功：', res)
          },
          fail: (res) => {
            console.log('Tabbar switchTab失败：', res)
          }
        })
        */
      }
    },
    /**
     * 获取系统属性
     */
    _getSystemInfo: function(){
      wx.getSystemInfo({
        success: (res) => {
          const temp_system_info = {}
          temp_system_info.SDKVersion = res.SDKVersion // 客户端基础库版本
          if (util.compareVersion(res.SDKVersion, '1.5.0') >= 0) {
            temp_system_info.brand = res.brand // 手机品牌  1.5.0
          }
          temp_system_info.model = res.model // 手机型号
          temp_system_info.pixelRatio = res.pixelRatio // 设备像素比
          if (util.compareVersion(res.SDKVersion, '1.1.0') >= 0) {
            temp_system_info.screenWidth = res.screenWidth // 屏幕宽度  1.1.0
            temp_system_info.screenHeight = res.screenHeight // 屏幕高度  1.1.0
          }
          temp_system_info.windowWidth = res.windowWidth // 可使用窗口宽度
          temp_system_info.windowHeight = res.windowHeight // 可使用窗口高度
          if (util.compareVersion(res.SDKVersion, '1.9.0') >= 0) {
            temp_system_info.statusBarHeight = res.statusBarHeight // 状态栏的高度  1.9.0
          }
          temp_system_info.language = res.language // 微信设置的语言
          temp_system_info.version = res.version // 微信版本号
          temp_system_info.system = res.system // 操作系统版本
          temp_system_info.platform = res.platform // 客户端平台
          temp_system_info.fontSizeSetting = res.fontSizeSetting // 用户字体大小设置。以“我-设置-通用-字体大小”中的设置为准，单位：px  1.5.0
          this.setData({
            systemInfo: temp_system_info
          })
        }
      })
    }
  }
})
