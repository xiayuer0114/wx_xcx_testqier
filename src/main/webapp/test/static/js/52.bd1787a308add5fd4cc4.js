webpackJsonp([52],{"0Z1L":function(t,n,e){"use strict";var r=function(){var t=this,n=t.$createElement,e=t._self._c||n;return e("div",{staticClass:"clearfix h-wrap"},[e("div",{directives:[{name:"show",rawName:"v-show",value:t.showBack,expression:"showBack"}],staticClass:"h-icon",on:{click:t.back}},[e("i",{staticClass:"fa fa-chevron-left",attrs:{"aria-hidden":"true"}})]),t._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:t.close,expression:"close"}],staticClass:"h-icon",on:{click:t.closeModal}},[e("i",{staticClass:"fa fa-angle-left",attrs:{"aria-hidden":"true"}})]),t._v(" "),e("div",{staticClass:"h-title"},[t._v(t._s(t.title))]),t._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:t.showSliders,expression:"showSliders"}],staticClass:"s-icon",on:{click:t.sliders}},[e("i",{staticClass:"fa fa-sliders",attrs:{"aria-hidden":"true"}})])])},a=[],i={render:r,staticRenderFns:a};n.a=i},"1L9u":function(t,n,e){"use strict";var r=function(){var t=this,n=t.$createElement,e=t._self._c||n;return e("div",[e("app-header",{attrs:{showBack:"true",title:"申请售后"}}),t._v(" "),e("div",{staticStyle:{"padding-top":"50px","background-color":"#fff"}},[e("mt-field",{attrs:{label:"退款理由",placeholder:"请填写您的退款理由",type:"textarea",rows:"4"},model:{value:t.reason,callback:function(n){t.reason=n},expression:"reason"}}),t._v(" "),e("div",{staticClass:"imgs",attrs:{id:"imgs"}}),t._v(" "),e("div",{staticClass:"ui-title"},[t._v("\n      请上传图片\n    ")]),t._v(" "),e("div",{staticClass:"clearfix"},[e("div",{staticClass:"uploader-box",staticStyle:{width:"3rem",height:"3rem"}},[e("input",{ref:"resource",attrs:{type:"file",id:"file"},on:{change:t.uploadFile}})])]),t._v(" "),e("mt-button",{staticStyle:{"margin-top":"1rem"},attrs:{type:"primary",size:"large"},nativeOn:{click:function(n){t.submitReason(n)}}},[t._v("提交")])],1)],1)},a=[],i={render:r,staticRenderFns:a};n.a=i},"3/6W":function(t,n,e){"use strict";Object.defineProperty(n,"__esModule",{value:!0});var r=e("wzWN"),a=e("1L9u"),i=e("VU/8"),o=i(r.a,a.a,null,null,null);n.default=o.exports},FvBv:function(t,n,e){var r=e("ssCn");"string"==typeof r&&(r=[[t.i,r,""]]),r.locals&&(t.exports=r.locals);e("rjj0")("8b4a01b2",r,!0)},"h/N8":function(t,n,e){"use strict";var r=e("IPo5");n.a={name:"App-Header",props:{title:{type:String},showBack:"",close:"",showSliders:""},beforeDestroy:function(){r.a.$off("clickCloseModal")},methods:{back:function(){this.$router.back()},closeModal:function(){r.a.$emit("clickCloseModal"),this.$parent.$emit("clickCloseModalBox")},sliders:function(){this.$parent.$emit("clickSliders")},goToOrder:function(){}}}},hxP8:function(t,n,e){"use strict";function r(t){e("FvBv")}var a=e("h/N8"),i=e("0Z1L"),o=e("VU/8"),c=r,u=o(a.a,i.a,c,"data-v-a193f550",null);n.a=u.exports},ssCn:function(t,n,e){n=t.exports=e("FZ+f")(!0),n.push([t.i,'.h-wrap[data-v-a193f550]{position:fixed;top:0;left:0;right:0;padding:.5rem;text-align:center;font-size:1rem;border-bottom:1px solid #eee;background-color:#6495ed;z-index:10;color:#fff}.h-wrap .h-icon[data-v-a193f550]{position:absolute;text-align:center;width:2rem}.h-wrap .h-title[data-v-a193f550]{font-weight:700}.h-wrap .s-icon[data-v-a193f550]{text-align:center;position:absolute;right:0;top:.5rem;width:4rem}.h-wrap .s-icon[data-v-a193f550]:after{content:"    \\7B5B\\9009";font-size:12px}',"",{version:3,sources:["E:/项目/m-truckgogo/m-hongyanche/src/components/header/header.vue"],names:[],mappings:"AACA,yBACE,eAAgB,AAChB,MAAO,AACP,OAAQ,AACR,QAAS,AACT,cAAe,AACf,kBAAmB,AACnB,eAAgB,AAChB,6BAA8B,AAC9B,yBAAiC,AACjC,WAAY,AACZ,UAAa,CACd,AACD,iCACE,kBAAmB,AACnB,kBAAmB,AACnB,UAAY,CACb,AACD,kCACE,eAAkB,CACnB,AACD,iCACE,kBAAmB,AACnB,kBAAmB,AACnB,QAAS,AACT,UAAW,AACX,UAAY,CACb,AACD,uCACE,yBAAkB,AAClB,cAAgB,CACjB",file:"header.vue",sourcesContent:['\n.h-wrap[data-v-a193f550] {\n  position: fixed;\n  top: 0;\n  left: 0;\n  right: 0;\n  padding: .5rem;\n  text-align: center;\n  font-size: 1rem;\n  border-bottom: 1px solid #eee;\n  background-color: cornflowerblue;\n  z-index: 10;\n  color: white;\n}\n.h-wrap .h-icon[data-v-a193f550] {\n  position: absolute;\n  text-align: center;\n  width: 2rem;\n}\n.h-wrap .h-title[data-v-a193f550] {\n  font-weight: bold;\n}\n.h-wrap .s-icon[data-v-a193f550] {\n  text-align: center;\n  position: absolute;\n  right: 0;\n  top: .5rem;\n  width: 4rem;\n}\n.h-wrap .s-icon[data-v-a193f550]:after {\n  content: "    筛选";\n  font-size: 12px;\n}\n'],sourceRoot:""}])},wzWN:function(t,n,e){"use strict";var r=e("hxP8"),a=e("xO/y");n.a={name:"afterSales",data:function(){return{reason:"",imgs:[]}},mounted:function(){var t=this;this.$on("clickToOrder",function(){t.$router.replace("/order")})},methods:{uploadFile:function(){var t=this,n=new FormData;n.append("0",this.$refs.resource.files[0]),e.i(a.r)(n).then(function(n){if(n.state){var e=document.createElement("img");e.style.width="5rem",e.setAttribute("src",n.data.url),document.getElementById("imgs").appendChild(e),t.imgs.push(n.data.url)}else t.$toast(n.errormsg||"上传失败")}).catch(function(t){return console.log(t)})},submitReason:function(){var t=this;if(!this.reason)return this.$toast("必须输入售后原因");e.i(a.s)(this.$route.params.id,this.imgs.join(","),this.reason).then(function(n){n.state?(t.$toast("申请成功, 请等待客服处理"),t.$router.replace("/order")):t.$toast(n.errormsg||"网络繁忙，请重试")})}},components:{AppHeader:r.a}}},"xO/y":function(t,n,e){"use strict";e.d(n,"l",function(){return u}),e.d(n,"m",function(){return s}),e.d(n,"a",function(){return d}),e.d(n,"b",function(){return f}),e.d(n,"k",function(){return l}),e.d(n,"j",function(){return h}),e.d(n,"i",function(){return p}),e.d(n,"h",function(){return A}),e.d(n,"g",function(){return m}),e.d(n,"e",function(){return v}),e.d(n,"f",function(){return C}),e.d(n,"c",function(){return w}),e.d(n,"d",function(){return g}),e.d(n,"n",function(){return B}),e.d(n,"p",function(){return k}),e.d(n,"r",function(){return b}),e.d(n,"s",function(){return x}),e.d(n,"q",function(){return _}),e.d(n,"o",function(){return y});var r=e("//Fk"),a=e.n(r),i=e("imha"),o=e("mtWM"),c=e.n(o),u=function(t){return new a.a(function(n,e){c.a.post(i.k.getMessageList,{page:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},s=function(t){return new a.a(function(n,e){c.a.post(i.k.removeMessage,{message_id:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},d=function(){return new a.a(function(t,n){c.a.get(i.l.getVehicleList).then(function(n){return t(n.data)}).catch(function(t){return n(t)})})},f=function(t){return new a.a(function(n,e){c.a.post(i.l.addVehicle,t).then(function(t){n(t.data)}).catch(function(t){return e(t)})})},l=function(t){return new a.a(function(n,e){c.a.post(i.l.removeVehicle,{customer_id:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},h=function(t,n){return new a.a(function(e,r){c.a.post(i.m.orderList,{unpaid:t,page:n}).then(function(t){return e(t.data)}).catch(function(t){return r(t)})})},p=function(t){return new a.a(function(n,e){c.a.post(i.m.deleteOrder,{order_no:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},A=function(t){return new a.a(function(n,e){c.a.post(i.n.getCollectList,{class:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},m=function(t){return new a.a(function(n,e){c.a.post(i.n.deleteCollectItem,{collect_id:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},v=function(){return new a.a(function(t,n){c.a.get(i.m.addressList).then(function(n){return t(n.data)}).catch(function(t){return n(t)})})},C=function(t,n,e,r,o,u){return new a.a(function(a,s){c.a.post(i.m.addAddress,{address_name:t,address_tel:n,address_code:e,address:r,address_province:o,address_city:u}).then(function(t){return a(t.data)}).catch(function(t){return s(t)})})},w=function(t){return new a.a(function(n,e){c.a.post(i.m.removeAddress,{address_id:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},g=function(t){return new a.a(function(n,e){c.a.post(i.m.setDefaultAddress,{address_id:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},B=function(t,n){return new a.a(function(e,r){c.a.post(i.m.userModify,{key:t,value:n}).then(function(t){return e(t.data)}).catch(function(t){return r(t)})})},k=function(t){return new a.a(function(n,e){c.a.post(i.m.card,{page:t}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},b=function(t){return new a.a(function(n,e){c.a.post(i.b.uploadRefund,t,{headers:{"Content-Type":"multipart/form-data"}}).then(function(t){return n(t.data)}).catch(function(t){return e(t)})})},x=function(t,n,e,r){return new a.a(function(a,o){c.a.post(i.b.refundApply,{order_no:t,imgurl:n,reason:e,pid:r}).then(function(t){return a(t.data)}).catch(function(t){return o(t)})})},_=function(t,n){return new a.a(function(e,r){c.a.post(i.m.selectMaintain,{unit_id:t,id:n}).then(function(t){return e(t.data)}).catch(function(t){return r(t)})})},y=function(t,n){return new a.a(function(e,r){c.a.post(i.m.giveCoupon,{coupon:t,tel:n}).then(function(t){return e(t.data)}).catch(function(t){return r(t)})})}}});
//# sourceMappingURL=52.bd1787a308add5fd4cc4.js.map