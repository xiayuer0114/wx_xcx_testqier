// components/searchBar/index.js
var app = getApp();
Page({

  /**
   * 页面的初始数据
   */
  data: {
    show_mask:false,
    search_list:[],
   
    text_value:'',
  
    page:1,
  },

  /**
   * 生命周期函数--监听页面加载
   */
  onLoad: function (options) {
    
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
  showHistory:function(){
    if(!this.data.show_mask){
      this.setData({
        show_mask: !this.data.show_mask
      })
      
    }
    
  },
  hideMask:function(){
    this.setData({
      show_mask: false
    })
  },
  /**
   * 监听input
   */
  watchInput: function (event) {
    var that = this ;
      var text = event.detail.value;
      that.setData({
        text_value:text
      })
      if(text != ''){
        that.getSearchContent(text,that.data.page);
       
      }
      else if(text == ''){
        this.setData({
          show_mask: false
        })
      }
      
  },
  getSearchContent:function(text,page){
    
    var that = this ;
    that.setData({
      search_list:[]
    })
    wx.request({
      url: app.globalData.host +'applet/loadPubBySearch.do',
      method:'POST',
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },      
      data:{
        page:page,
        pageSize:'5',
        searchBody:text
      },
      success:function(res){
        // console.log(res);
       
        if (res.statusCode==200){
          if (res.data.data.length>0){
            that.setData({
              search_list: res.data.data,
               show_mask: true
            })
          }else{
            that.setData({
             
              show_mask: false
            })
          }
          // var list1 = that.data.search_list;
          // var list2 = res.data.data;
          // list1 = list1.concat(list2);

        
          console.log(that.data.search_list);
        }
      }
    })
  },
  /**
   * 下拉刷新
   */
  bindDownLoad: function (){
    var that = this;
    var page = that.data.page;
    page += 1;
    that.setData({
      page: page
    })
    that.getSearchContent(that.data.text_value,page);

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