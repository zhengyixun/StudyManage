;
(function() {
    $.upfile = function (obj) {
//      var up = $.upfile({ el:$("#up"), accept:"image/jpeg,image/png", mw:最大宽, mh:最大高, bg:"背景色，不带#" });
//      <a class="up">
//  		<span><i></i>点击此处上传文件，或拖动文件到这里</span>
//  		<div><input class="upinput" type="file" /></div>
//			<h6 class="right" for="up"></h6>
//  	</a>
//      <div>
//  		<strong data-name="01.jpg">×</strong>
//  		<p></p>
//      </div>
		var progress = $("<i>");
		var ret = { value:"", initValue:"" };
		var toolip = $("<h6>").addClass("right").attr("for","up");
        var up = $("<a>").addClass("up").append(
        	$("<span>").html("点击此处上传文件，或拖动文件到这里").prepend(progress)
        ).append(
        	$("<div>").append(
	        	$("<input>").addClass("upinput").attr({
	        		"type":"file",
	        		"accept": obj.accept
	        	}).change(function () {
	        		ret.pic = $(this)[0].files[0];
		            upfile(); //调用上传
		        })
	        )
        ).append(toolip);
        obj.el.append(up); //添加到界面上
        
		//给document绑上事件
    	$(document).on({
            dragleave: function (e) {
                e.preventDefault();
                up.removeClass('highlight');
            },
            drop: function (e) {
                e.preventDefault();
                up.removeClass('highlight1').removeClass('highlight');
            },
            dragenter: function (e) {
                e.preventDefault();
                up.addClass('highlight');
            },
            dragover: function (e) {
                e.preventDefault();
                up.addClass('highlight');
            }
        });
        up.on({
            dragenter: function (e) {
                e.preventDefault();
                $(this).addClass("highlight1");
            },
            dragleave: function (e) {
                e.preventDefault();
                $(this).removeClass('highlight1');
            },
            drop: function (e) {
                e.preventDefault();
                up.removeClass('highlight1').removeClass('highlight');
                var fileList = e.originalEvent.dataTransfer.files; //获取文件列表
                if (fileList.length == 0) //检测是否是拖拽文件到页面的操作
                    return;
                ret.pic = fileList[0];
                upfile(); //调用批量上传
            },
            click: function (e) {
                if (e.target.nodeName == "UL")
                    $(this).find("input").trigger("click");
            }
        });
        
        ret.setValue = function(type,name,url){
        	if(ret.showdiv) ret.showdiv.remove();
            ret.showdiv = $("<div>").append(
            	$("<strong>").attr("data-name", name).click(function(){
            		ret.showdiv.remove();
            		$(".upinput").val("");
            		ret.value = "";
            	})
            );
        	if(type.indexOf("image") > -1)
        		ret.showdiv.append($('<p>').css("background-image", 'url(' + url + ')'));
        	else if(type.indexOf("video") > -1)
        		ret.showdiv.append($('<p>').html('<video src="' + url + '" controls="controls" autoplay="autoplay">请使用IE9以上版本,或谷歌和火狐浏览器</video>'));
        	else
        		ret.showdiv.append($('<p>').html(name).addClass(type.replace("/","_")));
            ret.showdiv.appendTo(obj.el);
        }
        ret.check = function(errstr){
        	if(ret.value != "" || ret.initValue != ""){
	        	toolip.hide();
	        	return true;
        	}
    		toolip.html(errstr).show(); //显示出错误提示来
    		return false;
        }
        var upfile = function () {
        	if($.inArray(ret.pic.type, obj.accept.split(',')) < 0){
        		toolip.html("上传文件格式不正确").show();
        		return;
        	}
        	var reader = new FileReader();
            reader.onload = function (e) {
            	ret.setValue(ret.pic.type, ret.pic.name, this.result);
	            var onprogress = function (evt) {
	                var per = Math.floor(100 * evt.loaded / evt.total);  //已经上传的百分比
	                progress.css("width", per + "%");
	            }
	            var formData = new FormData(); //这样可以给form参数了
	            formData.append("type", ret.pic.type);
	            formData.append("file", ret.pic);
	            if (obj.mh)
	                formData.append("maxheight", obj.mh);
	            if (obj.mw)
	                formData.append("maxwidth", obj.mw);
	            if (obj.bg)
	                formData.append("background", obj.bg);
	            $.ajax({
	                type: "POST",
	                url: "/UpFile.ashx",
	                beforeSend:function (hr) {
	                	if(obj.btn)
	                		obj.btn.attr("disabled","disabled");
	                },
	                data: formData,　　//这里上传的数据使用了formData 对象
	                processData: false,                    
	                contentType: false, //必须false才会自动加上正确的Content-Type 
	                xhr: function () { //这里我们先拿到jQuery产生的 XMLHttpRequest对象，为其增加 progress 事件绑定，然后再返回交给ajax使用
	                    var xhr = $.ajaxSettings.xhr();
	                    if (onprogress && xhr.upload) {
	                        xhr.upload.addEventListener("progress", onprogress, false);
	                        return xhr;
	                    }
	                },
	                success: function (data) {
	                	progress.css("background-color","transparent");
	                	if(obj.btn)
	                		obj.btn.removeAttr("disabled");
	                    if (data == "true"){
	                    	up.find("p").addClass("uped");
	                    	ret.value = ret.pic.name;
	                    }
	                },
	                err: function (err) {
	                	progress.css("background-color","transparent");
	                    alert("错误" + err.responseText);
	                }
	            });
            }
            reader.readAsDataURL(ret.pic);
        }
        return ret;
    }
})();