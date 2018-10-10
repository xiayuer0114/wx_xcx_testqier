// components/slide_list.js
let HandleScrollAnimation = function (setAnimationBack, margin = 0) {
  let timmer = null // 滚动条更新
  let itemHeight = 0 // 每项元素高度
  let scrollTop = 0 // 滚动条位置
  let scrollPre = 0  // 上次移动记录值
  let scrollDown = undefined // 是否向下移动
  let dataLength = 0 // 数据长度
  let itemMargin = 0 // 元素间距
  let showItem = 0 // 当前显示的元素

  this.datas = [] // 数据
  this.animationData = {} // 动画

  if (margin && margin > 0) {
    itemMargin = margin
  }
  this.init = function (datas) {
    this.datas.splice(0, this.datas.length) // 清空数组
    this.addDatas(datas)
  }
  /**
   * 添加数据
   */
  this.addDatas = function (datas) {
    let temp_obj_animation = this.animationData
    let temp_datas = this.datas
    let length = temp_datas.length
    if (length > 0) {
      length += 1
    }
    datas.forEach((item, index, array) => {
      const animation = wx.createAnimation({
        duration: 300,
        timingFunction: 'ease',
        delay: 0
      })
      if (index + length == 0) {
        animation.scale(1, 1).step()
      } else {
        animation.scale(0.8, 0.8).step()
      }
      temp_obj_animation[index] = animation.export()
      temp_datas.push({
        index: index + length, // 序号
        id: item.pubId || '_' + index, // 文章编号,
        title: item.pubName || '', // 文章名
        photo: item.headBackground, // 图片
        typeId: item.zhuanTiId, // 专题ID
        typeName: item.zhuanTiName, // 专题名
        type: item.url, // 类型[呈现页面]
        order: index + length,
        desc: 0.0
      })
    })
    dataLength = temp_datas.length
    this.datas = temp_datas
    this.animationData = temp_obj_animation
    return {
      datas: this.datas,
      animation: this.animationData
    }
  }
  this.update = function (currentScrollValue, totalScrollValue) {
    scrollTop = currentScrollValue
    if (scrollTop > scrollPre + 5) {
      scrollDown = true
    } else if (scrollTop < scrollPre + 5) {
      scrollDown = false
    } else {
      scrollDown = undefined
    }
    // this.data.itemHeight + this.data.itemMargin
    itemHeight = (totalScrollValue - itemMargin) / dataLength


    if (timmer) {
      clearTimeout(timmer)
    }
    if (Math.abs(scrollTop - scrollPre) > 50) {
      if (scrollDown !== undefined) {
        console.group("越界执行", scrollTop, scrollPre)
        this._update()
        console.groupEnd()
      }
    } else {
      timmer = setTimeout(() => {
        if (scrollDown !== undefined) {
          console.group("超时执行")
          this._update()
          console.groupEnd()
        }
      }, 100)
    }

  }
  this._update = function () {
    const currentItem = parseInt(scrollTop / itemHeight)
    const currentScroll = scrollTop % itemHeight

    const currentScrollMin = parseInt(itemHeight * 0.25)
    const currentScrollMiddle = parseInt(itemHeight * 0.75)
    const currentScrollMax = parseInt(itemHeight * 0.9)
    let showID = null

    console.log("   操作项:", currentItem + '=' + scrollTop + '/' + itemHeight)
    console.log("   操作值:", currentScroll, currentScrollMin + '<' + currentScrollMiddle + '<' + currentScrollMax)

    if (currentScroll < currentScrollMin) { // 放大下一个
      const scaleMin = parseInt(currentScroll / currentScrollMin * 100)     // 1. 计算比例
      console.log("    放大下一个比例", scaleMin + '=' + currentScroll + '/' + currentScrollMin + '*100')

      const scale = parseInt(scaleMin / 100 * 20 + 80) / 100
      this._createAnimation(currentItem, scale)

      scrollPre = scrollTop
    } else if (currentScrollMiddle < currentScroll && currentScroll < currentScrollMax) {
      // 计算比例
      // 1. 最大比例
      // const scaleMax = parseInt((itemHeight - currentScrollMax - currentScroll) / (itemHeight - currentScrollMax) * 100)
      // 2. 中间比例
      const scaleMax = parseInt((currentScrollMax - currentScroll) / (currentScrollMax - currentScrollMiddle) * 100)
      console.log("    缩小下一个比例", scaleMax + '=' + currentScroll + '/' + currentScrollMax + '*100')

      const scale = parseInt(20 - (scaleMax / 100 * 20) + 80) / 100
      this._createAnimation(currentItem, scale)
      scrollPre = scrollTop
    } else {
      if (scrollDown === true && currentScroll > currentScrollMin && showItem !== currentItem + 1) {
        console.log("    直接到:", this.datas[currentItem + 1].id)
        this._createAnimation(currentItem, 1)
        showID = this.datas[currentItem + 1].id
        showItem = currentItem + 1
        scrollPre = scrollTop
      } else if (scrollDown === false && currentScroll < currentScrollMiddle && showItem !== currentItem){
        console.log("    直接到:", this.datas[currentItem].id)
        this._createAnimation(currentItem, 1)
        showID = this.datas[currentItem].id
        showItem = currentItem
        scrollPre = scrollTop
      }
    }

    // scrollDown = undefined
    setAnimationBack(this.animationData, this.datas, showID)
  }
  this._createAnimation = function (currentItemIndex, scale) {
    const temp_data_list = this.datas
    const temp_obj_animation = this.animationData
    // 前面的
    const pre_animation = wx.createAnimation({
      duration: 50,
      timingFunction: 'ease',
    })
    pre_animation.scale(1, 1).step()

    // 下一个
    const next_animation = wx.createAnimation({
      duration: 50,
      timingFunction: 'ease',
    })
    next_animation.scale(scale, scale).step()

    // 其他的
    const end_animation = wx.createAnimation({
      duration: 50,
      timingFunction: 'ease',
    })
    end_animation.scale(0.8, 0.8).step()

    temp_data_list.forEach((item, index, array) => {
      if (index <= currentItemIndex) {
        temp_obj_animation[index] = pre_animation.export()
        item.desc = 1
      } else if (index == currentItemIndex + 1) {
        if (scale >= 1) {
          temp_obj_animation[index] = pre_animation.export()
        } else {
          temp_obj_animation[index] = next_animation.export()
        }
        item.desc = currentItemIndex + '--' + scale
      } else {
        temp_obj_animation[index] = end_animation.export()
        item.desc = 0.8
      }

    })

    this.animationData = temp_obj_animation
    this.datas = temp_data_list
  }
}

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
    app: null,
    isHomeList: true,
    pageSize: 5, // 每页数量
    currentAttribute: {
      page: 1, // 当前页面
      overPage: false, // 是否已经载入完
    },
    dataList: [],


    animationData: {},
    itemMargin: 60,
    windowHeight: 2000,

    toView: 'blue',
  },
  created: function() {
    this.scrollAnimation = new HandleScrollAnimation((animation, datas, showID) => {
      this._updateAnimation(animation, datas, showID)
    }, this.data.itemMargin)
  },
  attached: function () {

  },
  ready: function () {

  },
  moved: function () {

  },
  detached: function () {

  },
  /**
   * 组件的方法列表
   */
  methods: {
    scrollAnimation: null, // 滚动条动画对象
    /**
     * 载入数据
     */
    init: function (app) {

      this.setData({
        app: app
      })
      if (!this.properties.articleName) {
        this.setData({
          isHomeList: true
        })
        this.properties.articleName = '专题'
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
    nextPage: function () {
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
    _handleTapType: function (e) {
      const id = e.currentTarget.dataset.id
      const name = e.currentTarget.dataset.name
      if (this.data.isHomeList) {
        this.properties.app.jumpPage('/pages/recommend/list?id=' + id + '&name=' + name)
      }

      const eventDetail = {
        id: id,
        name: name
      } // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      this.triggerEvent('taptype', eventDetail, eventOption)
    },
    _handleTapItem: function (e) {
      const id = e.currentTarget.dataset.id

      this.data.app.jumpPage('/pages/recommend/detail?id=' + id)

      const eventDetail = {
        id: id
      } // detail对象，提供给事件监听函数
      const eventOption = {} // 触发事件的选项
      this.triggerEvent('tapitem', eventDetail, eventOption)
    },
    _handleScrollUpper: function(e) {
      console.log('到顶部',e)
    },
    _handleScrollLower: function (e) {
      console.log('到低部', e)
    },
    _handleScroll: function(e){
      if (this.scrollAnimation) {
        this.scrollAnimation.update(e.detail.scrollTop, e.detail.scrollHeight)
      }
    },
    _updateAnimation: function (animation, datas, showID) {
      this.setData({
        dataList: datas,
        animationData: animation,
      })
      if (showID) {
        this.setData({
          toView: 'id_' + showID,
        })
      }
    },
    _getList: function () {
      const post_data = {
        page: this.data.currentAttribute.page, // 当前页数
        pageSize: this.data.pageSize, // 每页显示数量
        zhuanTiId: this.properties.articleId
      }
      const success_server = (resData) => {
        if (resData.data) {
          /*
          let temp_list = this.data.dataList
          const old_length = temp_list.length
          */
          if (resData.data.length == 0) {
            this.setData({
              'currentAttribute.overPage': true
            })
          } else {
            const temp_obj = this.scrollAnimation.addDatas(resData.data)
            /*
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
            */
            this.setData({
              'dataList': temp_obj.datas,
              'animationData': temp_obj.animation
            })
          }
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
      this.data.app.Tools.API_server.getRecommend(post_data, success_server, fail_server)
    }
  }

})
