<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Topic.aspx.cs" Inherits="Topic" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
		<title>问卷</title>
	</head>

	<body>
		<div id="head">
			首页 > 问卷  > 问题管理
			<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		</div>
		<div id="search">
			<input type="text" id="key" placeholder="登录名" />
			<span class="btn g btn_search">搜索</span>
			<a class="btn b btn_right btn_add" href="Manage_Users_Design.aspx">添加</a>
		</div>
        <div id="list">			
			<table cellpadding="1" cellspacing="1">
				<thead>
					<tr>
						<td class="li1">ID</td>
						<td class="li2">问题描述</td>
						<td class="li3">答案</td>
						<td class="li6">状态</td>
						<td class="li7">编辑</td>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<div id="pager"></div>
		</div>
        <script>
            $(function () {

            })
        </script>
</body>
</html>
