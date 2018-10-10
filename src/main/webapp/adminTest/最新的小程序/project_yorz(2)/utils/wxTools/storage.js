
const storage = {
  info: () => {
    wx.getStorageInfo({
      success: function (res) {
        console.group("当前storage的相关信息:")
        console.log("当前storage中所有的key", res.keys)
        console.log("当前storage占用的空间大小", res.currentSize + "kb")
        console.log("storage限制的空间大小", res.limitSize + "kb")
        console.groupEnd()
      }
    })
  },
  getData: (key, isArray = false) => {
    if (isArray) {
      return wx.getStorageSync(key) || []
    }
    return wx.getStorageSync(key)
  },
  setData: (key, data, isArray = false) => {
    var oldData
    if (isArray) {
      oldData = storage.getData(key, isArray)
      oldData.unshift(data)
    } else {
      oldData = data
    }
    wx.setStorageSync(key, oldData)
  },
  remove: (key, errorFunc = undefined) => {
    try {
      wx.removeStorageSync(key)
    } catch (e) {
      if (errorFunc != undefined) {
        errorFunc()
      }
    }
  },
  clear: (errorFunc = undefined) => {
    try {
      wx.clearStorageSync()
    } catch (e) {
      if (errorFunc != undefined) {
        errorFunc()
      }
      // Do something when catch error
    }
  }
}

module.exports = storage