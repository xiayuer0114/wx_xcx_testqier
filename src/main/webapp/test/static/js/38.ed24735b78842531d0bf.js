webpackJsonp([38],{"0Z1L":function(a,n,e){"use strict";var i=function(){var a=this,n=a.$createElement,e=a._self._c||n;return e("div",{staticClass:"clearfix h-wrap"},[e("div",{directives:[{name:"show",rawName:"v-show",value:a.showBack,expression:"showBack"}],staticClass:"h-icon",on:{click:a.back}},[e("i",{staticClass:"fa fa-chevron-left",attrs:{"aria-hidden":"true"}})]),a._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:a.close,expression:"close"}],staticClass:"h-icon",on:{click:a.closeModal}},[e("i",{staticClass:"fa fa-angle-left",attrs:{"aria-hidden":"true"}})]),a._v(" "),e("div",{staticClass:"h-title"},[a._v(a._s(a.title))]),a._v(" "),e("div",{directives:[{name:"show",rawName:"v-show",value:a.showSliders,expression:"showSliders"}],staticClass:"s-icon",on:{click:a.sliders}},[e("i",{staticClass:"fa fa-sliders",attrs:{"aria-hidden":"true"}})])])},t=[],o={render:i,staticRenderFns:t};n.a=o},BjJM:function(a,n,e){n=a.exports=e("FZ+f")(!0),n.push([a.i,".info-wrap[data-v-c3c5781c]{height:100%}.info-wrap .info-main-wrap[data-v-c3c5781c]{width:100%;height:100%;position:fixed;padding-top:50px;overflow:hidden}.info-wrap .info-main-wrap .car[data-v-c3c5781c]{display:-webkit-box;display:-ms-flexbox;display:flex;text-align:center;margin:.7rem;margin-top:0;padding:.4rem 0;background-color:#fff}.info-wrap .info-main-wrap .car i[data-v-c3c5781c]{display:block;-webkit-box-flex:1;-ms-flex:1;flex:1;font-size:3rem}.info-wrap .info-main-wrap .car .num[data-v-c3c5781c]{-webkit-box-flex:1;-ms-flex:1;flex:1;text-align:left}.info-wrap .info-main-wrap .car .num span[data-v-c3c5781c]{display:block}.info-wrap .info-main-wrap .detail[data-v-c3c5781c]{padding:.2rem;background-color:#fff}.info-wrap .info-main-wrap .detail p[data-v-c3c5781c]{margin:0;padding:.7rem .6rem;border-bottom:1px solid #ddd}","",{version:3,sources:["E:/项目/m-truckgogo/m-hongyanche/src/views/maintain/track/panel/carinfo.vue"],names:[],mappings:"AACA,4BACE,WAAa,CACd,AACD,4CACE,WAAY,AACZ,YAAa,AACb,eAAgB,AAChB,iBAAkB,AAClB,eAAiB,CAClB,AACD,iDACE,oBAAqB,AACrB,oBAAqB,AACrB,aAAc,AACd,kBAAmB,AACnB,aAAc,AACd,aAAc,AACd,gBAAiB,AACjB,qBAAuB,CACxB,AACD,mDACE,cAAe,AACf,mBAAoB,AAChB,WAAY,AACR,OAAQ,AAChB,cAAgB,CACjB,AACD,sDACE,mBAAoB,AAChB,WAAY,AACR,OAAQ,AAChB,eAAiB,CAClB,AACD,2DACE,aAAe,CAChB,AACD,oDACE,cAAe,AACf,qBAAuB,CACxB,AACD,sDACE,SAAU,AACV,oBAAqB,AACrB,4BAA8B,CAC/B",file:"carinfo.vue",sourcesContent:["\n.info-wrap[data-v-c3c5781c] {\n  height: 100%;\n}\n.info-wrap .info-main-wrap[data-v-c3c5781c] {\n  width: 100%;\n  height: 100%;\n  position: fixed;\n  padding-top: 50px;\n  overflow: hidden;\n}\n.info-wrap .info-main-wrap .car[data-v-c3c5781c] {\n  display: -webkit-box;\n  display: -ms-flexbox;\n  display: flex;\n  text-align: center;\n  margin: .7rem;\n  margin-top: 0;\n  padding: .4rem 0;\n  background-color: #fff;\n}\n.info-wrap .info-main-wrap .car i[data-v-c3c5781c] {\n  display: block;\n  -webkit-box-flex: 1;\n      -ms-flex: 1;\n          flex: 1;\n  font-size: 3rem;\n}\n.info-wrap .info-main-wrap .car .num[data-v-c3c5781c] {\n  -webkit-box-flex: 1;\n      -ms-flex: 1;\n          flex: 1;\n  text-align: left;\n}\n.info-wrap .info-main-wrap .car .num span[data-v-c3c5781c] {\n  display: block;\n}\n.info-wrap .info-main-wrap .detail[data-v-c3c5781c] {\n  padding: .2rem;\n  background-color: #fff;\n}\n.info-wrap .info-main-wrap .detail p[data-v-c3c5781c] {\n  margin: 0;\n  padding: .7rem .6rem;\n  border-bottom: 1px solid #ddd;\n}\n"],sourceRoot:""}])},FvBv:function(a,n,e){var i=e("ssCn");"string"==typeof i&&(i=[[a.i,i,""]]),i.locals&&(a.exports=i.locals);e("rjj0")("8b4a01b2",i,!0)},"Yt/h":function(a,n,e){"use strict";function i(a){e("zKaq")}Object.defineProperty(n,"__esModule",{value:!0});var t=e("ilvA"),o=e("e4/V"),r=e("VU/8"),A=i,s=r(t.a,o.a,A,"data-v-c3c5781c",null);n.default=s.exports},"e4/V":function(a,n,e){"use strict";var i=function(){var a=this,n=a.$createElement,e=a._self._c||n;return e("div",{staticClass:"info-wrap"},[e("app-header",{attrs:{title:"车辆信息",showBack:"true"}}),a._v(" "),e("div",{staticClass:"info-main-wrap"},[e("div",{staticClass:"car"},[e("i",{staticClass:"fa fa-truck",attrs:{"aria-hidden":"true"}}),a._v(" "),e("div",{staticClass:"num"},[e("span",[a._v("车牌号: "+a._s(a.car.vehicle_license_province)+" "+a._s(a.car.vehicle_license_number))]),a._v(" "),e("span",[a._v("车架号: "+a._s(a.car.vin))])])]),a._v(" "),e("div",{staticClass:"detail"},[e("p",[e("span",[a._v("品牌:")]),a._v(a._s(a.car.vehicle_brand))]),a._v(" "),e("p",[e("span",[a._v("设备号:")]),a._v(a._s(a.sim))])])])],1)},t=[],o={render:i,staticRenderFns:t};n.a=o},"h/N8":function(a,n,e){"use strict";var i=e("IPo5");n.a={name:"App-Header",props:{title:{type:String},showBack:"",close:"",showSliders:""},beforeDestroy:function(){i.a.$off("clickCloseModal")},methods:{back:function(){this.$router.back()},closeModal:function(){i.a.$emit("clickCloseModal"),this.$parent.$emit("clickCloseModalBox")},sliders:function(){this.$parent.$emit("clickSliders")},goToOrder:function(){}}}},hxP8:function(a,n,e){"use strict";function i(a){e("FvBv")}var t=e("h/N8"),o=e("0Z1L"),r=e("VU/8"),A=i,s=r(t.a,o.a,A,"data-v-a193f550",null);n.a=s.exports},ilvA:function(a,n,e){"use strict";var i=e("hxP8"),t=e("CPGk");n.a={name:"Car-Info",data:function(){return{car:"",sim:""}},created:function(){this.getDatas()},methods:{getDatas:function(){this.$set(this,"car",JSON.parse(e.i(t.e)("vle"))),this.$set(this,"sim",this.$route.params.id)}},components:{AppHeader:i.a}}},ssCn:function(a,n,e){n=a.exports=e("FZ+f")(!0),n.push([a.i,'.h-wrap[data-v-a193f550]{position:fixed;top:0;left:0;right:0;padding:.5rem;text-align:center;font-size:1rem;border-bottom:1px solid #eee;background-color:#6495ed;z-index:10;color:#fff}.h-wrap .h-icon[data-v-a193f550]{position:absolute;text-align:center;width:2rem}.h-wrap .h-title[data-v-a193f550]{font-weight:700}.h-wrap .s-icon[data-v-a193f550]{text-align:center;position:absolute;right:0;top:.5rem;width:4rem}.h-wrap .s-icon[data-v-a193f550]:after{content:"    \\7B5B\\9009";font-size:12px}',"",{version:3,sources:["E:/项目/m-truckgogo/m-hongyanche/src/components/header/header.vue"],names:[],mappings:"AACA,yBACE,eAAgB,AAChB,MAAO,AACP,OAAQ,AACR,QAAS,AACT,cAAe,AACf,kBAAmB,AACnB,eAAgB,AAChB,6BAA8B,AAC9B,yBAAiC,AACjC,WAAY,AACZ,UAAa,CACd,AACD,iCACE,kBAAmB,AACnB,kBAAmB,AACnB,UAAY,CACb,AACD,kCACE,eAAkB,CACnB,AACD,iCACE,kBAAmB,AACnB,kBAAmB,AACnB,QAAS,AACT,UAAW,AACX,UAAY,CACb,AACD,uCACE,yBAAkB,AAClB,cAAgB,CACjB",file:"header.vue",sourcesContent:['\n.h-wrap[data-v-a193f550] {\n  position: fixed;\n  top: 0;\n  left: 0;\n  right: 0;\n  padding: .5rem;\n  text-align: center;\n  font-size: 1rem;\n  border-bottom: 1px solid #eee;\n  background-color: cornflowerblue;\n  z-index: 10;\n  color: white;\n}\n.h-wrap .h-icon[data-v-a193f550] {\n  position: absolute;\n  text-align: center;\n  width: 2rem;\n}\n.h-wrap .h-title[data-v-a193f550] {\n  font-weight: bold;\n}\n.h-wrap .s-icon[data-v-a193f550] {\n  text-align: center;\n  position: absolute;\n  right: 0;\n  top: .5rem;\n  width: 4rem;\n}\n.h-wrap .s-icon[data-v-a193f550]:after {\n  content: "    筛选";\n  font-size: 12px;\n}\n'],sourceRoot:""}])},zKaq:function(a,n,e){var i=e("BjJM");"string"==typeof i&&(i=[[a.i,i,""]]),i.locals&&(a.exports=i.locals);e("rjj0")("cf57d5c2",i,!0)}});
//# sourceMappingURL=38.ed24735b78842531d0bf.js.map