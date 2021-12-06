package cn.servcie;

import cn.Application;
import cn.service.OrderService;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

/**
 * 〈OrderService testcase〉
 *
 * @author snow.li
 * @create 2021/11/22
 * @since 1.0.0
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringBootTest(classes = Application.class)
public class OrderServiceTest {

    @Autowired
    private OrderService orderService;

    @Test
    public void test() {
        orderService.test();
    }

}