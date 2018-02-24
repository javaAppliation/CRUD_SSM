package com.CRUD.bean;

import javax.validation.constraints.Pattern;

public class user {
    public user(Integer id, String username, String password) {
        this.id = id;
        this.username = username;
        this.password = password;
    }

    public user() {
    }

    private Integer id;
    //自定义用户名校验标准
    @Pattern(regexp = "^[a-zA-Z0-9]{1,8}$",message = "JSR303错误")
    private String username;
    @Pattern(regexp = "^[a-zA-Z0-9]{1,8}$",message = "JSR303错误")
    private String password;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username == null ? null : username.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }
}