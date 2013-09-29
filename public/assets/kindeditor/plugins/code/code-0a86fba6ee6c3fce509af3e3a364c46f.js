/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
// google code prettify: http://google-code-prettify.googlecode.com/
// http://google-code-prettify.googlecode.com/
KindEditor.plugin("code",function(e){var t=this,n="code";t.clickToolbar(n,function(){var r=t.lang(n+"."),i=['<div style="padding:10px 20px;">','<div class="ke-dialog-row">','<select class="ke-code-type">','<option value="js">JavaScript</option>','<option value="html">HTML</option>','<option value="css">CSS</option>','<option value="php">PHP</option>','<option value="pl">Perl</option>','<option value="py">Python</option>','<option value="rb">Ruby</option>','<option value="java">Java</option>','<option value="vb">ASP/VB</option>','<option value="cpp">C/C++</option>','<option value="cs">C#</option>','<option value="xml">XML</option>','<option value="bsh">Shell</option>','<option value="">Other</option>',"</select>","</div>",'<textarea class="ke-textarea" style="width:408px;height:260px;"></textarea>',"</div>"].join(""),s=t.createDialog({name:n,width:450,title:t.lang(n),body:i,yesBtn:{name:t.lang("yes"),click:function(n){var r=e(".ke-code-type",s.div).val(),i=o.val(),u=r===""?"":" lang-"+r,a='<pre class="prettyprint'+u+'">\n'+e.escape(i)+"</pre> ";t.insertHtml(a).hideDialog().focus()}}}),o=e("textarea",s.div);o[0].focus()})});