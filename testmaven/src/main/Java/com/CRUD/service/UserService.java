package com.CRUD.service;

import com.CRUD.bean.user;
import com.CRUD.bean.userExample;
import com.CRUD.dao.userMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import java.util.List;
@Service
public class UserService {
    @Autowired
    private userMapper usermapper;
    //查询所有用户
    public List<user> getAll() {
        return usermapper.selectByExample(null);
    }
    public void saveUser(user U){
        usermapper.insertSelective(U);
    }
    //检验用户名是否可用
    public boolean checkUser(String username){
        userExample example=new userExample();
        userExample.Criteria criteria=example.createCriteria();
        criteria.andUsernameEqualTo(username);
        long count=usermapper.countByExample(example);
        //返回true，说明count==0，数据库里没有这个数据，username可用
        return count==0;
    }

    //根据id获取用户信息
    public user getUser(Integer id) {
        user U=usermapper.selectByPrimaryKey(id);
        return U;
    }

    //有选择的修改用户信息
    public void editUser(user U){
        usermapper.updateByPrimaryKeySelective(U);
    }

    //删除单个用户信息
    public void delUser(Integer id){
        usermapper.deleteByPrimaryKey(id);

    }

    //批量删除
    public void delUsers(List<Integer> ids){
        userExample example=new userExample();
        userExample.Criteria criteria=example.createCriteria();
        criteria.andIdIn(ids);
        usermapper.deleteByExample(example);
    }

}
