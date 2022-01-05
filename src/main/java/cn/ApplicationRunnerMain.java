package cn;

import com.alibaba.fastjson.JSON;
import lombok.extern.slf4j.Slf4j;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.stereotype.Component;

/**
 * 〈ApplicationRunner〉
 *
 * @author snow.li
 * @create 2021/12/21
 * @since 1.0.0
 */
@Slf4j
@Component
public class ApplicationRunnerMain implements ApplicationRunner {

    @Override
    public void run(ApplicationArguments args) throws Exception {
        log.info("run-{}", JSON.toJSONString(args));
    }
}