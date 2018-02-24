package com.CRUD.controller;

import com.CRUD.bean.Msg;
import com.CRUD.bean.user;
import com.CRUD.service.UserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//处理CRUD请求
@Controller
public class userController {
    @Autowired
    UserService userService;


    //删除的控制层
    @RequestMapping(value = "/user/{ids}",method = RequestMethod.DELETE)
    @ResponseBody
    public Msg delUser(@PathVariable("ids") String ids){
        if (ids.contains("-")){
            String[] str_ids=ids.split("-");
            List<Integer> IDS=new ArrayList<>();
            for(String str_id:str_ids){
                Integer id=Integer.parseInt(str_id);
                IDS.add(id);
            }
            userService.delUsers(IDS);
        }else {
            Integer id=Integer.parseInt(ids);
            userService.delUser(id);
        }
        return Msg.success();
    }


    //修改用户信息的控制层
    //PUT请求封装数据还要在web.xml中配置filter，它会将数据封装成map，requestgetparameter（）才可用
    @RequestMapping(value = "/user/{id}",method = RequestMethod.PUT)
    @ResponseBody
    public Msg editUser(user U){
        userService.editUser(U);
        return Msg.success();
    }

    /**
     * 根据id查找员工的控制层
     */
    @RequestMapping(value = "/userWithId/{id}",method = RequestMethod.GET)
    @ResponseBody
    public Msg getUser(@PathVariable("id") Integer id){
        user U=userService.getUser(id);
        return Msg.success().add("user",U);
    }

    /**
     * 为了能支持JSR303，需导入Hibernate——validator
     *
     */
    //检验用户名是否可用的方法
    @ResponseBody
    @RequestMapping("/checkuser")
    public Msg checkuser(@RequestParam("username") String username){
        String regx="^[a-zA-Z0-9]{1,8}$";
        //先判断用户名是否是合法的表达式
        if(!username.matches(regx)){
            return Msg.fail().add("va_msg","用户名为1-8位字母或数字后端");
        }
        boolean b=userService.checkUser(username);
        //数据库用户名重复校验
        if(b){
            return Msg.success();
        }else {
            return Msg.fail().add("va_msg","用户名不可用");
        }

    }

    /**
     * 员工保存
     * @return
     */
    @RequestMapping(value = "/user",method = RequestMethod.POST)
    @ResponseBody
    public Msg saveUser(@Valid user U, BindingResult result){
        if(result.hasErrors()){
            Map<String,Object> map=new HashMap<>();
            //处理校验失败后的错误信息
            List<FieldError> errors=result.getFieldErrors();
            for (FieldError error:errors){
                System.out.println("错误字段名"+error.getField());
                System.out.println("错误信息"+error.getDefaultMessage());
                map.put(error.getField(),error.getDefaultMessage());
            }
            return Msg.fail().add("errorFields",map);
        }else {
            userService.saveUser(U);
            return Msg.success();
        }
    }
    //返回json的方法
    //导入jackson包
    @RequestMapping("/List")
    @ResponseBody
    public Msg getUsersWithJson(@RequestParam(value ="pn",defaultValue = "1")Integer pn, Model model){

        List<user> Users=userService.getAll();
        user U=Users.get(Users.size()-1);
        System.out.println(U.getId());
        PageHelper.startPage(pn,5);
        List<user> users=userService.getAll();
        PageInfo page=new PageInfo(users,5);
        //return page;
        return Msg.success().add("PageInfo",page);
    }
    //查询用户数据
//    @RequestMapping("/List")
//    public String getUsers(@RequestParam(value ="pn",defaultValue = "1")Integer pn, Model model){
//        //引入pagehelper分页查询
//        //查询之前只需要调用，传入页码及每页显示记录数
//        PageHelper.startPage(pn,5);
//        //紧跟的查询即为分页查询
//        List<user> users=userService.getAll();
//        //使用pageinfo包装查询后的结果，只需要将pageinfo交给页面就行了
//        //封装了详细的分页信息，包括有我们查询出来的数据,传入连续显示的页数
//        PageInfo page=new PageInfo(users,5);
//        model.addAttribute("PageInfo",page);
//        return "List";
//
//    }
}
