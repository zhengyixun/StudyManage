;
(function() {
	$.area = function(obj){
		$('head').prepend($("<script>").attr({
			type:"text/javascript",
			src:"js/area.ashx"
		}))  
//		<select id="area">
//          <option value="">无</option>
//      </select>
//      <select id="city"></select>
//      <select id="zone"></select>
//		<h6 class="right" for="zone">请选择</h6>
		var _area = $("<select>").attr("id","area");
		var _city = $("<select>").attr("id","city");
		var _zone = $("<select>").attr("id","zone");
		if(obj.disabled){
			if(myarea != "") _area.attr("disabled","disabled");
			if(mycity != "") _city.attr("disabled","disabled");
			if(myzone != "") _zone.attr("disabled","disabled");
		}
		if(obj.real_disabled){
			_area.attr("disabled","disabled");
			_city.attr("disabled","disabled");
			_zone.attr("disabled","disabled");
		}
		
		var ret = {};
		$.ajax_({
			method:"getArea",
			data:{ area:myarea },
			success:function(data){
				var ary_area = JSON.parse(data.d);
				$.each(ary_area, function(i,val){
					_area.append('<option value="' + val.id + '">' + val.name + '</option>');
				});
				if(obj.selectall != undefined)
            		_area.prepend('<option value="">' + obj.selectall + '</option>');
				if(obj.area != undefined)
					_area.val(obj.area);
				_area.trigger("change");
			}
		});
		_area.change(function(){
			if($(this).val() != ""){
				var id = $(this).val();
				$.ajax_({
					method:"getCity",
					data:{ id: $(this).val() },
					success:function(data){
						var ary_city = JSON.parse(data.d);
						_city.empty();
						$.each(ary_city, function(i,val){
							_city.append('<option value="' + val.id + '">' + val.name + '</option>');
						});
						if(obj.selectall != undefined)
                    		_city.prepend('<option value="' + id + '">' + obj.selectall + '</option>');
						if(obj.city != undefined)
							_city.val(obj.city);
						_city.trigger("change");
					}
				});
			} else
				_city.empty();
		});
		_city.change(function(){
			var id = $(this).val();
			if(id != "" && id != null){
				if(id.length == 4)
					$.ajax_({
						method:"getZone",
						data:{ id: $(this).val() },
						success:function(data){
							var ary_zone = JSON.parse(data.d);
							_zone.empty();
							if(obj.selectall != undefined)
	                    		_zone.append('<option value="' + id + '">' + obj.selectall + '</option>');
							$.each(ary_zone, function(i,val){
								_zone.append('<option value="' + val.id + '">' + val.name + '</option>');
							});
							if(obj.zone != undefined)
								_zone.val(obj.zone);
						}
					});
				else //选了全部
					_zone.empty();
			} else
				_zone.empty();
		});
		ret.getValue = function(){
			ret.area = _area.val() || "";
			ret.city = _city.val() || "";
			ret.zone = _zone.val() || "";
			return ret;
		}
		obj.el.data("area", ret).append(_area).append(_city).append(_zone); //添加到界面上
		if(obj.tooltip)
			obj.el.append($("<h6>").addClass("right").attr("for","zone").html(obj.tooltip));
		//return ret;
	}
})();