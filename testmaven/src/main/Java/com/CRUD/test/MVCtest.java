package com.CRUD.test;

import com.CRUD.bean.user;
import com.github.pagehelper.PageInfo;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mock.web.MockHttpServletRequest;
import org.springframework.stereotype.Service;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MockMvcBuilder;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.request.MockHttpServletRequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import java.util.List;

/*
使用spring测试模块提供的测试请求功能，测试crud请求的正确性
 */
@RunWith(SpringJUnit4ClassRunner.class)
@WebAppConfiguration
@ContextConfiguration(locations ={"classpath:applicationContext.xml","file:/Users/lishengyu/testmaven/src/main/webapp/WEB-INF/dispatchServlet-servlet.xml" })
public class MVCtest {
    //传入springMVC的ioc
    @Autowired
    WebApplicationContext context;
    //虚拟MVC请求，获取到处理结果
    MockMvc mockMvc;
    @Before
    public void initMockMVC(){
        MockMvcBuilders.webAppContextSetup(context).build();
    }
    @Test
    public void testPage()throws Exception{
        //模拟请求拿到返回值
        MvcResult result= mockMvc.perform(MockMvcRequestBuilders.get("/user").param("pn","1")).andReturn();
        //请求成功以后，请求域中会有pageInfo；我们可以取出pageInfo进行验证
        MockHttpServletRequest request= result.getRequest();
        PageInfo pi=(PageInfo) request.getAttribute("PageInfo");
        System.out.println("当前页码："+pi.getPageNum());
        System.out.println("总页码："+pi.getPages());
        System.out.println("总记录数："+pi.getTotal());
        System.out.println("在页面需要连续显示的页码");
        int[] nums=pi.getNavigatepageNums();
        for(int i:nums){
            System.out.print(""+i);
        }
        //获取员工数据
        List<user> list =pi.getList();
        for (user U:list){
            System.out.println("id:"+U.getId()+""+"username"+U.getUsername()+""+"password"+U.getPassword());
        }
    }
}
