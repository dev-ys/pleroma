(window.webpackJsonp=window.webpackJsonp||[]).push([[22],{688:function(a,t,o){"use strict";o.r(t),o.d(t,"default",function(){return L});var e,c,s,r=o(1),n=o(6),p=o(0),i=o(2),d=o(53),u=o.n(d),l=(o(3),o(20)),h=o(24),b=o(5),f=o.n(b),j=o(26),O=o.n(j),m=o(289),I=o(27),w=o(7),y=o(887),M=o(640),v=o(902),g=o(642),A=o(641),L=Object(l.connect)(function(a,t){return{accountIds:a.getIn(["user_lists","followers",t.params.accountId,"items"]),hasMore:!!a.getIn(["user_lists","followers",t.params.accountId,"next"])}})((s=c=function(c){function a(){for(var a,t=arguments.length,o=new Array(t),e=0;e<t;e++)o[e]=arguments[e];return a=c.call.apply(c,[this].concat(o))||this,Object(i.a)(Object(p.a)(Object(p.a)(a)),"handleLoadMore",u()(function(){a.props.dispatch(Object(I.y)(a.props.params.accountId))},300,{leading:!0})),a}Object(n.a)(a,c);var t=a.prototype;return t.componentWillMount=function(){this.props.dispatch(Object(I.A)(this.props.params.accountId)),this.props.dispatch(Object(I.C)(this.props.params.accountId))},t.componentWillReceiveProps=function(a){a.params.accountId!==this.props.params.accountId&&a.params.accountId&&(this.props.dispatch(Object(I.A)(a.params.accountId)),this.props.dispatch(Object(I.C)(a.params.accountId)))},t.render=function(){var a=this.props,t=a.shouldUpdateScroll,o=a.accountIds,e=a.hasMore;if(!o)return Object(r.a)(M.a,{},void 0,Object(r.a)(m.a,{}));var c=Object(r.a)(w.b,{id:"account.followers.empty",defaultMessage:"No one follows this user yet."});return Object(r.a)(M.a,{},void 0,Object(r.a)(g.a,{}),Object(r.a)(A.a,{scrollKey:"followers",hasMore:e,onLoadMore:this.handleLoadMore,shouldUpdateScroll:t,prepend:Object(r.a)(v.a,{accountId:this.props.params.accountId,hideTabs:!0}),alwaysPrepend:!0,emptyMessage:c},void 0,o.map(function(a){return Object(r.a)(y.a,{id:a,withNote:!1},a)})))},a}(h.a),Object(i.a)(c,"propTypes",{params:f.a.object.isRequired,dispatch:f.a.func.isRequired,shouldUpdateScroll:f.a.func,accountIds:O.a.list,hasMore:f.a.bool}),e=s))||e}}]);
//# sourceMappingURL=followers.js.map