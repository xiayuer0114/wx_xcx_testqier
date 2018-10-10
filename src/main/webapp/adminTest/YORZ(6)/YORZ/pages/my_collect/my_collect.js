// pages/my_collect/my_collect.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    // 标签id
      tabs_id:0,
      // 显示收藏
      show_collect:true,
      // 动画组
      animationData: {},
      animation1:'',
      animation2:'',
      // 收藏列表
      collect_list:[],
      // 图片主域名
      imgUrl:'',
      // 记录列表
      record_list:[],
      // 显示历史消费
      show_histroy:false,
      //显示浏览记录
      show_record:false,
      fee_list:[],
      page:1,
      current_id:-1,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    var page = this.data.page;
    var id = options.id;
    // 从哪个标签进来就获取对应的列表
    if(id == 0){
      this.setData({
        tabs_id: options.id
      })
      this.getCollectDetail(page);
    }else if(id == 1){
      this.setData({
        tabs_id: options.id
      })
      this.getHistroy(page);
    }else if(id==2){
      this.setData({
        tabs_id: options.id
      })
      this.getRecordDetail(page);
    }

    this.setData({
      animation1: this.data.animationData,
     
    })
  //  this.initDataPage();
   console.log(app.globalData.userId);
   this.setData({
     imgUrl:app.globalData.host
   })
  },

  /**
   * 生命周期函数--监听页面初次渲染完成
   */
  onReady: function () {
    this.getAnimation();
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
  /**
   * 动画效果
   */
  getAnimation:function(){
    var animation = wx.createAnimation({
      duration: 1000,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translate(-375).step(1000)
      this.setData({
        animationData: animation.export()
      })
    }.bind(this), 100)
  },
  
  /**
   * 点击显示对应的内容
   */
  chooseTabs:function(e){
    this.setData({
      page:1
    })
    var page = this.data.page;
    var animation = wx.createAnimation({
      duration: 1000,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translate(-375).step(1000)
      this.setData({
        animationData: animation.export()
      })
    }.bind(this), 100)

    
    var that =this;
    console.log(e.currentTarget.dataset.index)
    var index = e.currentTarget.dataset.index;
    this.setData({
      animationData: {}
    })
    if (index != that.data.current_id){
      that.setData({
        current_id:index,
        collect_list:[],
        record_list:[],
        fee_list:[]
      })
      if (index == 0) {
        that.getAnimation();
        that.setData({
          tabs_id: e.currentTarget.dataset.index,
        })
        that.getCollectDetail(page);
      } else if (index == 1) {
        that.getAnimation();
        that.setData({
          tabs_id: e.currentTarget.dataset.index,
        })
        that.getHistroy(page);
      } else if (index == 2) {
        that.getAnimation();
        that.setData({
          tabs_id: e.currentTarget.dataset.index,
        });
        that.getRecordDetail(page);
      }
    }
    
    
    this.setData({
      animationData: this.animation.export()
    })
  },
  /**
   * 初始化函数
   */
  initDataPage:function(){
    this.getCollectDetail();
  },
  /**
   * 获取收藏数据
   */
  getCollectDetail: function (page){
    var that = this ;
    wx.request({
      url: app.globalData.host +'applet/loadMyCollect.do',
      method:'GET',
      data:{
        page:page,
        pageSize: 5,
        userId: app.globalData.userId
      },
      success:function(res){
        console.log(res);
        if (res.data.statusCode == 200) {
          var list1 = that.data.collect_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            collect_list: list1
          })
        }
        // if(res.statusCode==200){
        //   that.setData({
        //     collect_list: list1
        //   })
        // }
      }
    })
  },
  /**
   * 浏览记录
   */
  getRecordDetail: function (page){
    var that =this ;
    wx.request({
      url: app.globalData.host +'applet/loadMyBrowseHistory.do',
      method:'GET',
      data:{
        page: page,
        pageSize: 5,
        userId: app.globalData.userId
      },
      success:function(res){
        console.log('浏览记录')
        console.log(res);
        if (res.data.statusCode == 200) {
          var list1 = that.data.record_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            record_list: list1
          })
          console.log(that.data.record_list.length);
        }
        // if(res.statusCode==200){
        //   that.setData({
        //     record_list:res.data.data
        //   })
        // }
      }
    })
  },
 
  /**
   * 历史消费
   */
  getHistroy: function (page){
    var that = this;
    wx.request({
      url: app.globalData.host +'applet/loadMyPayHistory.do',
      method:'GET',
      data:{
        page: page,
        pageSize: 5,
        userId: app.globalData.userId
        // userId: '5abcbeab7d170b785359e6a5'
      },
      success:function(res){
        console.log(res);
        if (res.data.statusCode == 200) {
          var list1 = that.data.fee_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            fee_list: list1
          })
        }
        // if(res.data.statusCode==200){
        //   that.setData({
        //     fee_list:res.data.data
        //   })
        // }
      }
    })
  },
 
  /**
   * 下拉加载
   */
  bindDownLoad: function () {   
    var that = this;
    var page = that.data.page;
    page += 1;
    that.setData({
      page: page
    })
    var index = that.data.tabs_id;
    if (index == 0){
      that.getCollectDetail(page);
    }else if(index == 1){
      that.getHistroy(page);
    }else if(index==2){
      that.getRecordDetail(page);
    }
  
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
})
