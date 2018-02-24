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
            <button class="btn btn-primary">新增</button>
            <button class="btn btn-danger">删除</button>
        </div>
    </div>
    <!--表格数据-->
    <div class="row">
        <div class=".col-md-12">
            <table class="table table-hover">
                <tr>
                    <th>id</th>
                    <th>username</th>
                    <th>password</th>
                    <th>操作</th>
                </tr>
                <c:forEach items="${PageInfo.list}" var="user">
                    <tr>
                        <th>${user.id}</th>
                        <th>${user.username}</th>
                        <th>${user.password}</th>
                        <th>
                            <button class="btn btn-primary btn-sm">
                                <span class="glyphicon glyphicon-wrench" aria-hidden="true"></span>
                                修改
                            </button>
                            <button class="btn btn-danger btn-sm">
                                <span class="glyphicon glyphicon-trash" aria-hidden="true"></span>
                                删除
                            </button>
                        </th>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
    <!--分页信息-->
    <div class="row">
        <!--分页文字信息-->
        <div class="col-md-6">
            当前${PageInfo.pageNum}页,总共${PageInfo.pages}页,总共${PageInfo.total}条记录
        </div>
        <!--分页条信息-->
        <div class="col-md-6">
            <nav aria-label="Page navigation">
                <ul class="pagination">
                    <li><a href="${APP_PATH}/List?pn=1">首页</a></li>
                    <c:if test="${PageInfo.hasPreviousPage}">
                        <li>
                            <a href="${APP_PATH}/List?pn=${PageInfo.pageNum-1}" aria-label="Previous">
                                <span aria-hidden="true">&laquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <c:forEach items="${PageInfo.navigatepageNums}" var="page">
                        <c:if test="${page==PageInfo.pageNum}">
                            <li class="active"><a href="#">${page}</a></li>
                        </c:if>
                        <c:if test="${page!=PageInfo.pageNum}">
                            <li><a href="${APP_PATH}/List?pn=${page}">${page}</a></li>
                        </c:if>
                    </c:forEach>
                    <c:if test="${PageInfo.hasNextPage}">
                        <li>
                            <a href="${APP_PATH}/List?pn=${PageInfo.pageNum+1}" aria-label="Next">
                                <span aria-hidden="true">&raquo;</span>
                            </a>
                        </li>
                    </c:if>
                    <li><a href="${APP_PATH}/List?pn=${PageInfo.pages}">末页</a></li>
                </ul>
            </nav>
        </div>
    </div>
</div>
</body>
</html>
