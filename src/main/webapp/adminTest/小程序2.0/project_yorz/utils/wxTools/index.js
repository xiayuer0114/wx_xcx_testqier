const serverApi = require('./api_server.js')
const wxApi = require('./api_wx.js')
const jump = require('./jump.js')
const debug = require('./debug.js')
const storage = require('./storage.js')
const Interface = require('./interface.js') // 小程序界面

module.exports = {
  Debug: debug,
  API_wx: wxApi.API,
  API_server: serverApi.API,
  Jump: jump,

  Storage: storage,
  Interface: Interface,
}
