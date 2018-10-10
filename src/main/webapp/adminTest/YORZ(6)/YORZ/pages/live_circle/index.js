// pages/live_circle/index.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    // 导航列表
      tabs_list:['商圈','热门','附近','品类','筛选',],
      // 导航下标，默认为附近
      tabs_list_item_id:2,
      // 显示热门蒙版
      show_hot:false,
      // 热门蒙版类列表
      item_text:['人气最高','好评最多','新店推荐'],
      // 点击变色
      hover_click:-1,
      // 显示商圈
      show_circle:false,
      
      show_type_list:false,

      show_mask:false,
      // 产品列表
      product_list:[],
      jump_out:false,
      // 分页数
      page:1,
      // 经度
      jd: '',
      // 维度
      wd: '',
      // 图片主域名
      imgUrl: app.globalData.host,
      shangquan_list:[],
      pinlei_list:[],
      yongcan_list: [],
      fee_type_list: [],
      //人均消费min
      x1: 0,
      //人均消费max
      x2: 500,
      // 蒙版
      hide_mask: false,
      // 交换最大最小值
      turn_price: false,
      // 动画组
      animationData: {},
      yongcan:'',
      // 用餐name
      yongcan_name:'',
      // 下标
      yongcan_index:0,
      // 消费name
      fee_name:'',
      // 消费下标
      fee_index:0,
      // 轮播
      swiper:[],
      // 热门的data
      data_detail:{},
      // 商圈id
      shangquan_id:'',
      // 品类id
      teast_id:'',
      // 假日
      jiari:300,
      // 预约
      yuyue:300,
      // 新店
      xindian:300,
      //switch状态
      isChecked1: false,
      isChecked2: false,
      isChecked3:false,
      x1_index:0,
      x2_index:-27,
      min_avg:-1,
      max_avg:-1
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
   
    var that = this
    console.log(that.data.jd);
    console.log(app.globalData.jd);
    that.setData({
      jd: app.globalData.jd,
      wd: app.globalData.wd
    })
    console.log(that.data.jd);
    that.initDataPage();
    console.log(app.globalData.userId)
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
   * 动画效果
   */
  getAnimation: function () {
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translateY(-487).step(1000)
      this.setData({
        animationData: animation.export()
      })
    }.bind(this), 100)
  },
  /**
   * 清除动画效果
   */
  cutAnimation:function(){
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translateY(487).step(1000)
      this.setData({
        animationData: animation.export()
      })
     
    }.bind(this), 100)
    
  },
  /**
   * 动画效果
   */
  getAnimation1: function () {
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translateY(-340).step(1000)
      this.setData({
        animationData: animation.export()
      })
    }.bind(this), 100)
  },
  /**
   * 清除动画效果
   */
  cutAnimation1: function () {
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translateY(340).step(1000)
      this.setData({
        animationData: animation.export()
      })
    
    }.bind(this), 100)
  },
  /***
   * 动画效果3
   */
  getAnimation2: function () {
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translateY(-487).step(1000)
      this.setData({
        animationData: animation.export()
      })
    }.bind(this), 100)
  },
  /**
   * 清除动画效果
   */
  cutAnimation2: function () {
    var animation = wx.createAnimation({
      duration: 500,
      timingFunction: 'ease',
    })

    this.animation = animation;
    this.setData({
      animationData: animation.export()
    })

    setTimeout(function () {
      animation.translateY(487).step(1000)
      this.setData({
        animationData: animation.export()
      })
      
    }.bind(this), 100)
  },
  /**
   * 商圈类别列表
   */
  getShangquanList:function(pagesize){
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadShangQuan.do',
      method: 'GET',
      data: {},
      success: function (res) {
        console.log(res);
        if (res.statusCode == 200) {
          that.setData({
            shangquan_list: res.data.data
          })
        }
      }
    })
  },
  /**
   * 显示对应标签的蒙版
   */
  
  typeBind:function(e){
    var that = this ;
    var index =e.currentTarget.dataset.index;
    this.setData({
      tabs_list_item_id:index,
      page:1,
      product_list:[],
    })
    var page = that.data.page
    if(index == 0){
      that.getAnimation();
      that.getShangquanList(page);

      that.setData({
        show_mask:true,
        show_circle: !that.data.show_circle
      })
      
    } else if (index == 1) {
      that.getAnimation1();
      that.setData({
        show_mask: true,
        show_type_list: true,
      })
    }else if(index == 2){
      that.getDetail(that.data.page);
    }else if(index == 3){
      that.getTeastType()
      that.getAnimation2();
      that.setData({
        show_mask: true,
        show_hot:true
      })
    }else if(index == 4){
      that.setData({
        hide_mask:true,
        show_mask: true,
      })
      that.getYongcan();
      that.getFeeType();
    }
  },
  /**
   * 获取品类
   */
  getTeastType:function(){
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadPinLei.do',
      method: 'GET',
      data: {},
      success: function (res) {
        console.log(res);
        if (res.statusCode == 200) {
          that.setData({
            pinlei_list: res.data.data
          })
        }
      }
    })
  },
  /**
   * 筛选获取用餐
   */
  getYongcan:function(){
    var that = this ;
    wx.request({
      url: app.globalData.host +'applet/loadYongCan.do',
      method:'GET',
      data:{

      },
      success:function(res){
        console.log(res);
        if(res.data.statusCode==200){
          that.setData({
            yongcan_list:res.data.data,
            yongcan_name: res.data.data[0].pubName
          })
          console.log(that.data.yongcan_name);
        }
      }
    })
  },
  /**
  * 筛选消费类型
  */
  getFeeType: function () {
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadXiaoFei.do',
      method: 'GET',
      data: {

      },
      success: function (res) {
        console.log(res);
        if (res.data.statusCode == 200) {
          that.setData({
            fee_type_list: res.data.data,
            fee_name: res.data.data[0].pubName
          })
          console.log(that.data.fee_name)
        }
      }
    })
  },
  /**
   * 点击蒙版消失
   */
  // hideMak:function(){
  //   this.setData({
  //     show_mask: false,
  //     show_hot: false,
  //     show_type_list: false,
  //     show_circle: false
  //   })
  //   var index = this.data.tabs_list_item_id
  //   if (index == 0) {
  //     this.cutAnimation();
  //   } else if (index == 1) {
  //     this.cutAnimation1();
  //   }else if (index == 3){
  //     this.cutAnimation2();
  //   }
    
   
  // },
  /**
   * 取消按钮
   */
  cancelBtn: function () {
    var that = this;
    
    var index = that.data.tabs_list_item_id
    if (index == 0){
      that.cutAnimation();
    }else if(index == 1){
      that.cutAnimation1();
    } else if (index == 3) {
      that.cutAnimation2();
    }
    setTimeout(function () {
      that.setData({
        show_mask: false,
        show_hot: false,
        show_type_list: false,
        show_circle: false
      })
    }, 300)
  },
  /**
   * 显示排序方式
   */
  toShowType:function(){
    this.setData({
      show_type_list: !this.data.show_type_list
    })
  },
 
  onPageScroll:function(e){
    
    var length = e.scrollTop;
    console.log(length);
    if(length>=130){
      this.setData({
        jump_out:true
      })
    } else if (length<130){
      this.setData({
        jump_out: false
      })
    }
   
  },
  /**
   * 初始化函数
   */
  initDataPage:function(){

    this.getDetail(this.data.page);
    this.getSwiper();
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
        gundongType:'shenghuoquan'
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
   * 渲染商圈列表
   */
  getShangquanId:function(e){
    var id = e.currentTarget.dataset.id;
    var that = this;
    that.setData({
        show_mask: false,
        show_hot: false,
        show_type_list: false,
        show_circle: false,
        shangquan_id:id
    })
    that.getShangquanDetail();
  },
  getShangquanDetail:function(){
    var that =this;
    wx.request({
      url: app.globalData.host + 'applet/loadMerchants.do',
      method: 'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },      
      data: {
        page: that.data.page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        shangQuanId: that.data.shangquan_id
      },
      success: function (res) {
        console.log(res);
        // that.setData({
        //   product_list: res.data.data
        // })

        if (res.data.statusCode == 200) {
          var list1 = that.data.product_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            product_list: list1
          })
        }
      }
    }) 
  },
  /**
   * 热门列表渲染
   */
  getHotDataDetail:function(e){
    var index = e.currentTarget.dataset.index;
    var that = this;
    that.setData({
      hover_click: index,
      show_mask: false,
      show_hot: false,
      show_type_list: false,
      show_circle: false
    })

    var data={};


    if(index == 0){
      data={
        page: that.data.page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        remen:200,
        renqi:200
      }
    }else if(index == 1){
      data = {
        page: that.data.page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        remen: 200,
        haoping: 200
      }
    }else if(index == 2){
      data = {
        page: that.data.page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        remen: 200,
        xindian: 200
      }
    }
    that.setData({
      data_detail:data
    })
    that.getHotDetail(that.data.data_detail);

    
  },
  getHotDetail:function(data){
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadMerchants.do',
      method: 'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data: data,
      success: function (res) {
        console.log('热门');
        console.log(res);
        if (res.data.statusCode == 200) {
          var list1 = that.data.product_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            product_list: list1
          })
        }
      }
    }) 
  },
  /**
   * 获取数据(默认为附近)
   */
  getDetail: function (page){
    var that = this ;
    wx.request({
      url: app.globalData.host +'applet/loadMerchants.do',
      method: 'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data:{
        page: page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude:that.data.jd,
        latitude: that.data.wd,
        fujin:200
      },
      success:function(res){
        console.log('附近')
        console.log(res);
        if(res.data.statusCode==200){
          var list1 = that.data.product_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            product_list: list1
          })
        }
       
      }
    })
  },
  /**
   * 渲染品类列表
   */
  getTeastTypeId:function(e){
    var id = e.currentTarget.dataset.id;
    var that = this;
    that.setData({
      show_mask: false,
      show_hot: false,
      show_type_list: false,
      show_circle: false,
      teast_id:id
    })
    that.getTeastTypeDetail();
  },
  getTeastTypeDetail:function(){
    var that = this;
    wx.request({
      url: app.globalData.host + 'applet/loadMerchants.do',
      method: 'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data: {
        page: that.data.page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        pinLeiId: that.data.teast_id
      },
      success: function (res) {
        console.log('品类');
        console.log(res);
        if (res.data.statusCode == 200) {
          var list1 = that.data.product_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            product_list: list1
          })
        }
      }
    }) 
  },
 
  /**
   * 消费区间
   */
  onChange(e) {
    console.log(e.detail)
    var x1 = parseInt(e.detail.x);
    // x1 = parseInt((x1 - 3) * 10);
    // var x2 = this.data.x2;
    // if (x1 > 3000) {
    //   x1 = 3000
    // } else if (x1 < 0) {
    //   x1 = 0
    // }
    // if (x2 > 3000) {
    //   x2 = 3000
    // } else if (x2 < 0) {
    //   x2 = 0
    // }
    x1 = parseInt((x1 - 3) * 10 / 6);
    var x2 = this.data.x2;
    if (x1 > 500) {
      x1 = 500
    } else if (x1 < 0) {
      x1 = 0
    }
    if (x2 > 500) {
      x2 = 3500
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
    // x2 = parseInt(x2 * 10);
    // x2 = 3000 - x2;
    // var x1 = this.data.x1;
    // if (x1 > 3000) {
    //   x1 = 3000
    // } else if (x1 < 0) {
    //   x1 = 0
    // }
    // if (x2 > 3000) {
    //   x2 = 3000
    // } else if (x2 < 0) {
    //   x2 = 0
    // }
    x2 = parseInt(x2 * 10/6);
    x2 = 500 - x2;
    var x1 = this.data.x1;
    if (x1 > 500) {
      x1 = 500
    } else if (x1 < 0) {
      x1 = 0
    }
    if (x2 > 500) {
      x2 = 500
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
      hide_mask: false
    })
  },
  finishBtn: function () {
    var that = this;
    var x1 = that.data.x1;
    var x2 = that.data.x2;
    var sum = 0;
    if (x1 > x2) {
      sum = x1 - x2
    } else {
      sum = x2 - x1
    }
    // var min_avg = that.data.min_avg;
    // var max_avg = that.data.max_avg;
    // if (min_avg == -1) {
    //   wx.showToast({
    //     title: '请输入人均最低',
    //   })
    //   return;
    // }
    // if (max_avg == -1) {
    //   wx.showToast({
    //     title: '请输入人均最高',
    //   })
    //   return
    // }
    // if (max_avg <= min_avg) {
    //   wx.showToast({
    //     title: '最高需大于最低',
    //   })
    //   return;
    // }
    that.setData({
      hide_mask: false,
      show_mask: false,
    })
    that.getShaixuanDetail(that.data.page);
    
  },
   /**
   * 消费区间
   */
  /**
   * 用餐
   */
  yongcanBtn:function(e){
    var index = e.currentTarget.dataset.index
    var name = e.currentTarget.dataset.name
    this.setData({
      yongcan_name: name,
      yongcan_index:index
    })
    console.log(this.data.yongcan_name);
  },
  /**
   * 消费类型
   */
  feeType: function (e) {
    var index = e.currentTarget.dataset.index;
    var name = e.currentTarget.dataset.name
    this.setData({
      fee_index: index,
      fee_name: name
    })
    console.log(this.data.fee_name);
  },
  /**
   * 下拉刷新主页数据
   */
  onReachBottom: function () {
    var that = this;
    var tid = that.data.tabs_list_item_id;
    console.log("tid = " + tid);
    var page = that.data.page;
    page += 1;
    that.setData({
      page: page
    })
    if(tid==0){
      that.getShangquanDetail();
    }else if(tid == 1){
      var data_detail = that.data.data_detail;
      data_detail.page=page;
      that.setData({
        data_detail: data_detail
      })
      that.getHotDetail(that.data.data_detail);
    }else if(tid == 2){
      that.getDetail(that.data.page);
    }else if(tid == 3){
      that.getTeastTypeDetail();
    }else if(tid == 4){
      that.getShaixuanDetail(that.data.page);
    }
    
  },
  /**
   * 下拉刷新商圈弹框列表
   */
  bindDownLoadShangquan:function(){
    var that = this;
    var page= that.data.page;
    page += 1
    that.setData({
      page: page
    })
    that.getShangquanList(page);
  },
  /**
   * 下拉刷新品类列表
   */
  bindDownLoadPeilei: function () {
    var that = this;
    var page = that.data.page;
    page +=1
    that.setData({
      page: page
    })
    that.getShangquanList(page);
  },
 
  /**
   * 监听switch状态
   */
  switch1:function(e){
    console.log(e.detail.value);
    if (e.detail.value){
      this.setData({
        jiari:200
      })
    }else{
      this.setData({
        jiari: 300
      })
    }
    console.log(this.data.jiari);
  },
  switch2: function (e) {
    console.log(e.detail.value);
    if (e.detail.value) {
      this.setData({
        yuyue: 200
      })
    } else {
      this.setData({
        yuyue: 300
      })
    }
    console.log(this.data.yuyue);
  },
  switch3: function (e) {
    console.log(e.detail.value);
    if (e.detail.value) {
      this.setData({
        xindian: 200
      })
    } else {
      this.setData({
        xindian: 300
      })
    }
    console.log(this.data.xindian);
  },
  /**
   * 根据筛选条件渲染
   */
 
  getShaixuanDetail:function(page){
    var that = this ;
    // var min_avg = that.data.min_avg;
    // var max_avg = that.data.max_avg;
    var min_avg = 0;
    var max_avg = 0;
    if(that.data.turn_price){
      min_avg=that.data.x2;
      max_avg=that.data.x1;
    }else{
      min_avg = that.data.x1;
      max_avg = that.data.x2;
    } 
    wx.request({
      url: app.globalData.host + 'applet/loadMerchants.do',
      method: 'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      data: {
        page: page,
        pageSize: 5,
        userId: app.globalData.userId,
        longitude: that.data.jd,
        latitude: that.data.wd,
        shaixuan:200,
        jiari:that.data.jiari,
        yuyue: that.data.yuyue,
        xindian: that.data.xindian,
        yongcan: that.data.yongcan_name ,
        xiaofei: that.data.fee_name ,
        minRenjun: min_avg,
        maxRenjun: max_avg
      },
      success: function (res) {
        console.log('筛选')
        console.log(res);
        console.log('假日');
        console.log(that.data.jiari);
        console.log('预约');
        console.log(that.data.yuyue);
        console.log('新店');
        console.log(that.data.xindian);
        if (res.data.statusCode == 200) {
          var list1 = that.data.product_list;
          var list2 = res.data.data;
          list1 = list1.concat(list2);

          that.setData({
            product_list: list1
          })
          that.resetBtn();
        }
      }
    }) 
  },
  /**
   * 跳转详情
   */
  toDetailPage:function(e){
    var id = e.currentTarget.dataset.id;
    var mark = e.currentTarget.dataset.mark;
    wx.navigateTo({
      url: '/pages/infor_detail/infor_detail?id=' + id+'&mark='+mark,
    })
  },
  /**
   * 点击重置
   */
  resetBtn:function(){
    this.setData({
      isChecked1: false,
      isChecked2: false,
      isChecked3: false,
      yongcan_index:0,
      fee_index:0,
      jiari: 300,
      yuyue: 300,
      xindian: 300,
      x1:0,
      x2:500,
      x1_index:0,
      x2_index:-27,
      turn_price:false
    })
  },
  /**
   * 取消筛选
   */
  notsetBtn:function(){
    var that = this;
    that.setData({
      hide_mask: false,
      show_mask: false,
    })
    that.resetBtn();
  },
  /**
  * 监听input
  */
  // minAvg: function (event) {
  //   var that = this;
  //   var text = event.detail.value;
   
  //   if (text == '') {
  //     that.setData({
  //       min_avg: -1
  //     })
  //   }else{
  //     that.setData({
  //       min_avg: text
  //     })
  //   }
  // },
  // maxAvg: function (event) {
  //   var that = this;
  //   var text = event.detail.value;

  //   if (text == '') {
  //     that.setData({
  //       max_avg: -1
  //     })
  //   } else {
  //     that.setData({
  //       max_avg: text
  //     })
  //   }
  // },
})