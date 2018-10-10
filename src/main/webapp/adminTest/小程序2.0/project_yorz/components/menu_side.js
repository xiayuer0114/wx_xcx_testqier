// components/menu_side.js
Component({
  externalClasses: ['menu_class'],
  /**
   * 组件的初始数据
   */
  data: {
    paramA:'defaultValue',
    paramB:'defaultValue'
  },
  /**
   * 组件的属性列表
   */
  properties: {
    paramA: Number,
    paramB: String,
  },


  /**
   * 组件的方法列表
   */
  methods: {
    onLoad: function () {
      this.data.paramA // 页面参数 paramA 的值
      this.data.paramB // 页面参数 paramA 的值
    }
  }
})
