package cn.servcie;

import cn.Application;
import cn.support.Modle;
import cn.support.ObjectRedisTemplate;
import cn.support.RedisThreadLocal;
import com.alibaba.fastjson.JSON;
import java.util.Set;
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
public class RedisTest {

    @Autowired
    private ObjectRedisTemplate objectRedisTemplate;

    @Test
    public void test() {
        Modle modle = new Modle("snow.li");
        String key = "modle";
        objectRedisTemplate.opsForValue().set(key, modle);

        RedisThreadLocal.set(Modle.class);

        Modle obj = objectRedisTemplate.get(key, Modle.class);
        System.out.println(obj.getClass());
    }

    @Test
    public void testList() {
        Modle modle = new Modle("snow.li");
        String key = "modleSet";
        objectRedisTemplate.opsForSet().add(key, modle);

        RedisThreadLocal.set(Modle.class);

        Set<Object> members = objectRedisTemplate.opsForSet().members(key);

//        Set < Object > range = objectRedisTemplate.opsForZSet().range(key, 0, 1);
        System.out.println(JSON.toJSON(members));
    }

    @Test
    public void testHash() {
        Modle modle = new Modle("snow.li");
        String key = "modle";
        objectRedisTemplate.opsForHash().put(key, "m1", modle);

        RedisThreadLocal.set(Modle.class);

        Object obj = objectRedisTemplate.opsForHash().get(key, "m1");
        System.out.println(obj.getClass());
    }

    @Test
    public void testInt() {
        objectRedisTemplate.opsForValue().set("test", 1);
        Object obj = objectRedisTemplate.opsForValue().get("test");
        System.out.println(obj.getClass());
    }
}