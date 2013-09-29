/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author Roddy <luolonghao@gmail.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
KindEditor.plugin("autoheight",function(e){var t=this;if(!t.autoHeightMode)return;var n=t.edit,r=n.doc.body,i=e.removeUnit(t.height);n.iframe[0].scroll="no",r.style.overflowY="hidden",n.afterChange(function(){t.resize(null,Math.max((e.IE?r.scrollHeight:r.offsetHeight)+62,i))})});