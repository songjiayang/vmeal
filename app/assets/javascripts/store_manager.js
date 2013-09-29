//= require jquery_ujs
//= require jquery.min
//= require layer.min

function show_box_with_frame(title,index_dom,y_location,x_location,width,height) {
	$.layer({
		type : 1,
		title : [title, true],
		closeBtn : ['0', true],
		border : [false],
		area : [width, height],
		page : {
			dom : index_dom
		},
		offset: [y_location,x_location]
	});
}

function show_storeinfo(index_dom) {
	show_box_with_frame("时间段设置",index_dom,"200px",'380px','auto','auto');
}

function reply_comment(index_dom, message_id) {
	show_box_with_frame("回复",index_dom,"250px",'380px','auto','auto');
	$("#reply_message_id").val(message_id);
}

function requry_reply(index_dom, message_id) {
	show_box_with_frame("查看评论",index_dom,"250px",'380px','auto','auto');
	htmlobj = $.ajax({
		url : "/reply/" + message_id,
		async : false
	});
	$("#message_cotent").html(htmlobj.responseText);
}

function requery_food(index_dom, food_id) {
	htmlobj = $.ajax({
		url : "/foods/" + food_id,
		async : false
	});
	food = jQuery.parseJSON(htmlobj.responseText);
	$('#foodname').val(food.name);
	$('#foodprice').val(food.price);
	$('#foodtag').val(food.tag);
	$('#foodsum').val(food.sum);
	$('#foodenergy').val(food.energy);
	$('#foodsales').val(food.sales);
	$('#foodingredients').val(food.ingredients);
	$('#foodsenttime').val(food.sent_time);
	$('#foodid').val(food_id);
	show_box_with_frame("更新菜单",index_dom,"30px",'50%','auto','700px');
}

function food_edit(index_dom) {
	show_box_with_frame("添加菜品",index_dom,"30px",'50%','auto','550px');
}

function category_edit(index_dom, title) {
	show_box_with_frame(title,index_dom,"200px",'500px','auto','auto');
}

function requery_category(index_dom, category_id) {
	htmlobj = $.ajax({
		url : "/categories/" + category_id,
		async : false
	});
	category = jQuery.parseJSON(htmlobj.responseText);
	$('#categoryname').val(category.name);
	$('#categoryvalue').val(category.sortvalue);
	$('#categoryid').val(category_id);
  show_box_with_frame("更新菜单类别",index_dom,"250px",'auto','auto','auto');
}

function apply_fail_comment(index_dom, order_id) {
	$('#order_id').val(order_id);
	show_box_with_frame("申请弃单",index_dom,"100px",'auto','auto','auto');
}

function apply_recomment(index_dom, food_id) {
	$('#recomment_food_id').val(food_id);
	show_box_with_frame("店长推荐菜",index_dom,"100px",'auto','auto','auto');
}


function show_order_detail(order_id,type){
	$.layer({
	     type : 2,
	     title : ['订单详情',true],
	     border : [false],
	     iframe : {
	     		src : '/stores/order_details?order_id='+order_id+"&type="+type
	     },	
	     area : ['500px','400px'],
     });
}

function ajax_category(index_dom, category_id) {
	htmlobj = $.ajax({url : "/categories/" + category_id,async : false});
	category = jQuery.parseJSON(htmlobj.responseText);
	$('#categoryname').val(category.name);
	$('#categoryvalue').val(category.sortvalue);
	$('#categoryid').val(category_id);
	show_box_with_frame("更新菜单类别",index_dom,'','','auto','auto');
}
