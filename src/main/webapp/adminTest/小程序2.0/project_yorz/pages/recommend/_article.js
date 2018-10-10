const article = function(obj, app){
  this.page = obj
  this.showType = false
  this.init = function() {
    if (!this.page.data.currentAttribute.name) {
      this.page.setData({
        'currentAttribute.name': '专题',
      })
    }
    wx.setNavigationBarTitle({ title: this.page.data.currentAttribute.name }) // 动态设置当前页面的标题
    this.getList()
  }
  this.getList = function () {
    const post_data = {
      page: this.page.data.currentAttribute.page, // 当前页数
      pageSize: this.page.data.pageSize, // 每页显示数量
      zhuanTiId: this.page.data.currentAttribute.id
    }
    const success_server = (resData) => {
      console.log(this.page.data.pageName, "专题列表数据:", resData)
      if (resData.data) {
        //this.dataList.sp(0, this.page.data.dataList.length)
        let temp_list = this.page.data.dataList
        const old_length = temp_list.length
        if (resData.data.length == 0) {
          this.page.setData({
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
        this.page.setData({
          'dataList': temp_list
        })
        console.log("新获取到的值:", this.page.data.dataList)
      }
    }
    const fail_server = (errorMessage) => {
      console.log("获取专题列表错误", errorMessage)

      app.showLoadDataError({
        title: '数据获取失败',
        content: '专题列表载入失败:' + errorMessage,
        retry: () => {
          this._getList()
        }
      })
    }
    app.Tools.API_server.getRecommend(post_data, success_server, fail_server)
  }
  this.tapType = function (e) {
    const id = e.detail.id
    const name = e.detail.name
    console.log('到类型:', name)
    /* // 同一页面处理时开启
    this.page.setData({
      'currentAttribute.id': id,
      'currentAttribute.name': name,
    })
    */
    app.jumpPage('/pages/recommend/list?id=' + id + '&name=' + name)
  }
  this.tapItem = function (e) {
    const id = e.detail.id
    console.log('到详情:', id)
    app.jumpPage('/pages/recommend/detail?id=' + id)
  }
}


module.exports = article