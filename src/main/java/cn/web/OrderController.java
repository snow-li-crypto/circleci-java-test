package cn.web;


import cn.service.OrderService;
import cn.support.Modle;
import cn.support.ObjectRedisTemplate;
import cn.support.RedisThreadLocal;
import com.alibaba.fastjson.JSON;
import com.google.common.collect.Maps;
import java.util.Map;
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

    public Map<String, String> map = Maps.newHashMap();

    @Autowired
    private ObjectRedisTemplate objectRedisTemplate;

    @ResponseBody
    @RequestMapping(value = "/hello")
    public String hello(String key) {

        System.out.println(orderService.toString());
        map.put(key, "test");
//        orderService.test();
        System.out.println(JSON.toJSON(map));

        Modle model = new Modle();
        model.setName("snow");
        objectRedisTemplate.opsForValue().set("modle", model);

        RedisThreadLocal.set(Modle.class);
        Object model1 = objectRedisTemplate.opsForValue().get("modle");
        System.out.println(JSON.toJSON(model1));

        return "hello work";
    }


}
