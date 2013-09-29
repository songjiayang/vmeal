function avatar() {
	var form_title = "修改个人头像";
	$.layer({
		type : 1,
		title : [form_title, true],
		closeBtn : ['0', true],
		border : [false],
		area : ['auto', 'auto'],
		page : {
			dom : '#avatar'
		}
	});

}

function readURL(input) {
	if (input.files && input.files[0]) {
		var reader = new FileReader();
		reader.onload = function(e) {
			$('#avatar_preview').attr('src', e.target.result).width(180).height(180);
		};
		reader.readAsDataURL(input.files[0]);
		$('.upload_avatar').css({
			"display" : "block"
		});
	}
}

function oprate_addr_form(oprate_type, addr_id) {
	var form_title = "新增送餐地址";
	if (oprate_type == 2) {
		form_title = "修改送餐地址";
		$('#address_id').val(addr_id);
		$('#address_address').val($('#addr_id_' + addr_id).text());
		$('#address_tel_number1').val($('#tel_number1_' + addr_id).text());
		$('#address_tel_number2').val($('#tel_number2_' + addr_id).text());
		$('#address_name').val($('#addr_name_' + addr_id).text());
	}
	$.layer({
		type : 1,
		title : [form_title, true],
		closeBtn : ['0', true],
		border : [false],
		area : ['auto', 'auto'],
		page : {
			dom : '#addr_form'
		}
	});

}

function vidate_input() {
	var addr_input = $('#address_address').val().trim();
	var tel_1 = $('#address_tel_number1').val().trim();
	var tel_2 = $('#address_tel_number2').val().trim();
	var addr_name = $('#address_name').val().trim();
	var input_is_ok = true;

	if (addr_input.length < 8) {
		$('#input_addr_error').text("送餐地址不能小于8个字符");
		input_is_ok = false;
	} else {
		$('#input_addr_error').html("&nbsp;");
	}

	if (tel_1.length == 0) {
		$('#input_tel_error').text("送餐联系电话不能为空");
		input_is_ok = false;
	} else if (/^(?:13\d|15\d|18\d)-?\d{5}(\d{3}|\*{3})$/.test(tel_1) == false) {
		$('#input_tel_error').text("请输入正确手机号码格式");
		input_is_ok = false;
	} else {
		$('#input_tel_error').html("&nbsp;");
	}

	if (tel_2.length > 0 && /^(?:13\d|15[89]|189)-?\d{5}(\d{3}|\*{3})$/.test(tel_2) == false) {
		$('#input_tel_2_error').text("请输入正确手机号码格式");
		input_is_ok = false;
	} else {
		$('#input_tel_2_error').html("&nbsp;");
	}

	if (addr_name.length == 0) {
		$('#input_name_error').text("收餐人姓名不能为空");
		input_is_ok = false;
	} else if (addr_name.length < 2) {
		$('#input_name_error').text("收餐人姓名不能小于2个字符");
		input_is_ok = false;
	} else {
		$('#input_name_error').html("&nbsp;");
	}
	return input_is_ok;
}

function reset_error_messages() {
	$('#input_addr_error').html("&nbsp;");
	$('#input_tel_error').html("&nbsp;");
	$('#input_tel_2_error').html("&nbsp;");
	$('#input_name_error').html("&nbsp;");
}

function show_order_detail(order_id) {
	$.layer({
		type : 2,
		title : ['订单详情', true],
		iframe : {
			src : '/stores/order_details?order_id=' + order_id
		},
		area : ['500px', '400px']
	});
}

function comment_order(index_dom,order_id) {
	$('#orderid').val(order_id);
	$.layer({
		fix : true,
		type : 1,
		title : ["订单评论", true],
		closeBtn : ['0', true],
		border : [10, 0.1, '#000', false],
		area : ['auto', 'auto'],
		page : {
			dom : index_dom
		}
	});

}

function read_mail(index_dom,mail_id) {
	htmlobj = $.ajax({
		url : "/users/read_mail?id=" + mail_id,
		async : false
	});
	$('#read_content').html(htmlobj.responseText);
	$.layer({
		type : 1,
		title : ["阅读站内信", true],
		closeBtn : ['0', true],
		border : [false],
		area : ['500px', 'auto'],
		page : {
			dom : index_dom
		}
	});
}