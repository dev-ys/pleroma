(window.webpackJsonp=window.webpackJsonp||[]).push([[13],{687:function(t,e,a){"use strict";a.r(e),a.d(e,"default",function(){return v});var s,i,o,c=a(1),n=a(6),p=a(0),r=a(2),d=(a(3),a(20)),u=a(26),l=a.n(u),h=a(5),b=a.n(h),m=a(27),j=a(36),I=a(647),O=a(289),w=a(640),f=a(902),R=a(642),g=a(4),L=a(24),M=a(7),v=Object(d.connect)(function(t,e){var a=e.params.accountId,s=e.withReplies,i=void 0!==s&&s,o=i?a+":with_replies":a;return{statusIds:t.getIn(["timelines","account:"+o,"items"],Object(g.List)()),featuredStatusIds:i?Object(g.List)():t.getIn(["timelines","account:"+a+":pinned","items"],Object(g.List)()),isLoading:t.getIn(["timelines","account:"+o,"isLoading"]),hasMore:t.getIn(["timelines","account:"+o,"hasMore"])}})((o=i=function(i){function t(){for(var e,t=arguments.length,a=new Array(t),s=0;s<t;s++)a[s]=arguments[s];return e=i.call.apply(i,[this].concat(a))||this,Object(r.a)(Object(p.a)(Object(p.a)(e)),"handleLoadMore",function(t){e.props.dispatch(Object(j.n)(e.props.params.accountId,{maxId:t,withReplies:e.props.withReplies}))}),e}Object(n.a)(t,i);var e=t.prototype;return e.componentWillMount=function(){var t=this.props,e=t.params.accountId,a=t.withReplies;this.props.dispatch(Object(m.A)(e)),a||this.props.dispatch(Object(j.l)(e)),this.props.dispatch(Object(j.n)(e,{withReplies:a}))},e.componentWillReceiveProps=function(t){(t.params.accountId!==this.props.params.accountId&&t.params.accountId||t.withReplies!==this.props.withReplies)&&(this.props.dispatch(Object(m.A)(t.params.accountId)),t.withReplies||this.props.dispatch(Object(j.l)(t.params.accountId)),this.props.dispatch(Object(j.n)(t.params.accountId,{withReplies:t.params.withReplies})))},e.render=function(){var t=this.props,e=t.shouldUpdateScroll,a=t.statusIds,s=t.featuredStatusIds,i=t.isLoading,o=t.hasMore;return!a&&i?Object(c.a)(w.a,{},void 0,Object(c.a)(O.a,{})):Object(c.a)(w.a,{},void 0,Object(c.a)(R.a,{}),Object(c.a)(I.a,{prepend:Object(c.a)(f.a,{accountId:this.props.params.accountId}),alwaysPrepend:!0,scrollKey:"account_timeline",statusIds:a,featuredStatusIds:s,isLoading:i,hasMore:o,onLoadMore:this.handleLoadMore,shouldUpdateScroll:e,emptyMessage:Object(c.a)(M.b,{id:"empty_column.account_timeline",defaultMessage:"No toots here!"})}))},t}(L.a),Object(r.a)(i,"propTypes",{params:b.a.object.isRequired,dispatch:b.a.func.isRequired,shouldUpdateScroll:b.a.func,statusIds:l.a.list,featuredStatusIds:l.a.list,isLoading:b.a.bool,hasMore:b.a.bool,withReplies:b.a.bool}),s=o))||s}}]);
//# sourceMappingURL=account_timeline.js.map