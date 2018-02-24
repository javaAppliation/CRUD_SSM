<%--
  Created by IntelliJ IDEA.
  User: lishengyu
  Date: 2018/2/9
  Time: 下午10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>用户列表</title>
    <%
        pageContext.setAttribute("APP_PATH", request.getContextPath());
    %>
    <!--不以/开始的相对路径，找资源，以当前资源的路径为基准
        以/开始的相对路径，找资源以服务器的路径为标准（http://localhost:3306）/testmaven
    -->

    <!--引入jqury-->
    <script type="text/javascript" src="${APP_PATH}/static/js/jquery-1/jquery-1.12.4.min.js"></script>
    <!--引入bootstrap样式-->
    <script src="${APP_PATH}/static/bootstrap-3.3.7-dist/js/bootstrap.min.js"></script>
    <link href="${APP_PATH}/static/bootstrap-3.3.7-dist/css/bootstrap.min.css" rel="stylesheet">

</head>
<body>

<!-- 员工修改模态框 -->
<div class="modal fade" id="userUpdate" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" >用户修改</h4>
            </div>
            <div class="modal-body">
                <%--表单--%>
                <form class="form-horizontal">
                    <div class="form-group">
                        <label class="col-sm-2 control-label">id</label>
                        <div class="col-sm-2">
                            <p class="form-control-static" id="staticText">

                            </p>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputUsername" class="col-sm-2 control-label">用户名</label>
                        <div class="col-sm-10">
                            <input type="text" name="username" class="form-control" id="inputUsername_update" placeholder="LSY">
                            <span class="help-block"></span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="inputPassword" class="col-sm-2 control-label">密码</label>
                        <div class="col-sm-10">
                            <input type="password" name="password" class="form-control" id="inputPassword_update" placeholder="********">
                            <span class="help-block"></span>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="userUpdate_Btn">更新</button>
            </div>
        </div>
    </div>
</div>


<!-- 员工添加模态框 -->
<div class="modal fade" id="userAdd" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">用户添加</h4>
            </div>
            <div class="modal-body">
                <%--表单--%>
                    <form class="form-horizontal">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">id</label>
                            <div class="col-sm-2">
                                <select class="form-control" name="id" id="select">

                                </select>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputUsername" class="col-sm-2 control-label">用户名</label>
                            <div class="col-sm-10">
                                <input type="text" name="username" class="form-control" id="inputUsername" placeholder="LSY">
                                <span class="help-block"></span>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="inputPassword" class="col-sm-2 control-label">密码</label>
                            <div class="col-sm-10">
                                <input type="password" name="password" class="form-control" id="inputPassword" placeholder="********">
                                <span class="help-block"></span>
                            </div>
                        </div>
                    </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button type="button" class="btn btn-primary" id="userSave_Btn">保存</button>
            </div>
        </div>
    </div>
</div>

<div class="container">
    <!--标题行-->
    <div class="row">
        <div class=".col-md-12">
            <h1>SSM-CRUD</h1>
        </div>
    </div>
    <!--按钮-->
    <div class="row">
        <div class="col-md-4 col-md-offset-8">
            <button class="btn btn-primary" id="userAdd_Btn">新增</button>
            <button class="btn btn-danger" id="usersDel_Btn">删除</button>
        </div>
    </div>
    <!--表格数据-->
    <div class="row">
        <div class=".col-md-12">
            <table class="table table-hover" id="user_table">
                <thead>
                <tr>
                    <th><input type="checkbox" id="check_all"/></th>
                    <th>id</th>
                    <th>username</th>
                    <th>password</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>

                </tbody>
            </table>
        </div>
    </div>
    <!--分页信息-->
    <div class="row">
        <!--分页文字信息-->
        <div class="col-md-6" id="page_info_area">

        </div>
        <!--分页条信息-->
        <div class="col-md-6" id="page_Nav_area">

        </div>
    </div>
