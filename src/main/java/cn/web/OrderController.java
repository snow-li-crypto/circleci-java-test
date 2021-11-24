package cn.web;


import cn.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;


/**
 * demo controller
 *
 * @author snow.li
 * @date 2021/11/08 10:08
 **/
@RestController
public class OrderController {

    @Autowired
    private OrderService orderService;

    @ResponseBody
    @RequestMapping(value = "/hello")
    public String hello() {
        
        orderService.test();
        return "hello work";
    }


}
