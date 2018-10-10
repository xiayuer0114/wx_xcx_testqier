// pages/tetui/tetui.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    // 分享列表
    share_list: [
      {
        img: '../../images/share1.png',
        name: '微信好友'
      },
      {
        img: '../../images/share2.png',
        name: '朋友圈'
      },
      {
        img: '../../images/share3.png',
        name: 'QQ'
      },
      {
        img: '../../images/share4.png',
        name: 'QQ空间'
      },
      {
        img: '../../images/share5.png',
        name: '微博'
      },
      {
        img: '../../images/share6.png',
        name: 'instagram'
      },
      {
        img: '../../images/share7.png',
        name: 'facebook'
      },
      {
        img: '../../images/share8.png',
        name: 'twitter'
      },

    ],
    // 显示分享页
    to_share: false,
    // 
    card_list: [1, 2, 3, 4, 5],
    // 分页数
    page_num: 1,
    // 经度
    jd: '',
    // 维度
    wd: '',
    // 图片主域名
    imgUrl: app.globalData.host,
    // 产品列表
    product_list: [],

    artcle_id: 0,
    pubId: '',
    // 收藏
    favor: 0,
    page: 1,
    be_collect: 0,
    share_desc: '',

    animationData: {},
    //11111111111
    lastX: 0,          //滑动开始x轴位置
    lastY: 0,          //滑动开始y轴位置
    text: "",
    currentGesture: 0, //标识手势
    animationDataNew: {},
    imgs: [


    ]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    if (app.globalData.userId == '') {
      app.login(this, "onLoginCallBack");
    }
    app.getLocation();
    var that = this;
    wx.getLocation({
      type: 'wgs84',
      success: function (res) {
        console.log(res)
        var latitude = res.latitude
        var longitude = res.longitude
        that.setData({
          wd: latitude,
          jd: longitude
        })
        that.initDataPage(that.data.page);
      }

    })

  },
  /**
     * 登录回调函数
     */
  onLoginCallBack: function () {
    this.initDataPage(this.data.page);
  },
  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {

  },

  /**
   * 生命周期函数--监听页面显示
   */
  onShow: function () {
    var animation = wx.createAnimation({
      duration: 1000,
      timingFunction: 'linear',
    })

    this.animation = animation;
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
    return {
      title: this.data.share_desc,
      path: '/pages/infor_detail/infor_detail?id=' + this.data.pubId + '&mark=' + this.data.mark
    }
  },
  /**
   * 点击分享
   */
  toShareBtn: function () {
    this.setData({
      to_share: true
    })
  },
  initDataPage: function (page) {
    this.getDetail(page);
  },
  /**
   * 点击蒙版消失
   */
  clickMask: function () {
    this.setData({
      to_share: false
    })
  },
  /**
   * 跳转详情
   */
  toDetailPage: function (e) {
    var id = e.currentTarget.dataset.id;
    var mark = e.currentTarget.dataset.mark;
    wx.navigateTo({
      url: '/pages/infor_detail/infor_detail?id=' + id + '&mark=' + mark,
    })
  },
  /**
   * 获取数据
   */
  getDetail: function (page) {
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadMerchants.do',
      method: "GET",
      data: {
        page: page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        tetui: 200
      },
      success: function (res) {
        console.log(res);
        if (res.data.statusCode == 200) {
          var list1 = that.data.imgs;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          for (var i in list1) {
            list1[i].index = i;
            list1[i].url = that.data.imgUrl + list1[i].headPortrait;
          }

          that.setData({
            imgs: list1
          })
        }


        if (that.data.artcle_id == 0) {
          that.setData({
            pubId: res.data.data[res.data.data.length - 1].pubId,
            be_collect: res.data.data[res.data.data.length - 1].beCollected,
            share_desc: res.data.data[res.data.data.length - 1].title,
            mark: res.data.data[res.data.data.length - 1].mark,
          })
        }
      }
    })
  },
  collectBtn: function () {

    var id = this.data.pubId;
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/collectPub.do',
      method: 'GET',
      data: {
        userId: app.globalData.userId,
        pubId: id
      },
      success: function (res) {
        console.log(res);
        wx.showToast({
          title: res.data.message,
        })
        if (res.data.statusCode == 200) {
          if (that.data.be_collect == 0) {
            that.setData({
              be_collect: 1
            })
          } else if (that.data.be_collect == 1) {
            that.setData({
              be_collect: 0
            })
          }
        }
      }
    })
  },
  listenSwiper: function (e) {
    var that = this;
    console.log(e.detail.current);
    var index = e.detail.current;
    that.setData({
      artcle_id: e.detail.current
    })

    that.setData({
      // pubId: e.currentTarget.dataset.id,
      // be_collect: e.currentTarget.dataset.collect,
      // share_desc: e.currentTarget.dataset.desc
      pubId: that.data.product_list[index].pubId,
      be_collect: that.data.product_list[index].beCollected,
      share_desc: that.data.product_list[index].title,
      mark: that.data.product_list[index].mark,
    })
    console.log(that.data.pubId);
    var page = that.data.page
    if (e.detail.current == that.data.product_list.length - 1) {
      page += 1;
      that.setData({
        page: page
      })
      that.getDetail(that.data.page);
    }
    // this.rotateAndScaleThenTranslate();
  },
  rotateAndScaleThenTranslate: function () {
    // 先旋转同时放大，然后平移
    // this.animation.rotate(45).scale(2, 2).step()
    this.animation.translateY(-420).translateX(0).step({ duration: 50 });
    this.animation.translateY(0).translateX(0).rotate(0).step();
    this.setData({
      animationData: this.animation.export()
    })
  },

  //11111111111111111111111111
  handletap: function (e) {
    var id = e.currentTarget.dataset.id;
    var mark = e.currentTarget.dataset.mark;
    wx.navigateTo({
      url: '/pages/infor_detail/infor_detail?id=' + id + '&mark=' + mark,
    })

  },
  //滑动移动事件
  handletouchmove: function (event) {  

    var currentX = event.touches[0].pageX
    var currentY = event.touches[0].pageY
    var tx = currentX - this.data.lastX
    var ty = currentY - this.data.lastY
    var text = ""
    //左右方向滑动
   if (Math.abs(tx) > Math.abs(ty)) {
      if (tx < -3)
        text = "left"
      else if (tx > 3)
        text = "right"
    }
    //上下方向滑动
    else {
      if (ty < -3)
        text = "top"
      else if (ty > 3)
        text = "bottom"
    }

    //将当前坐标进行保存以进行下一次计算
    this.data.lastX = currentX
    this.data.lastY = currentY
    this.setData({
      text: text,
    });
  },

  //滑动开始事件
  handletouchtart: function (event) {
    this.data.lastX = event.touches[0].pageX
    this.data.lastY = event.touches[0].pageY;

  },
  //滑动结束事件
  handletouchend: function (event) {
    if (this.data.text == '') {
      return;
    }
    this.data.currentGesture = 0;
    var index = event.currentTarget.dataset.index;
    // console.log(index);
    // console.log(this.data.imgs);
    if(index == 0){
      this.setData({
        // pubId: e.currentTarget.dataset.id,
        // be_collect: e.currentTarget.dataset.collect,
        // share_desc: e.currentTarget.dataset.desc
        pubId: this.data.imgs[this.data.imgs.length - 1].pubId,
        be_collect: this.data.imgs[this.data.imgs.length - 1].beCollected,
        share_desc: this.data.imgs[this.data.imgs.length - 1].title
      })
    } else{
      this.setData({
        // pubId: e.currentTarget.dataset.id,
        // be_collect: e.currentTarget.dataset.collect,
        // share_desc: e.currentTarget.dataset.desc
        pubId: this.data.imgs[index-1].pubId,
        be_collect: this.data.imgs[index - 1].beCollected,
        share_desc: this.data.imgs[index - 1].title
      })
    }
    //滑动效果
    //console.log("_testffffffffffffffffffffffffffffff");

    if (index == 0) {
      this.getDetail(++this.data.page);

      var imgs = this.data.imgs;
      var animation = [];
      var animationDataNew = this.data.animationDataNew;
      for (var i = 0; i < imgs.length; i++) {
        animation[imgs[i].index] = wx.createAnimation({
          duration: 500,
          timingFunction: "step-start"
        })
        switch (i) {
          case imgs.length - 2:
            animation[imgs[i].index].top(0).left(0).width('100%').height('100%').opacity(0.8).rotate('4deg').step();
            break;
          case imgs.length - 3:
            animation[imgs[i].index].top(0).left(0).width('100%').height('100%').opacity(0.5).rotate('-4deg').step();
            break;
          default:
            animation[imgs[i].index].top(0).left(0).width('100%').height('100%').opacity(1).rotate(0).step();
            break;
        }
        animationDataNew[imgs[i].index] = animation[imgs[i].index].export();
      }
      this.setData({
        animationDataNew: animationDataNew,
        text: ''
      })
    } else {
      var animation = [];
      animation[index] = wx.createAnimation({
        duration: 500,
        timingFunction: "ease"
      })
      animation[index - 1] = wx.createAnimation({
        duration: 500,
        timingFunction: "ease"
      })
      animation[index - 2] = wx.createAnimation({
        duration: 500,
        timingFunction: "ease"
      })
      animation[index - 3] = wx.createAnimation({
        duration: 500,
        timingFunction: "ease"
      })
      var animationDataNew = this.data.animationDataNew;
      this.animation = animation
      if (this.data.text == 'right' || this.data.text == 'top') {
        animation[index].top(-80).left('100%').width(0).height(0).opacity(0).step();
      } else {
        animation[index].top(-80).left('-10%').width(0).height(0).opacity(0).step();
      }

      animationDataNew[index] = animation[index].export();
      animation[index - 1].rotate(0).opacity(1).step();
      animationDataNew[index - 1] = animation[index - 1].export();

      animation[index - 2].rotate(4).opacity(0.8).step();
      animationDataNew[index - 2] = animation[index - 2].export();

      animation[index - 3].rotate(-4).opacity(0.5).step();
      animationDataNew[index - 3] = animation[index - 3].export();
      this.setData({
        animationDataNew: animationDataNew,
        text: ''
      })
    }





  },
})