</div>
<script type="text/javascript">
    //页面加载完成以后，直接去发送一个ajax请求，要到分页数据
    $(function () {
        to_Page(1);
    });

    var currentPage;
    function to_Page(pn) {
        $.ajax({
            url: "${APP_PATH}/List",
            data: "pn="+pn,
            type: "GET",
            success: function (result) {
                console.log(result);
                //解析显示用户数据
                build_user_table(result);
                //解析显示分页信息
                build_page_info(result);
                //解析显示分页条数据
                build_page_nav(result);
                //获取用户数，并传入模态窗口
                getUserId(result);
            }
        });
    }
    //分页的数据
    function build_user_table(result) {
        //清空table数据
        $("#user_table tbody").empty();
        var users=result.extend.PageInfo.list;
        $.each(users,function (index,item) {
            var checkBoxItem=$("<td><input type=\"checkbox\" class=\"check_item\"/></td>");
            var userId=$("<td></td>").append(item.id);
            var username=$("<td></td>").append(item.username);
            var password=$("<td></td>").append(item.password);

            var delBtn=$("<button></button>").addClass("btn btn-danger btn-sm delBtn").append($("<span></span>").addClass("glyphicon glyphicon-trash")).append("删除");
            delBtn.attr("delId",item.id);
            var editBtn=$("<button></button>").addClass("btn btn-primary btn-sm editBtn").append($("<span></span>").addClass("glyphicon glyphicon-wrench")).append("修改");
            editBtn.attr("editId",item.id);
            //append方法执行完后还是返回原来的元素
            $("<tr></tr>").append(checkBoxItem).append(userId).append(username).append(password).append(editBtn).append(delBtn).appendTo("#user_table tbody");
        })

    }
    //分页信息
    function build_page_info(result) {
        //清空
        $("#page_info_area").empty();
        $("#page_info_area").append("当前"+result.extend.PageInfo.pageNum+"页,总共"+result.extend.PageInfo.pages+"页,总共"+result.extend.PageInfo.total+"条记录");
        currentPage=result.extend.PageInfo.pageNum;

    }
    //分页条
    function build_page_nav(result) {
        //清空
        $("#page_Nav_area").empty();
        var ul=$("<ul></ul>").addClass("pagination")
        var firstPageLi=$("<li></li>").append($("<a></a>").append("首页").attr("href","#"));
        var prePageLi=$("<li></li>").append($("<a></a>").append("&laquo;"));
        if(result.extend.PageInfo.hasPreviousPage==false){
            prePageLi.addClass("disabled");
            firstPageLi.addClass("disabled");
        }else {
            firstPageLi.click(function () {
                to_Page(1);
            });
            prePageLi.click(function () {
                to_Page(result.extend.PageInfo.pageNum-1);
            });
        }
        var lastPageLi=$("<li></li>").append($("<a></a>").append("末页").attr("href","#"));
        var nextPageLi=$("<li></li>").append($("<a></a>").append("&raquo;"));
        if(result.extend.PageInfo.hasNextPage==false){
            lastPageLi.addClass("disabled");
            nextPageLi.addClass("disabled");
        }else {
            lastPageLi.click(function () {
                to_Page(result.extend.PageInfo.pages);
            });
            nextPageLi.click(function () {
                to_Page(result.extend.PageInfo.pageNum+1);
            });
        }
        //显示首页和上一页
        ul.append(firstPageLi).append(prePageLi);
        //遍历显示五页信息
        $.each(result.extend.PageInfo.navigatepageNums,function (index,item) {
            var numLi=$("<li></li>").append($("<a></a>").append(item));
            if(result.extend.PageInfo.pageNum==item){
                numLi.addClass("active");
            }
            numLi.click(function () {
                to_Page(item);
            });
            ul.append(numLi);
        });
        //显示下一页末页
        ul.append(nextPageLi).append(lastPageLi);
        var navEle=$("<nav></nav>").append(ul);
        navEle.appendTo("#page_Nav_area");
    }
    //清空表单数据及表单状态的方法
    function reset_form(ele) {
        //重置表单内容
        $(ele)[0].reset();
        //重置表单状态
        $(ele).find("*").removeClass("has-success has-error");
        $(ele).find(".help-block").text("");
    }
    //新增按钮弹出模态框
    $("#userAdd_Btn").click(function () {
        reset_form("#userAdd form");
        //$("#userAdd form")[0].reset();
        $("#userAdd").modal({
            backdrop:"static"
        });
    });
    //取出用户人数
    function getUserId(result) {
        //清空
        $("#select").empty();
        var id=result.extend.PageInfo.total+1;
        $("<option></option>").append(id).attr("value",id).appendTo("#userAdd select");
    }
    //抽取方法进行数据清除
    function show_validate_msg(ele,status,msg) {
        //清除当前元素的校验状态
        $(ele).parent().removeClass("has-success has-error");
        $(ele).next("span").text("");
        if("success"==status){
            $(ele).parent().addClass("has-success");
            $(ele).next("span").text(msg);

        }else if ("error"==status){
            $(ele).parent().addClass("has-error");
            $(ele).next("span").text(msg);
        }
    }
    //校验的方法
    function validate_add() {
            //拿到数据，正则表达式进行校验
            var username=$("#inputUsername").val();
            var reg=/^[a-zA-Z0-9]{1,8}$/;
            var password=$("#inputPassword").val();
            //校验用户名
            if(!reg.test(username)){
                //alert("用户名为1-8位字母或数字");
                show_validate_msg("#inputUsername","error","用户名为1-8位字母或数字");
                return false;
            }else {
                show_validate_msg("#inputUsername","success","");
            }
            //校验密码
            if(!reg.test(password)){
                //alert("密码为1-8位字母或数字");
                show_validate_msg("#inputPassword","error","密码为1-8位字母或数字");
                return false;
            }else {
                show_validate_msg("#inputPassword","success","");
            }
            return true;
    }

    //校验用户名是否已存在于数据库
    $("#inputUsername").change(function () {
        var username=this.value;
        //发送ajax请求，校验用户名是否可用
        $.ajax({
            url:"${APP_PATH}/checkuser",
            data:"username="+username,
            type:"POST",
            success:function (result) {
                if(result.code==1){
                    $("#userSave_Btn").attr("ajax_va","success");
                    show_validate_msg("#inputUsername","success","用户名可用");
                }else {
                    show_validate_msg("#inputUsername","error",result.extend.va_msg);
                    $("#userSave_Btn").attr("ajax_va","error");
                }
            }
        });

    });

    //用户保存按钮的触发事件
    $("#userSave_Btn").click(function () {
        //对表单数据进行校验对方法
        if(!validate_add()){
            return false;
        }
        //ajax校验用户名是否成功
        if($(this).attr("ajax_va")=="error"){
            return false;
        }
        $.ajax({
            url:"${APP_PATH}/user",
            type:"POST",
            data:$("#userAdd form").serialize(),
            success:function (result) {
                if(result.code==1){
                    //关闭模态框
                    $("#userAdd").modal('hide');
                    //显示最后一页
                    to_Page(99999);
                }else {
                    //console.log(result);
                    //有哪个字段的错误信息就显示哪个字段
                    if(undefined!=result.extend.errorFields.username){
                        //显示用户名的错误信息
                        show_validate_msg("#inputUsername","error",result.extend.errorFields.username);
                    }
                    if(undefined!=result.extend.errorFields.password){
                        //显示密码的错误信息
                        show_validate_msg("#inputpassword","error",result.extend.errorFields.password);
                    }
                }
            }

        });
    });




    /**
     * 修改按钮与新增按钮不一样，不能绑click（创建按钮之前就绑定无法生效）
     * 绑定.live(),jquery新版用on代替
     */
    $(document).on("click",".editBtn",function () {
        //把id传递给模态框的更新按钮
        $("#userUpdate_Btn").attr("editid",$(this).attr("editId"));
        //查出用户信息
        $("#userUpdate").modal({
            backdrop:"static"
        });
        getUser($(this).attr("editId"));
    });
    //发ajax请求根据id获取用户信息
    function getUser(id) {
        $.ajax({
            url:"${APP_PATH}/userWithId/"+id,
            type:"GET",
            success:function (result) {
                var userData=result.extend.user;
                $("#staticText").text(userData.id);
                $("#inputUsername_update").val(userData.username);
                $("#inputPassword_update").val(userData.password);
            }
        });
    }
    //更新用户信息保存按钮的触发事件
    $("#userUpdate_Btn").click(function () {
        //拿到数据，正则表达式进行校验
        var username=$("#inputUsername_update").val();
        var reg=/^[a-zA-Z0-9]{1,8}$/;
        var password=$("#inputPassword_update").val();
        if(!reg.test(username)){
            show_validate_msg("#inputUsername_update","error","用户名为1-8位字母或数字");
            return false;
        }else {
            show_validate_msg("#inputUsername_update","success","");
        }
        if(!reg.test(password)){
            //alert("密码为1-8位字母或数字");
            show_validate_msg("#inputPassword_update","error","密码为1-8位字母或数字");
            return false;
        }else {
            show_validate_msg("#inputPassword_update","success","");
        }
        //发送ajax请求，保存用户信息
        $.ajax({
            url:"${APP_PATH}/user/"+$(this).attr("editId"),
            type:"PUT",
            data:$("#userUpdate form").serialize(),
            success:function (result) {
               //关闭模态框
                $("#userUpdate").modal("hide");
                //并回到本页面
                to_Page(currentPage);
            }
        });
    });




    //单个用户删除按钮绑单机事件
    $(document).on("click",".delBtn",function(){
        //弹出确认删除对话框
        var username=$(this).parents("tr").find("td:eq(1)").text();

        if(confirm("确认删除"+username+"吗？")){
            //确认后发送ajax请求
            $.ajax({
                url:"${APP_PATH}/user/"+$(this).attr("delId"),
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    to_Page(currentPage);
                }
            });
        }

    })


    //删除多个用户
    $("#usersDel_Btn").click(function () {
        //找到被选中的用户名字，遍历
        var username="";
        var id="";
        $.each($(".check_item:checked"),function () {
            //alert($(this).parents("tr").find("td:eq(2)").text());
            //组装用户名的字符串
            username+=$(this).parents("tr").find("td:eq(2)").text()+",";
            //组装用户id的字符串
            id+=$(this).parents("tr").find("td:eq(1)").text()+"-"
        });
        //去除最后的，
        ids_str=id.substring(0,id.length-1);
        username=username.substring(0,username.length-1);
        if(confirm("确认删除"+username+"吗？")){
            //发送ajax请求，删除
            $.ajax({
                url:"${APP_PATH}/user/"+ids_str,
                type:"DELETE",
                success:function (result) {
                    alert(result.msg);
                    to_Page(currentPage);
                }
            });
        }
    });


    //checkbox全选和全不选
    $("#check_all").click(function () {
        //attr获取自定义的属性，prop获取原生属性
        $(".check_item").prop("checked",$(this).prop("checked"));
    });
    $(document).on("click",".check_item",function () {
        //判断当前选中元素是否等于总个数
        var flag=$(".check_item:checked").length==$(".check_item").length;
        $("#check_all").prop("checked",flag);
    })
</script>
</body>
</html>
