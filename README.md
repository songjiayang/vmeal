Vmeal
=====================
***一个在线订餐平台，店家可以在这里开店，用户可以购买商品.***
演示地址: www.weidaxue.me
备注：代码由于是刚学rails的时候编写的，所以有很多地方可以重构，由于时间和精力有限，暂不会进行大面积的重构。

###为什么开源###
1. 创业项目失败。
2. 代码是在学习rails的时候书写，很多参考了`web开发敏捷之道`一书,故回馈社区。
3. 希望此系统能够维持下去，哪怕有一个人用，我们也会很开心，有兴趣的朋友可以一起讨论研究，学习进步。


###项目依赖###

1. ruby(1.9.x) + rails(3.2.x)
2. redis
3. mysql


###如何启动#####
1. clone代码 `git clone git@github.com:dianrui/vmeal.git`
2. 修改配置文件（database.yml）
3. 执行bundle命令 `bundle `
4. 启动redis
5. 执行 `rake db:create`
6. 执行 `rake db:schema:load`
7. 执行 `rake db:seed`
8. 执行 `rails s`

然后访问 [http://localhost:3000/](http://localhost:3000/) ,如果不出意外，你将看到类似如下页面
![首页图片](http://img.my.csdn.net/uploads/201309/30/1380475435_9672.png)

###有哪些功能#####

1. 商家在线开店
2. 商家自主管理自己的店
3. 用户可以在线订餐
4. 订单实时推送
5. 订单状态短信提醒
6. 签到系统
7. 抽奖系统
8. 积分系统
9. 第三方登录和分享
......

###核心开发人员#####
1. [songjiayang](https://github.com/songjiayang)
2. [yinchangxin](https://github.com/YinChangXin)
3. [renkai](https://github.com/Ailenswpu)
4. [tuxiaozhong](https://github.com/tuoxiaozhong)
5. [zhaohang]()


###问题反馈###
https://github.com/dianrui/vmeal/issues

###License###
[GNU Affero GPL 3](http://www.gnu.org/licenses/agpl-3.0.html)







