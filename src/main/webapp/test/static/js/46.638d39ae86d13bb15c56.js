webpackJsonp([46],{"/ykB":function(e,t,a){var n=a("KHr/");"string"==typeof n&&(n=[[e.i,n,""]]),n.locals&&(e.exports=n.locals);a("rjj0")("333c5b89",n,!0)},"0Z1L":function(e,t,a){"use strict";var n=function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"clearfix h-wrap"},[a("div",{directives:[{name:"show",rawName:"v-show",value:e.showBack,expression:"showBack"}],staticClass:"h-icon",on:{click:e.back}},[a("i",{staticClass:"fa fa-chevron-left",attrs:{"aria-hidden":"true"}})]),e._v(" "),a("div",{directives:[{name:"show",rawName:"v-show",value:e.close,expression:"close"}],staticClass:"h-icon",on:{click:e.closeModal}},[a("i",{staticClass:"fa fa-angle-left",attrs:{"aria-hidden":"true"}})]),e._v(" "),a("div",{staticClass:"h-title"},[e._v(e._s(e.title))]),e._v(" "),a("div",{directives:[{name:"show",rawName:"v-show",value:e.showSliders,expression:"showSliders"}],staticClass:"s-icon",on:{click:e.sliders}},[a("i",{staticClass:"fa fa-sliders",attrs:{"aria-hidden":"true"}})])])},i=[],r={render:n,staticRenderFns:i};t.a=r},FvBv:function(e,t,a){var n=a("ssCn");"string"==typeof n&&(n=[[e.i,n,""]]),n.locals&&(e.exports=n.locals);a("rjj0")("8b4a01b2",n,!0)},"KHr/":function(e,t,a){t=e.exports=a("FZ+f")(!0),t.push([e.i,".verify-wrap[data-v-6ece42fa]{background:#e5e5e5;height:100%;padding-bottom:55px;overflow-x:hidden;overflow-y:scroll}.verify-wrap .verify-main[data-v-6ece42fa]{margin-top:40px}.verify-wrap .verify-main .title[data-v-6ece42fa]{padding:.6rem;color:#999}.verify-wrap .verify-main .img-wrap[data-v-6ece42fa]{background:#fff}","",{version:3,sources:["E:/项目/m-truckgogo/m-hongyanche/src/views/dealer/dealer-verify.vue"],names:[],mappings:"AACA,8BACE,mBAAoB,AACpB,YAAa,AACb,oBAAqB,AACrB,kBAAmB,AACnB,iBAAmB,CACpB,AACD,2CACE,eAAiB,CAClB,AACD,kDACE,cAAe,AACf,UAAY,CACb,AACD,qDACE,eAAiB,CAClB",file:"dealer-verify.vue",sourcesContent:["\n.verify-wrap[data-v-6ece42fa] {\n  background: #e5e5e5;\n  height: 100%;\n  padding-bottom: 55px;\n  overflow-x: hidden;\n  overflow-y: scroll;\n}\n.verify-wrap .verify-main[data-v-6ece42fa] {\n  margin-top: 40px;\n}\n.verify-wrap .verify-main .title[data-v-6ece42fa] {\n  padding: .6rem;\n  color: #999;\n}\n.verify-wrap .verify-main .img-wrap[data-v-6ece42fa] {\n  background: #fff;\n}\n"],sourceRoot:""}])},TeZD:function(e,t,a){"use strict";function n(e){a("/ykB")}Object.defineProperty(t,"__esModule",{value:!0});var i=a("kBL6"),r=a("zcwW"),o=a("VU/8"),s=n,c=o(i.a,r.a,s,"data-v-6ece42fa",null);t.default=c.exports},"h/N8":function(e,t,a){"use strict";var n=a("IPo5");t.a={name:"App-Header",props:{title:{type:String},showBack:"",close:"",showSliders:""},beforeDestroy:function(){n.a.$off("clickCloseModal")},methods:{back:function(){this.$router.back()},closeModal:function(){n.a.$emit("clickCloseModal"),this.$parent.$emit("clickCloseModalBox")},sliders:function(){this.$parent.$emit("clickSliders")},goToOrder:function(){}}}},hxP8:function(e,t,a){"use strict";function n(e){a("FvBv")}var i=a("h/N8"),r=a("0Z1L"),o=a("VU/8"),s=n,c=o(i.a,r.a,s,"data-v-a193f550",null);t.a=c.exports},kBL6:function(e,t,a){"use strict";var n=a("hxP8"),i=a("QB53");t.a={name:"Dealer-Hexiao",data:function(){return{cardInfo:{vin:"",buyCardTel:"",buyCarTel:"",imgs:"",types:"",job_number:"",tokens:[{num:""}],num:1},showJobNumber:!1}},mounted:function(){},watch:{"cardInfo.types":function(e){this.showJobNumber="服务"===e}},methods:{uploadImg:function(){var e=this,t=new FormData;t.append("0",this.$refs.resource.files[0]),a.i(i.v)(t).then(function(t){var a=t.data.url;e.cardInfo.imgs=a;var n=document.createElement("img"),i=document.getElementById("imgWrap");n.style.width="144px",n.setAttribute("src",a),i.appendChild(n),e.$toast("发票上传成功")}).catch(function(t){console.error(t),e.$toast("服务器繁忙, 请重试")})},clickPulsBtnHandler:function(){this.cardInfo.tokens.push({num:""})},minusInput:function(){this.cardInfo.tokens.length>1&&this.cardInfo.tokens.splice(this.cardInfo.tokens.length-1,1)},submitInfo:function(){var e=this;if(!this.cardInfo.types)return this.$toast("必须选择核销类别");if("服务"===this.cardInfo.types&&!this.cardInfo.job_number)return this.$toast("必须填写工单号");var t=this.selectTypes(this.cardInfo.types),n=[];this.cardInfo.tokens.forEach(function(e){n.push(e.num)}),a.i(i.w)(n.toString(),this.cardInfo.vin,this.cardInfo.imgs,this.cardInfo.buyCardTel,this.cardInfo.buyCarTel,this.cardInfo.job_number,t).then(function(t){t.state?(e.$toast(t.errormsg),e.$router.back()):e.$toast(t.errormsg)}).catch(function(t){e.$toast("网络错误:"+t.data.errormsg||t.message)})},selectTypes:function(e){switch(e){case"服务":return e=1;case"购物":return e=2}}},components:{AppHeader:n.a}}},ssCn:function(e,t,a){t=e.exports=a("FZ+f")(!0),t.push([e.i,'.h-wrap[data-v-a193f550]{position:fixed;top:0;left:0;right:0;padding:.5rem;text-align:center;font-size:1rem;border-bottom:1px solid #eee;background-color:#6495ed;z-index:10;color:#fff}.h-wrap .h-icon[data-v-a193f550]{position:absolute;text-align:center;width:2rem}.h-wrap .h-title[data-v-a193f550]{font-weight:700}.h-wrap .s-icon[data-v-a193f550]{text-align:center;position:absolute;right:0;top:.5rem;width:4rem}.h-wrap .s-icon[data-v-a193f550]:after{content:"    \\7B5B\\9009";font-size:12px}',"",{version:3,sources:["E:/项目/m-truckgogo/m-hongyanche/src/components/header/header.vue"],names:[],mappings:"AACA,yBACE,eAAgB,AAChB,MAAO,AACP,OAAQ,AACR,QAAS,AACT,cAAe,AACf,kBAAmB,AACnB,eAAgB,AAChB,6BAA8B,AAC9B,yBAAiC,AACjC,WAAY,AACZ,UAAa,CACd,AACD,iCACE,kBAAmB,AACnB,kBAAmB,AACnB,UAAY,CACb,AACD,kCACE,eAAkB,CACnB,AACD,iCACE,kBAAmB,AACnB,kBAAmB,AACnB,QAAS,AACT,UAAW,AACX,UAAY,CACb,AACD,uCACE,yBAAkB,AAClB,cAAgB,CACjB",file:"header.vue",sourcesContent:['\n.h-wrap[data-v-a193f550] {\n  position: fixed;\n  top: 0;\n  left: 0;\n  right: 0;\n  padding: .5rem;\n  text-align: center;\n  font-size: 1rem;\n  border-bottom: 1px solid #eee;\n  background-color: cornflowerblue;\n  z-index: 10;\n  color: white;\n}\n.h-wrap .h-icon[data-v-a193f550] {\n  position: absolute;\n  text-align: center;\n  width: 2rem;\n}\n.h-wrap .h-title[data-v-a193f550] {\n  font-weight: bold;\n}\n.h-wrap .s-icon[data-v-a193f550] {\n  text-align: center;\n  position: absolute;\n  right: 0;\n  top: .5rem;\n  width: 4rem;\n}\n.h-wrap .s-icon[data-v-a193f550]:after {\n  content: "    筛选";\n  font-size: 12px;\n}\n'],sourceRoot:""}])},zcwW:function(e,t,a){"use strict";var n=function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"verify-wrap"},[a("app-header",{attrs:{title:"核销券",showBack:"true"}}),e._v(" "),a("div",{staticClass:"verify-main ios-s"},[a("div",{staticClass:"title"},[e._v("用户信息")]),e._v(" "),a("mt-field",{attrs:{label:"Vin号",placeholder:"请输入Vin号后八位"},model:{value:e.cardInfo.vin,callback:function(t){e.cardInfo.vin=t},expression:"cardInfo.vin"}}),e._v(" "),a("a",{staticClass:"mint-cell mint-field",attrs:{href:"javascript:void(0)"}},[a("div",{staticClass:"mint-cell-wrapper"},[e._m(0),e._v(" "),a("div",{staticClass:"mint-cell-value"},[a("mt-radio",{attrs:{title:"请选择核销类别",options:["服务","购物"]},model:{value:e.cardInfo.types,callback:function(t){e.cardInfo.types=t},expression:"cardInfo.types"}})],1)])]),e._v(" "),a("mt-field",{directives:[{name:"show",rawName:"v-show",value:e.showJobNumber,expression:"showJobNumber"}],attrs:{label:"工单号",placeholder:"请输入工单号"},model:{value:e.cardInfo.job_number,callback:function(t){e.cardInfo.job_number=t},expression:"cardInfo.job_number"}}),e._v(" "),a("div",{attrs:{id:"token-wrap"}},e._l(e.cardInfo.tokens,function(t,n){return a("mt-field",{key:n,attrs:{label:"使用码",placeholder:"请输入您的使用码",id:"token"},model:{value:t.num,callback:function(e){t.num=e},expression:"item.num"}},[a("i",{staticClass:"fa fa-minus",staticStyle:{"font-size":"1.5rem"},attrs:{"aria-hidden":"true"},on:{click:e.minusInput}}),e._v(" "),a("i",{staticClass:"fa fa-plus",staticStyle:{"font-size":"1.5rem"},attrs:{"aria-hidden":"true"},on:{click:e.clickPulsBtnHandler}})])})),e._v(" "),a("mt-field",{attrs:{label:"购券人手机号",placeholder:"请输入手机号"},model:{value:e.cardInfo.buyCardTel,callback:function(t){e.cardInfo.buyCardTel=t},expression:"cardInfo.buyCardTel"}}),e._v(" "),a("mt-field",{attrs:{label:"购车人手机号",placeholder:"请输入手机号"},model:{value:e.cardInfo.buyCarTel,callback:function(t){e.cardInfo.buyCarTel=t},expression:"cardInfo.buyCarTel"}}),e._v(" "),a("div",{staticClass:"clearfix img-wrap",staticStyle:{padding:"0 1rem"},attrs:{id:"imgWrap"}},[a("p",[e._v("请上传发票")]),e._v(" "),a("div",{staticClass:"uploader-box",staticStyle:{width:"3rem",height:"3rem"}},[a("input",{ref:"resource",attrs:{type:"file",id:"file"},on:{change:e.uploadImg}})])]),e._v(" "),a("mt-button",{staticStyle:{margin:"2rem auto"},attrs:{type:"primary",size:"large"},on:{click:e.submitInfo}},[e._v("确认")])],1)],1)},i=[function(){var e=this,t=e.$createElement,a=e._self._c||t;return a("div",{staticClass:"mint-cell-title"},[a("span",{staticClass:"mint-cell-title"},[e._v("类别")])])}],r={render:n,staticRenderFns:i};t.a=r}});
//# sourceMappingURL=46.638d39ae86d13bb15c56.js.map