;
(function() {
	/**
	* ajax封装
	* @obj {method,data,before,form,success,error}
	*/
	$.ajax_ = function(obj) {
		$.ajax({
			type: "Post",
			url: "http://studyServer.study.com/manage.ashx/" + obj.method,
			data: JSON.stringify(obj.data),
			xhrFields: { withCredentials: true },
       		crossDomain: true,
       		beforeSend: function (hr) {
       			if(obj.btn)
       				obj.btn.attr("disabled","disabled");
       			if(obj.form){
    				if($("span.loading").length > 0)
    					$("span.loading").html(obj.form);
    				else
    					$("#save").after($("<span>").addClass("loading").html(obj.form));
       			}
       			if (obj.before != undefined)
       				obj.before(hr);
       		},
			contentType: "application/json; charset=utf-8",
			dataType: "json",
			success: function(data) {
       			if(obj.btn)
       				obj.btn.removeAttr("disabled");
				obj.success(data)
			},
			error: function(err) {
				console.log(err.responseText);
       			if(obj.btn)
       				obj.btn.removeAttr("disabled");
       			if (obj.error != undefined)
					obj.error(err)
			}
		});
	};
	$.setLoadingSuccess = function(str){
		$("span.loading").removeClass("loaderr").addClass("loadsuccess").html(str);
	};
	$.setLoadingFailed = function(str){
		$("span.loading").removeClass("loadsuccess").addClass("loaderr").html(str);
	};
    $.dialog = function (obj) {
        var div = $("<div>").attr("id", "dialogdiv").appendTo($("body"));
        div.append(
            $("<div>").attr("id", "dialog").css({
                width: obj.width,
                height: obj.height,
                left: (div.width() - obj.width) / 2,
                top: (div.height() - obj.width) / 2
            }).append(
                $("<div>").attr("id", "dialog_title").html(obj.title).append(
                    $("<i>").html("&#xe646;").click(function () {
                        $("#dialogdiv").remove();
                    })
                ).mousedown(function (e) {
                    if (e.target.nodeName == "I") return;
                    iDiffX = e.offsetX;
                    iDiffY = e.offsetY;
                    $(document).mousemove(function (e) {
                        $("#dialog").css({
                            left: (e.clientX - iDiffX),
                            top: (e.clientY - iDiffY)
                        });
                    });
                }).mouseup(function () {
                    $(document).unbind("mousemove");
                })
                ).append(
                $("<div>").attr("id", "dialog_body").html(obj.body)
                )
        );
        if (obj.after)
            obj.after(div);
    };
	/**	 
	 * 设置url参数
	 * @par 键，也可以是对应的键值
	 * @newvalue 值
	 * */
    $.getRequest = function () {
        if (arguments.length > 0) {
            var url = window.location.search, reg, retVal;
            reg = new RegExp("(^\\?|&)" + arguments[0].toLowerCase() + "=([^&]*)(&|$)");
            retVal = url.match(reg);
            return $.isArray(retVal) && retVal.length >= 3 ? decodeURIComponent(retVal[2]) : '';
        } else
            return decodeURIComponent(window.location.search.slice(1));
    }
    $.setRequest = function (par, newvalue) {
        var queryParameters = {}, queryString = window.location.search.substring(1), re = /([^&=]+)=([^&]*)/g, m;
        while (m = re.exec(queryString)) {
            queryParameters[decodeURIComponent(m[1])] = decodeURIComponent(m[2]);
        }
        if (typeof (par) == "string") {
            queryParameters[par] = newvalue;
        } else {
            for (var k in par)
                queryParameters[k] = par[k];
        }
        var sOrigin = window.location.origin ? window.location.origin : window.location.protocol + "//" + window.location.host;
        return sOrigin + window.location.pathname + "?" + decodeURIComponent($.param(queryParameters));
    }
	/**	 
	 * 列表数据读取
	 * @obj { method: "", data:"", bodyDiv:$("#list"), pageDiv: $("#page"), setBody: function (count,list) { } }
	 * */
	$.pageData = function (obj) {
        if (obj.data.currentpage == undefined)
        {
            alert("当前页码不正确");
            return;
        }
        if (obj.data.currentpage <= 0)
        	obj.currentPage = 1;
        else
        	obj.currentPage = obj.data.currentpage;
        if (obj.data.pagesize == undefined) {
            alert("页尺寸不正确");
            return;
        }
        obj.pageSize = obj.data.pagesize;

        if(obj.displacement == undefined) //中间往左右显示几位
            obj.displacement = 3;
        if(obj.aroundFixed == undefined) //前后固定显示几位
            obj.aroundFixed = 2;
        if(obj.backText == undefined)
            obj.backText = "上一页";
        if(obj.nextText == undefined)
            obj.nextText = "下一页";
        if(obj.parName == undefined)
        	obj.parName = "page";

        var setPage = function (dc) {
            if (obj.pageDiv == undefined)
                return;
            if (dc <= 0)
                return;
            var m = Math.ceil(dc / obj.pageSize); //记录总数/每页显示=需要几页
            var pageCount = m <= 0 ? 1 : m;            
        		
            var setUrl = function(currentpage){
            	return $.setRequest(obj.parName, currentpage);
            }
            /// 上一页
            var Back = function()
            {
                if (obj.currentPage > 1)
                    $("<a>").addClass("p_back").html(obj.backText).attr("href",setUrl(obj.currentPage-1)).appendTo(obj.pageDiv);
            }
            /// 左边固定显示内容
            var Left = function()
            {
                if (obj.displacement + 1 >= obj.currentPage)
                    return;

                var start = 1, //起始点肯定是1
                    end = obj.aroundFixed;//理论结束点
                    s_end = obj.currentPage - obj.displacement; //实际结束点

                var split = s_end - end > 1 ? "<samp>...</samp>" : "";
                if (s_end <= end)
                    end = --s_end;

                for (var t = start, i = 0; t <= end; t++, i++)
                    $("<a>").html(t).attr("href",setUrl(t)).appendTo(obj.pageDiv);
                obj.pageDiv.append(split);
            }
            /// 中间往左显示内容
            var CurrentToLeft = function()
            {
                var start = 0, end = 0;
                end = obj.currentPage - 1;
                start = obj.currentPage - obj.displacement;
                if (start < 1) start = 1;

                for (var t = start, i = 0; t <= end; t++, i++)
                    $("<a>").html(t).attr("href",setUrl(t)).appendTo(obj.pageDiv);
            }
            /// 当前页
            var NowPage = function()
            {
                $("<span>").html(obj.currentPage).appendTo(obj.pageDiv);
            }
            /// 中间往右显示内容
            var CurrentToRight=function()
            {
                var start = 0, end = 0;
                start = obj.currentPage > pageCount ? pageCount + 1 : obj.currentPage + 1;
                end = obj.currentPage + obj.displacement;
                if (end >= pageCount) end = pageCount;

                for (var t = start, i = 0; t <= end; t++, i++)
                    $("<a>").html(t).attr("href",setUrl(t)).appendTo(obj.pageDiv);
            }
            /// 右边固定显示内容
            var Right=function()
            {
                if (pageCount - obj.displacement <= obj.currentPage)
                    return;
            
                var start = pageCount - obj.aroundFixed + 1, //理论上起始点           
                    s_start = obj.currentPage + obj.displacement; //实际起始点

                var split = start - s_start > 1 ? "<samp>...</samp>" : "";
                if (s_start >= start)
                    start = ++s_start;
                var end = pageCount;

                obj.pageDiv.append(split);
                for (var t = start, i = 0; t <= end; t++, i++)
                    $("<a>").html(t).attr("href",setUrl(t)).appendTo(obj.pageDiv);
            }
            /// 下一页
            var Next = function()
            {
                if (obj.currentPage < pageCount)
                    $("<a>").html(obj.nextText).addClass("p_next").attr("href",setUrl(obj.currentPage+1)).appendTo(obj.pageDiv);
            }
            obj.pageDiv.empty();
            Back();
            Left();
            CurrentToLeft();
            NowPage();
            CurrentToRight();
            Right();
            Next();
        }
        
        $.ajax_({
            method: obj.method,
            data: obj.data,
            before: function(hr){
            	obj.pageDiv.before($("<span>").addClass("loading").html("正在加载，请稍候..."));
            },
            success: function (da) {
                var p = JSON.parse(da.d);
            	$("span.loading").remove();
            	obj.setBody(p.count, p.list);
            	if(obj.noData)
            		obj.pageDiv.html(obj.noData);
                setPage(p.count);
            },
            error: function (err) {
            	$("span.loading").addClass("loaderr").html("加载失败");
            	if(obj.err)
                	obj.err(err);
            }
        });
    };
	
	$.htmlEncode = function(value) {
		return $('<div/>').text(value).html();
	};
	$.htmlDecode = function(value) {
		return $('<div/>').html(value).text();
	};
	$.Base64Encode = function(str) {
		if(str == "") return "";
		var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		var input = "";
		var output = "";
		var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
		var i = 0;

		input = $.utf8_encode(str);

		while(i < input.length) {
			chr1 = input.charCodeAt(i++);
			chr2 = input.charCodeAt(i++);
			chr3 = input.charCodeAt(i++);

			enc1 = chr1 >> 2;
			enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
			enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
			enc4 = chr3 & 63;

			if(isNaN(chr2)) {
				enc3 = enc4 = 64;
			} else if(isNaN(chr3)) {
				enc4 = 64;
			}

			output = output +
				_keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
				_keyStr.charAt(enc3) + _keyStr.charAt(enc4);
		}
		return output;
	};
	$.Base64Decode = function(str) {
		if(str == "") return "";
		var _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
		var intput = "";
		var output = "";
		var chr1, chr2, chr3;
		var enc1, enc2, enc3, enc4;
		var i = 0;
		input = str.replace(/[^A-Za-z0-9\+\/\=]/g, "");

		while(i < input.length) {
			enc1 = _keyStr.indexOf(input.charAt(i++));
			enc2 = _keyStr.indexOf(input.charAt(i++));
			enc3 = _keyStr.indexOf(input.charAt(i++));
			enc4 = _keyStr.indexOf(input.charAt(i++));

			chr1 = (enc1 << 2) | (enc2 >> 4);
			chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
			chr3 = ((enc3 & 3) << 6) | enc4;

			output = output + String.fromCharCode(chr1);

			if(enc3 != 64) {
				output = output + String.fromCharCode(chr2);
			}
			if(enc4 != 64) {
				output = output + String.fromCharCode(chr3);
			}
		}
		output = $.utf8_decode(output);
		return output;
	};
	$.utf8_encode = function(str) {
		var string = str.replace(/\r\n/g, "\n");
		var utftext = "";

		for(var n = 0; n < string.length; n++) {
			var c = string.charCodeAt(n);

			if(c < 128) {
				utftext += String.fromCharCode(c);
			} else if((c > 127) && (c < 2048)) {
				utftext += String.fromCharCode((c >> 6) | 192);
				utftext += String.fromCharCode((c & 63) | 128);
			} else {
				utftext += String.fromCharCode((c >> 12) | 224);
				utftext += String.fromCharCode(((c >> 6) & 63) | 128);
				utftext += String.fromCharCode((c & 63) | 128);
			}
		}
		return utftext;
	};
	$.utf8_decode = function(str) {
		var string = "";
		var i = 0;
		var c = c1 = c2 = 0;

		while(i < str.length) {
			c = str.charCodeAt(i);

			if(c < 128) {
				string += String.fromCharCode(c);
				i++;
			} else if((c > 191) && (c < 224)) {
				c2 = str.charCodeAt(i + 1);
				string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
				i += 2;
			} else {
				c2 = str.charCodeAt(i + 1);
				c3 = str.charCodeAt(i + 2);
				string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
				i += 3;
			}
		}
		return string;
	}

	$.check = function(obj, focus){
		var el = $("#" + obj.id), toolip = $("h6[for='" + obj.id + "']"), val = el.val();
		if(obj.empty){
			if($.trim(val) == ""){
				toolip.html(obj.empty).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.max){
			if($.trim(val).length > obj.max.v){
				toolip.html(obj.max.err + obj.max.v).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.min){
			if($.trim(val).length < obj.min.v){
				toolip.html(obj.min.err + obj.min.v).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.int){
			if(!/^(\-|)[0-9]*$/.test(val)){
				toolip.html(obj.int.err).show();
				if(focus) el.focus();
				return false;
			}
			var int_tmp = parseInt(val);
			if(obj.int.max){
				if(int_tmp > obj.int.max.v){
					toolip.html(obj.int.max.err + obj.int.max.err).show();
					if(focus) el.focus();
					return false;
				}
			}
			if(obj.int.min){
				if(int_tmp < obj.int.min.v){
					toolip.html(obj.int.min.err + obj.int.min.err).show();
					if(focus) el.focus();
					return false;
				}
			}
		}
		if(obj.float){
			if(!/^(\-|)[0-9]*(\.)[0-9]*$/.test(val)){
				toolip.html(obj.float.err).show();
				if(focus) el.focus();
				return false;
			}
			var float_tmp = parseFloat(val);
			if(obj.float.max){
				if(float_tmp > obj.float.max.v){
					toolip.html(obj.float.max.err).show();
					if(focus) el.focus();
					return false;
				}
			}
			if(obj.float.min){
				if(float_tmp < obj.float.min.v){
					toolip.html(obj.float.min.err).show();
					if(focus) el.focus();
					return false;
				}
			}
		}
		if(obj.en){
			if(!/^[A-Za-z]+$/.test(val)){
				toolip.html(obj.en).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.cn){
			if(!/^[\u0391-\uFFE5]+$/.test(val)){
				toolip.html(obj.cn).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.phone){
			if(!/^([0-9]{3,4}-)?[0-9]{7,8}$/.test(val)){
				toolip.html(obj.phone).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.mobile){
			if(!/^1(3|4|5|6|7|8|9)\d{9}$/.test(val)){
				toolip.html(obj.mobile).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.idcard){
			if(!/^\d{15}$|^\d{18}$|^\d{17}[xX]$/.test(val)){
				toolip.html(obj.idcard).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.email){
			if(!/^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(val)){
				toolip.html(obj.email).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.url){
			var strRegex = '^((https|http)?://)'
            + '?(([0-9a-z_!~*\'().&=+$%-]+: )?[0-9a-z_!~*\'().&=+$%-]+@)?' //ftp的user@
            + '(([0-9]{1,3}.){3}[0-9]{1,3}' // IP形式的URL- 199.194.52.184
            + '|' // 允许IP和DOMAIN（域名）
            + '([0-9a-z_!~*\'()-]+.)*' // 域名- www.
            + '([0-9a-z][0-9a-z-]{0,61})?[0-9a-z].' // 二级域名
            + '[a-z]{2,6})' // first level domain- .com or .museum
            + '(:[0-9]{1,4})?' // 端口- :80
            + '((/?)|' // a slash isn't required if there is no file name
            + '(/[0-9a-z_!~*\'().;?:@&=+$,%#-]+)+/?)$';
			if(!new RegExp(strRegex).test(val)){
				toolip.html(obj.url).show();
				if(focus) el.focus();
				return false;
			}
		}
		if(obj.startwith){
			if (val.substr(val, obj.startwith.v.length) != obj.startwith.v){
				toolip.html(obj.startwith.err).show();
				if(focus) el.focus();
				return false;
			}
		}
		toolip.hide();
		return true;
	};
	/**
	*@ary {
	*	id:"uname", empty:"不可为空",
    *	max:{v:40,err"不可超过"}, 
    *	min:{v:30,err:"不可小于"}, 
    *	int:{err:"只能填数字",max:{v:100,err:"不可超过"},min:{v:20,err:"不可小于"}, 
    *	float:{err:"只能填小数",max:{v:50.5,err:"不能大于"},min:{v:30.0,err:"不能小于"}}, 
    *	en:"只能填英文",
    *	cn:"只能填中文",
    *	phone:"格式不正确，0000-00000000", 
    *	mobile:"格式不正确",
    *	idcard:"格式不正确",
    *	email:"格式不正确",
    *	url:"格式不正确",
    *	startwith:{v:"http://",err:"必须以http://打头"}
	*}
	**/
    $.submitform = function(_checkList, _submit){
    	$.initform(_checkList);
    	_submit(function(){
	    	for(var i=0; i<_checkList.length; i++)
	    		if(!$.check(_checkList[i], true))
	    			return false;
	    	return true;
    	});
    }
    $.initform = function(obj){
    	for(var i=0; i<obj.length; i++){
    		var elobj = obj[i];
    		$("#" + elobj.id).data("check",elobj).focus(function(){
    			if(!$.check($(this).data("check"), false))
    				return;
    		}).blur(function(){
    			if(!$.check($(this).data("check"), false))
    				return;
    		});
    	}
    }
})();