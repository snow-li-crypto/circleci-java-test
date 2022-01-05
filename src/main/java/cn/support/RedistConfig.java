package cn.support;

import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.context.annotation.Bean;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.stereotype.Component;

/**
 * 〈config〉
 *
 * @author snow.li
 * @create 2021/12/23
 * @since 1.0.0
 */
@Configurable
@Component
public class RedistConfig {

    @Bean
    private ObjectRedisTemplate redisTemplate(RedisConnectionFactory connectionFactory) {
        ObjectRedisTemplate template = new ObjectRedisTemplate();

        template.setConnectionFactory(connectionFactory);

//        template.opsForValue().
//        GenericJackson2JsonRedisSerializer serializer = new GenericJackson2JsonRedisSerializer();

//        Jackson2RedisSerializer serializer = new Jackson2RedisSerializer();

//        FastJsonRedisSerializer serializer = new FastJsonRedisSerializer(Object.class);
//        template.setKeySerializer(StringRedisSerializer.UTF_8);
//        template.setValueSerializer(serializer);
//        template.setValueSerializer(serializer);
//
//        template.setDefaultSerializer(serializer);
//
//        template.setHashKeySerializer(StringRedisSerializer.UTF_8);
//        template.setHashValueSerializer(serializer);
        template.afterPropertiesSet();
        return template;
    }
}