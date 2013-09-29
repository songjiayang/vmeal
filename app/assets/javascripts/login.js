function dk () {
  $("#layer_num").attr("value",parseInt($("#layer_num").attr("value"))+1);
	$.layer({
		type : 1,
	 	title : ['',false],
	 	closeBtn : ['0',false],
	 	border : [false],
	 	area : ['auto','auto'],
	 	page : {dom : '#login'}
	});
}

function avatar () {
	$.layer({
	 	type : 1,
	 	title : ['',false],
	 	closeBtn : ['0',false],
	 	border : [false],
	 	area : ['auto','auto'],
	 	page : {dom : '#avatar'}
	});
}

function show_msg () {
	$.layer({
	 	type : 1,
	 	title : ['',false],
	 	closeBtn : ['0',true],
	 	border : [false],
	 	area : ['auto','auto'],
	 	page : {dom : '#show_msg'}
	});
}

