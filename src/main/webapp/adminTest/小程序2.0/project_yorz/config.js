
const Resource_local = '/resources/' // 本地资源路径,以便调整路径
const serverHost = "https://tiesh.liebianzhe.com/" // 正式服务器
// const serverHost = "http://test.liebianzhe.com/" // 正式服务器
// const serverHost = "http://192.168.1.101:8080/" // 正式服务器
const Resource_server = serverHost + "" // 资源地址

let serverHost_test = "http://114.115.184.214:7210/" // 测试服务器 http://test.liebianzhe.com/
let Resource_test = serverHost_test + ''
//Resource_test = '/resources/temp/' // 本地测试


module.exports = {
  ServerHost: serverHost,
  ResourceLocal: Resource_local,
  ResourceServer: Resource_server,
}
