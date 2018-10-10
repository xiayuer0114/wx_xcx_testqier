// pages/my_integral/my_integral.js
var util = require('../../utils/common.js')  
var app =getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    integral_id:0,
    // 标签id
    tabs_id:0,
    // 日历相关
    arr: [],
    sysW: null,
    lastDay: null,
    firstDay: null,
    weekArr: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'],
    year: null,
    // 周六
    sun_days: '',
    // 周日
    sta_days: '',
    // 分页数
    
    // 奖品列表
    prize_list:[],
    // 图片主域名
    imgUrl:'',
    // 积分
    jifen:'',
    // 天数
    tianshu:'',
    // 兑换记录数
    pageSize:5,
    // 兑换记录列表
    record_list:[],
    sign_in_list:[]
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    this.setData({
      tabs_id:options.id,
      imgUrl:app.globalData.host
    })
    this.dataTime();

    //根据得到今月的最后一天日期遍历 得到所有日期
    for (var i = 1; i < this.data.lastDay + 1; i++) {
      this.data.arr.push(i);
    }
    var res = wx.getSystemInfoSync();
    this.setData({
      sysW: res.windowHeight / 12,//更具屏幕宽度变化自动设置宽度
      marLet: this.data.firstDay,
      arr: this.data.arr,
      year: this.data.year,
      getDate: this.data.getDate,
      month: this.data.month
    });
    if (this.data.marLet == 0) {

    }
   
    this.initDataPage(this.data.pageSize);
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
  showList:function(e){
    var that = this;
    var index = e.currentTarget.dataset.index;
    that.setData({
      integral_id:e.currentTarget.dataset.index,
      pageSize:5
    })
    var pageSize = that.data.pageSize;
    if(index == 0){
      that.getPrize(pageSize);
    }else if (index == 1) {
      that.duihuanRecord(that.data.pageSize);
    }
  },
  /**
   * 切换兑换商品和记录
   */
  chooseTabs:function(e){
    var that =this;
    var index = e.currentTarget.dataset.index;
   
    that.setData({
      tabs_id:index
    })
   
  },
  //获取日历相关参数
  dataTime: function () {
    var date = new Date();
    var year = date.getFullYear();
    var month = date.getMonth();
    var months = date.getMonth() + 1;

    //获取现今年份
    this.data.year = year;

    //获取现今月份
    this.data.month = months;

    //获取今日日期
    this.data.getDate = date.getDate();

    //最后一天是几号
    var d = new Date(year, months, 0);
    this.data.lastDay = d.getDate();

    //第一天星期几
    let firstDay = new Date(year, month, 1);
    this.data.firstDay = firstDay.getDay();
  },
  /**
   * 初始化函数
   */
  initDataPage: function (pageSize){
    this.getSignIn();
    this.getPrize(pageSize);
  },
  /**
   * 签到信息
   */
  getSignIn:function(){
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadMySignInRecord.do',
      method:'GET',
      data:{
        userId: app.globalData.userId
      },
      success:function(res){
        console.log(res);
        if (res.data.statusCode==200){
          that.setData({
            sign_in_list:res.data.data,
            tianshu: res.data.tianshu,
            jifen: res.data.jifen
          })
        }
      }
    })
  },
  /**
   * 签到
   */
  signBtn:function(e){
    var that = this;
    // console.log(e.currentTarget.dataset.index);
    var index = e.currentTarget.dataset.index
    //判断签到的日期是否为今天
    if (index == this.data.getDate){
      var code = '4561'
      code = code + this.data.getDate;
      var token = app.globalData.token;
      token = token + code;
      token = util.hexMD5(token)

        wx.request({
          url: app.globalData.host +'applet/signIn.do',
          method:'GET',
          data:{
            userId: app.globalData.userId,
            randCode:code,
            token:token
          },
          success:function(res){
            console.log(res);
            if(res.data.statusCode==200){
              
              wx.showToast({
                title: res.data.message,
              })
              that.getSignIn()
            }else if(res.data.statusCode==300){
              wx.showToast({
                title: res.data.message,
              })
            }
            
          }
        })
    }
  },
  getPrize: function (pageSize){
    var that = this ;
    wx.request({
      url: app.globalData.host +'applet/laodForGoods.do',
      method:'GET',
      data:{
        page: '1',
        pageSize: pageSize
      },
      success:function(res){
        console.log(res);
        if(res.statusCode==200){
          that.setData({
            prize_list:res.data.data
          })
        }
      }
    })
  },
  /**
   * 点击兑换
   */
  duihuanBtn:function(e){
    var id =e.currentTarget.dataset.id;

    var code = '4561'
    code = code + this.data.getDate;
    var token = app.globalData.token;
    token = token + code;
    token = util.hexMD5(token)

    console.log(id);
    var that = this;
    wx.request({
      url: app.globalData.host +'applet/getOneGoods.do',
      method:'GET',
      data:{
        userId: app.globalData.userId,
        randCode: code,
        token: token,
        goodId: id
      },
      success:function(res){
        console.log(res);
        if(res.data.statusCode==200){
            that.setData({
              jifen:res.data.data.jifen
            })
            wx.showToast({
              title: res.data.message,
            })
        }else{
            wx.showToast({
              title: res.data.message,
            })
        }
      }
    })
  },
  duihuanRecord: function (pageSize){
    var that = this;
    wx.request({
      url: app.globalData.host +'applet/laodExchangeRecord.do',
      method:'GET',
      data:{
        page:'1',
        pageSize: pageSize,
        userId: app.globalData.userId,
      },
      success:function(res){
        console.log(res);
        if(res.data.statusCode==200){
          that.setData({
            record_list:res.data.data
          })
        }
      }
    })
  },
  /**
   * 下拉加载
   */
  bindDownLoad: function () {
    var that = this;
    var pageSize = that.data.pageSize;
    pageSize += 5
    that.setData({
      pageSize: pageSize
    })
    var index = that.data.integral_id;
    if (index == 0) {
      that.getPrize(pageSize);
    } else if (index == 1) {
      that.duihuanRecord(pageSize);
    }

  }
})