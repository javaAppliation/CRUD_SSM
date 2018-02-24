package com.CRUD.test;

import com.CRUD.bean.user;
import com.CRUD.dao.userMapper;
import com.CRUD.service.UserService;
import org.apache.ibatis.session.SqlSession;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import java.util.UUID;

//使用spring单元测试，自动注入
//导入SpringTest jar包
//@ContextConfiguration指定spring配置文件位置
//直接autowired所使用
@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations ="classpath:applicationContext.xml" )
public class MapperTest {
    @Autowired
    userMapper usermapper;
    @Autowired
    UserService userService;
    @Autowired
    SqlSession sqlSession;
    @Test
    public void testCRUD(){
        usermapper.insertSelective(new user(1,"LSY","LSY"));

        userMapper mapper =sqlSession.getMapper(userMapper.class);
        for(int i=2;i<100;i++){
            String uid= UUID.randomUUID().toString().substring(1,2);
            usermapper.insertSelective(new user(i,uid,uid+i));
        }

    }

}
