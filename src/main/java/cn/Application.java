package cn;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * 〈start up〉
 *
 * @author snow.li
 * @create 2021/11/22
 * @since 1.0.0
 */
@SpringBootApplication(scanBasePackages = {"cn"})
public class Application {

    /**
     *
     * @param args
     */
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}