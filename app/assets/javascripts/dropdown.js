$(document).ready(function(){  
	$("#userimg").mouseover(function(){
		if(document.getElementById('downbox').style.display=='none'){
			$("#downbox").css({display:'block'});
     		$("#downbox").animate({height:'+180px'}, "slow");}})   
});  
$("#downbox").click(function(event){
   var e=window.event || event;
   if(e.stopPropagation){
		e.stopPropagation();
	}
	else{
		e.cancelBubble = true;   
}}); 
document.onclick = function(){ 
   	$("#downbox").animate({height:'-180px'}, "slow");
   	$("#downbox").css({display:'none'});
}; 


var key = document.getElementById("input_key_word");
key.onclick = function(){
	if (this.value == "输入餐品或店家")
		this.value = "";
};
key.onblur = function(){
	if (this.value =="")
	   this.value = "输入餐品或店家";
};