
//关闭窗口的方法  
function closeWindow(){  
		$("#floatbill").animate({width:'-313px'}, "slow").slideUp("fast"); 
   }  
   
function openWindow(){ 
	$("#floatbill").slideToggle("fast").animate({width:'+313px'}, "slow"); 
	$("#floatbill_main").slideDown("fast");
}


