// components/server_loading.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    app: Object,
    showError: {
      type: Boolean,
      value: true,
      observer: (newVal, oldVal, changedPath) => { // 值被更改时的响应函数

      }
    },
    showLoading: {
      type: Boolean,
      value: true,
      observer: (newVal, oldVal, changedPath) => { // 值被更改时的响应函数

      }
    },
    url: {
      type: String,
      value: '/pages/index/index'
    },
    message: {
      type: String,
      value: '未知的服务器错误'
    }
  },

  /**
   * 组件的初始数据
   */
  data: {

  },
  /**
   * 组件生命周期函数 -在组件实例进入页面节点树时执行，注意此时不能调用setData
   */
  created: function () { },

  /**
   * 组件生命周期函数 -在组件布局完成后执行，此时可以获取节点信息
   */
  ready: function () { 
    
  },
  /**
   * 组件生命周期函数 -在组件实例进入页面节点树时执行
   */
  attached: function () { },
  /**
   * 组件生命周期函数 -在组件实例被移动到节点树另一个位置时执行
   */
  moved: function () { },
  /**
   * 组件生命周期函数 -在组件实例被从页面节点树移除时执行
   */
  detached: function () { },
  /**
   * 组件的方法列表
   */
  methods: {
    onRefresh: function() {
      const onRefreshDetail = {  // detail对象，提供给事件监听函数
        fun: "其他信息"
      }
      const onRefreshOption = { // 触发事件的选项
        bubbles: true, // 事件是否冒泡
        composed: true, // 事件是否可以穿越组件边界，为false时，事件将只能在引用组件的节点树上触发，不进入其他任何组件内部
        capturePhase: false, // 是否拥有捕获阶段
      }
      this.triggerEvent('refresh', onRefreshDetail, onRefreshOption)

      if (this.properties.url) {
        wx.reLaunch({
          url: this.properties.url
        })
      }
    },
  }
})
