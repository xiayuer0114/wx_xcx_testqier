// components/demo.js
Component({
  options: {
    multipleSlots: true // 在组件定义时的选项中启用多slot支持
  },
  behaviors: [],
  /**
   * 组件的初始数据 组件的内部数据，和properties一同用于组件的模版渲染
   * 私有数据，可用于模版渲染
   */
  data: {

  },
  /**
   * 组件的属性列表  组件的对外属性，是属性名到属性设置的映射表
   * 属性设置中可包含三个字段
   * type 表示属性类型
   * value 表示属性初始值
   * observer 表示属性值被更改时的响应函数
   */
  properties: {
    myProperty: { // 属性名
      type: String, // 类型（必填），目前接受的类型包括：String, Number, Boolean, Object, Array, null（表示任意类型）
      value: '', // 属性初始值（可选），如果未指定则会根据类型选择一个
      observer: function (newVal, oldVal, changedPath) {
        // 属性被改变时执行的函数（可选），也可以写成在methods段中定义的方法名字符串, 如：'_propertyChange'
        // 通常 newVal 就是新设置的数据， oldVal 是旧数据
      }
    },
    myProperty2: String // 简化的定义方式
  },


  /**
   * 组件的方法列表 组件的方法，包括事件响应函数和任意的自定义方法，关于事件响应函数的使用
   */
  methods: {
    onMyButtonTap: function () {
      this.setData({
        // 更新属性和数据的方法与更新页面数据的方法类似
      })
    },
    // 内部方法建议以下划线开头
    _myPrivateMethod: function () {
      // 这里将 data.A[0].B 设为 'myPrivateData'
      this.setData({
        'A[0].B': 'myPrivateData'
      })
    },
    _propertyChange: function (newVal, oldVal) {

    }
  },

  // 生命周期函数，可以为函数，或一个在methods段中定义的方法名
  attached: function () { },
  moved: function () { },
  detached: function () { },


})
