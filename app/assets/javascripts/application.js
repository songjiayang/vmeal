// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery_ujs
//= require layer.min
//= require login
//= require dropdown
//= require top

function check_my_cart() {
	alert($("#user_loged").html);
}

function follow_store(store_id) {
	htmlobj = $.ajax({
		url : "/stores/add_fav_store?store_id=" + store_id,
		async : false
	});
	//$("#store-fllow").text(htmlobj.responseText);
	$(".resinfo_right_like").html("<a id='store-unfllow' href='javascript:void(0)' onclick='cancel_follow_store("+store_id+")'>"+htmlobj.responseText+"</a><p>点击取消收藏：</p>")
}

function cancel_follow_store(store_id) {
	htmlobj = $.ajax({
		url : "/stores/cancel_fav_store?store_id=" + store_id,
		async : false
	});
	//$("#store-unfllow").text(htmlobj.responseText);
	$(".resinfo_right_like").html("<a id='store-fllow' href='javascript:void(0)' onclick='follow_store("+store_id+")'>"+htmlobj.responseText+"</a><p>喜欢就收藏我：</p>")
}
