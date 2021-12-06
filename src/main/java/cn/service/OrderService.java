package cn.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

/**
 * 〈order servcie〉
 *
 * @author snow.li
 * @create 2021/11/22
 * @since 1.0.0
 */
@Component
public class OrderService {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    public void test() {
        System.out.println("test");
        String sql = "SELECT id from test";
        List<Long> longs = jdbcTemplate.queryForList(sql, Long.class);
        System.out.println(longs.size());
    }
}