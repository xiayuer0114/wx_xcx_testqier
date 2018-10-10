// pages/index/index.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    swiper: [],
    tabs_item: ['早餐', '午餐', '下午茶', '晚餐', '夜宵'],
    tabs_item1: ['个人休闲', '甜蜜约会', '朋友小聚', '商务宴请', '家庭聚会', '有朋自远方'],
    x1: 0,
    x2: 3000,
    hide_mask: false,
    // length:645,
    // length2:1
    turn_price: false,
    getinfo_model: true,

    videoLink: '',
    imgUrl: app.globalData.host,
    videoId: '',
    banner: '',
    //文章
    detail: [],
    //page
    page: 1,
    //
    show_poster:true,
    poster:'',
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    app.login(this, "onLoginCallBack");
    app.getLocation();
  },
  /**
   * 登录回调函数
   */
  onLoginCallBack: function () {
    this.getDataPage(this.data.page);
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
  onChange(e) {
    console.log(e.detail)
    var x1 = parseInt(e.detail.x);
    x1 = parseInt(x1 * 10);
    var x2 = this.data.x2;
    if (x1 > x2) {
      this.setData({
        turn_price: true
      })
    } else {
      this.setData({
        turn_price: false
      })
    }
    this.setData({
      x1: x1,
    })
  },
  onChange2(e) {
    console.log(e.detail)
    var x2 = parseInt(e.detail.x);
    x2 = -x2 - 27
    //  var length1 =x2*2.15;
    //  var length2 =645-length1
    x2 = parseInt(x2 * 10);
    x2 = 3000 - x2;
    var x1 = this.data.x1;
    if (x1 > x2) {
      this.setData({
        turn_price: true
      })
    } else {
      this.setData({
        turn_price: false
      })
    }
    this.setData({
      x2: x2,
      //  length1: length1,
      //  length: length2
    })
  },
  cancleBtn: function () {
    this.setData({
      hide_mask: true
    })
  },
  finishBtn: function () {
    var x1 = this.data.x1;
    var x2 = this.data.x2;
    var sum = 0;
    if (x1 > x2) {
      sum = x1 - x2
    } else {
      sum = x2 - x1
    }
    this.setData({
      hide_mask: true
    })
  },
  /**
  * 获取用户信息授权事件函数
  */
  getUserInfoBind: function (res) {
    this.setData({
      getinfo_model: true,
    });
    app.login();
  },
  /**
   * 初始化函数
   */
  getDataPage: function (page) {
    this.getSwiper();
    this.getVideo();
    this.getArtcle(page);
  },
  /**
   * 轮播数据
   */
  getSwiper: function () {
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadPubs.do',
      method: 'GET',
      data: {
        gundongType: 'home'
      },
      success: function (res) {
        console.log("轮播");
        console.log(res);
        if (res.data.statusCode == 200) {
          that.setData({
            swiper: res.data.data
          })
        }
      }
    })
  },
  /**
   * 视频数据
   */
  getVideo: function () {
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadOneVideo.do',
      method: 'GET',
      data: {

      },
      success: function (res) {
        console.log("视频");
        console.log(res);
        if (res.data.statusCode == 200) {
          that.setData({
            videoLink: res.data.data.videoLink,
            videoId: res.data.data.videoId,
            banner: res.data.data.pic,
            poster: res.data.data.poster
          })
        }
      }
    })
  },

  /**
   * 生活家
   */
  liveHome: function () {
    var that = this;
    var videoContext = wx.createVideoContext(that.data.videoId);

    videoContext.pause();
    wx.navigateTo({
      url: '/pages/live_home/live_home',
    })
   
  },
  /**
   * 轮播跳转
   */
  lunboBtn: function (e) {
    var id = e.currentTarget.dataset.id;

    var mark = e.currentTarget.dataset.mark;
    console.log(id);
    console.log(mark);
    wx.navigateTo({
      url: '/pages/infor_detail/infor_detail?id=' + id + '&mark=' + mark,
    })
  },
  /**
* 图文视频
*/
  getArtcle: function (page) {
    wx.showLoading({
      title: '加载中',
      mask:true
    })
    var that = this;
    var data = {
      page: page,
      pageSize: 6
    };
    // if (page <= 1){
    //   data.haveVideo = 200;
    // }
    wx.request({
      url: app.globalData.host + 'applet/loadArticleAndVideo.do',
      method: 'GET',
      data: data,
      success: function (res) {
        //图文
        console.log("图文")
        console.log(res);
        if (res.statusCode == 200) {
          var list1 = that.data.detail;

          var list2 = res.data.data;

          list1 = list1.concat(list2);

          that.setData({
            detail: list1
          })
          console.log(that.data.detail);
        }
      },
      complete:function(){
        wx.hideLoading();
      }
    })
  },
  /**
   * 跳转详情
   */
  watchMore: function (e) {
    var id = e.currentTarget.dataset.id;
    var mark = e.currentTarget.dataset.mark;
    app.jumpToDetail(id, mark);
  },
  /**
   * 上拉刷新
   */
  onReachBottom: function () {
    var that = this;
    var page = that.data.page;
    page += 1;
    that.setData({
      page: page
    })
    that.getArtcle(page);
  },
 
  // videoPlay:function(e){
  //   var id = e.currentTarget.dataset.id;
  //   console.log('播放');
  //   console.log(e);
   
  //   this.setData({
  //     show_poster: false
  //   })
  //   var videoContext = wx.createVideoContext(id);

  //   videoContext.play();
  // },
  // theEnd:function(){
  //   this.setData({
  //     show_poster: true
  //   })
  // }
})