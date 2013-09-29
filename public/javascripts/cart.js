var flage = 0;
function eat_function() {
	var food_id = arguments[0];
	var store_id = arguments[1];
	var food_price = arguments[2];
	var store_name = arguments[3];
	var food_name = arguments[4];
	var send_price = arguments[5];
	$.ajax({
		type : "POST",
		url : "/line_items",
		beforeSend : function(xhr) {
			xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
		},
		data : {
			food_id : food_id
		},
		dataType : "json",
		success : function(data) {
			var line_item_id = data.id;
			if ($("#store_cart_" + store_id).length > 0) {
				if ($("#food_cart_" + line_item_id).length > 0) {
					var food_number = parseInt($("#number_" + line_item_id).text());
					var food_tatal = parseFloat($("#total_" + line_item_id).text());
					var tatal_food_price = parseFloat($("#cart_total_" + store_id).text());

					$("#number_" + line_item_id).text(food_number + 1);
					$("#total_" + line_item_id).text(food_tatal + parseFloat(food_price));
					$("#cart_total_" + store_id).text(tatal_food_price + parseFloat(food_price));
					$("#total_price_cart").text(parseFloat($("#total_price_cart").text()) + parseFloat(food_price));
				} else {
					$("#cart_number" + store_id).attr("value", parseInt($("#cart_number" + store_id).attr("value")) + 1);
					var content = '<li id="food_cart_' + line_item_id + '" class="ordering_floatbill_line"><div class="ordering_floatbill_line_name">' + food_name + '</div><div class="ordering_floatbill_line_eachprice"><input value="' + food_price + '" id="price_' + line_item_id + '" type="hidden" /><span id="total_' + line_item_id + '">' + food_price + '</span>元</div><div class="ordering_floatbill_line_number"><span id="number_' + line_item_id + '">1</span>份</div><div class="ordering_floatbill_line_contol" id="food_id_' + food_id + '"><input onclick="cut_line_item(' + line_item_id + ',' + store_id + ')" type="button" value=""  class="ordering_floatbill_button1"/><input onclick="add_line_item(' + line_item_id + ',' + store_id + ')" type="button" value="" class="ordering_floatbill_button2" /><input onclick="delet_line_item(' + line_item_id + ',' + store_id + ')" type="button"  class="ordering_floatbill_button3" /></div></li>';
					$("#cart_total_" + store_id).text(parseFloat($("#cart_total_" + store_id).text()) + parseFloat(food_price));
					$("#total_price_cart").text(parseFloat($("#total_price_cart").text()) + parseFloat(food_price));
					$("#store_li_" + store_id).after(content);
				}
			} else {
				$("#shoping_car_num").attr("value", parseInt($("#shoping_car_num").attr("value")) + 1);
				$("#total_price_cart").text(parseFloat($("#total_price_cart").text()) + parseFloat(food_price));
				var conten = '<div id="add_food_' + store_id + '"><div id="store_cart_' + store_id + '" class="ordering_floatbill_titleline">' + store_name + '</div>';
				var content = '<li id="store_li_' + store_id + '" class="ordering_floatbill_line"><div class="ordering_floatbill_line_name">菜名</div><div class="ordering_floatbill_line_eachprice">小计</div><div class="ordering_floatbill_line_number">份数</div><div class="ordering_floatbill_line_contol">操作</div></li><input value="1" id="cart_number' + store_id + '" type="hidden" /><div id="add_food_' + store_id + '">';
				var content1 = '<li id="food_cart_' + line_item_id + '" class="ordering_floatbill_line"><div class="ordering_floatbill_line_name">' + food_name + '</div><div class="ordering_floatbill_line_eachprice"><input value="' + food_price + '" id="price_' + line_item_id + '" type="hidden" /><span id="total_' + line_item_id + '">' + food_price + '</span>元</div><div class="ordering_floatbill_line_number"><span id="number_' + line_item_id + '">1</span>份</div><div class="ordering_floatbill_line_contol" id="food_id_' + food_id + '">';
				content1 = content1 + '<input onclick="cut_line_item(' + line_item_id + ',' + store_id + ')" type="button" value="" class="ordering_floatbill_button1"/>';
				content1 = content1 + '<input onclick="add_line_item(' + line_item_id + ',' + store_id + ')" type="button" value="" class="ordering_floatbill_button2" />';
				content1 = content1 + '<input onclick="delet_line_item(' + line_item_id + ',' + store_id + ')" type="button" value="" class="ordering_floatbill_button3" /></div></li>';
				var content2 = '</div><div id="op_' + store_id + '"><div class="ordering_floatbill_total"><div class="ordering_floatbill_left" id="cart_num_' + store_id + '">合计<span id="cart_total_' + store_id + '">' + food_price + '</span>元</div>';
				content2 = content2 + '<div class="ordering_floatbill_right"><input type="button" onclick="clearcart(' + line_item_id + ',' + store_id + ')" class="ordering_floatbill_creatbill" value="清空" /><input class="ordering_floatbill_creatbill" onclick="hrefurl(' + line_item_id + ')" type="button" value="下单" /></a></div></div>';
				conten = conten + content;
				conten = conten + content1;
				conten = conten + content2 + "</div>";
				$("#shopingcart").append(conten);
			}
			$("#cart_nil").remove();
			if (flage == 0) {
				flage = 1;
				openWindow();
			};

		},
		error : function(data) {

		}
	});

}

