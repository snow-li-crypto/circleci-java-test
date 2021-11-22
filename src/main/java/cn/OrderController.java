package cn;


import org.springframework.web.bind.annotation.PostMapping;
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

    @ResponseBody
    @RequestMapping(value = "/hello")
    public String hello() {
        return "hello work";
    }


}
