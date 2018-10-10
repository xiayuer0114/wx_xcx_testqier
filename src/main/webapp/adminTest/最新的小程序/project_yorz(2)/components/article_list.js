
// components/article_list.js
Component({
  /**
   * 组件的属性列表
   */
  properties: {
    articleId: String,
    articleName: String,
  },

  /**
   * 组件的初始数据
   */
  data: {
    NotFoundData: '',
    app: null,
    isHomeList: true,
    pageSize: 5, // 每页数量
    currentAttribute: {
      page: 1, // 当前页面
      overPage: false, // 是否已经载入完
    },
    dataList: []
  },

  /**
   * 组件的方法列表
   */
  methods: {
    /**
     * 载入数据
     */
    init: function(app){

      this.setData({
        app: app
      })
      if (!this.properties.articleName) {
        this.setData({
          isHomeList: true
        })
        this.properties.articleName =  '专题'
      } else {
        this.setData({
          isHomeList: false
        })
      }
      wx.setNavigationBarTitle({ title: this.properties.articleName }) // 动态设置当前页面的标题
      this._getList()
    },
    /**
     * 下一页数据
     */
    nextPage: function() {
      if (!this.data.currentAttribute.overPage) {
        this.setData({
          'currentAttribute.page': this.data.currentAttribute.page + 1
        })

        this._getList()
        return true
      } else {
        return false // 已加载完所有数据
      }
    },
    /**
     * 刷新数据
     */
    refresh: function() {

    },
    /**
     * 转发信息
     */
    shareInfo: function() {
      return {
        title: '',
        path: '',
        imageUrl: ''
      }
    },
    _handleTapType: function (e) {
      const typeid = e.currentTarget.dataset.typeid
      const typename = e.currentTarget.dataset.typename
      const eventDetail = {
        id: typeid,
        name: typename
      } // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      this.triggerEvent('taptype', eventDetail, eventOption)

      if (this.data.isHomeList) {
        this.properties.app.jumpPage('/pages/recommend/list?id=' + typeid + '&name=' + typename)
      }

    },
    _handleTapItem: function (e) {
      const id = e.currentTarget.dataset.id
      const typeid = e.currentTarget.dataset.typeid
      const typename = e.currentTarget.dataset.typename

      const eventDetail = {
        id: id
      } // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      this.triggerEvent('tapitem', eventDetail, eventOption)

      if (this.data.isHomeList) {
        this.properties.app.jumpPage('/pages/recommend/list?id=' + typeid + '&name=' + typename)
      } else {
        this.data.app.jumpPage('/pages/recommend/detail?id=' + id)
      }
    },
    _getList: function () {
      const eventDetail = {} // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      
      const post_data = {
        page: this.data.currentAttribute.page, // 当前页数
        pageSize: this.data.pageSize, // 每页显示数量
        zhuanTiName: this.properties.articleName == '专题' ? '' : this.properties.articleName,
        //zhuanTiId: this.properties.articleId, // 2018-8-23 去掉id
      }
      const success_server = (resData) => {
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
          }
          resData.data.forEach((item, index, array) => {
            temp_list.push({
              id: item.pubId || '', // 文章编号
              index: old_length + index, // 序号
              title: item.pubName || '', // 文章名
              photo: item.headBackground, // 图片
              typeId: item.zhuanTiId, // 专题ID
              typeName: item.zhuanTiName, // 专题名
              type: item.url // 类型[呈现页面]
            })
          })
          this.setData({
            'dataList': temp_list,
            'NotFoundData': '',
          })
        }
      }
      const fail_server = (errorMessage) => {
        console.log("获取专题列表错误", errorMessage)

        this.properties.app.showLoadDataError({
          title: '数据获取失败',
          content: '专题列表载入失败:' + errorMessage,
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
      this.data.app.Tools.API_server.getRecommend(post_data, success_server, fail_server, complete_server)
    }
  }
})
