// pages/setting/setting.js
Page({

  /**
   * 页面的初始数据
   */
  data: {
    tabs_item: ['早餐', '午餐', '下午茶', '晚餐', '夜宵'],
    tabs_item1: ['个人休闲', '甜蜜约会', '朋友小聚', '商务宴请', '家庭聚会', '有朋自远方'],
    x1: 0,
    x2: 3000,
    hide_mask: false,
    turn_price: false,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.setData({
      hide_mask:false
    })
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

  /**
   * 用户点击右上角分享
   */
  onShareAppMessage: function () {
  
  },
  onChange(e) {
    console.log(e.detail)
    var x1 = parseInt(e.detail.x);
    x1 = parseInt((x1-3) * 10);
    var x2 = this.data.x2;
    if (x1 > 3000) {
      x1 = 3000
    } else if (x1 < 0) {
      x1 = 0
    }
    if (x2 > 3000) {
      x2 = 3000
    } else if (x2 < 0) {
      x2 = 0
    }
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
    x2 = -x2 - 30
    //  var length1 =x2*2.15;
    //  var length2 =645-length1
    x2 = parseInt(x2 * 10);
    x2 = 3000 - x2;
    var x1 = this.data.x1;
    if(x1>3000){
      x1=3000
    }else if(x1<0){
      x1=0
    }
    if (x2 > 3000) {
      x2 = 3000
    } else if (x2 < 0) {
      x2 = 0
    }
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
  show:function(){
    this.setData({
      hide_mask:true
    })
  }
})