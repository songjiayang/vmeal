// JavaScript Document
//获取窗口的高度  
var windowHeight;  
//获取窗口的宽度  
var windowWidth;  
//获取弹窗的宽度  
var popWidth;  
//获取弹窗高度  
var popHeight;  

function init(){  
  windowHeight=$(window).height();  
   windowWidth=$(window).width();  
   popHeight=$(".login_window").height();  
   popWidth=$(".login_window").width();  
}  
//关闭窗口的方法  
function closeWindow(){  
    $("#closeimg").click(function(){  
        $("#center").fadeOut("fast");
		document.getElementById('popIframe').style.display='none';
		document.getElementById('bg').style.display='none'; 
        });  

   }  
	
    //定义弹出居中窗口的方法  
function popCenterWindow(){  
     init();  
        //计算弹出窗口的左上角Y的偏移量
	document.getElementById('popIframe').style.display='block';
	document.getElementById('bg').style.display='block'; 
    var popY=(windowHeight-popHeight)/2-20;  
    var popX=(windowWidth-popWidth)/2;  
    //alert(popY);  
    //设定窗口的位置  
    $("#center").css("top",popY).css("left",popX).fadeToggle("normal");  

    closeWindow();  
    }


var a;
	document.onmouseup=function(){
		if(!a)return;
		document.all?a.releaseCapture():window.captureEvents(Event.MOUSEMOVE|Event.MOUSEUP);a="";
		};
	document.onmousemove=function (d){
		if(!a)return;if(!d)d=event;a.style.left=(d.clientX-b)+"px";a.style.top=(d.clientY-c)+"px";};
		
	function move(o,e){
		a=o;
		document.all?a.setCapture():window.captureEvents(Event.MOUSEMOVE);
		b=e.clientX-parseInt(a.style.left);
		c=e.clientY-parseInt(a.style.top);
		}

