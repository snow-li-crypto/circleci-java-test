package cn.support;

import org.springframework.data.redis.core.RedisCallback;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.util.Assert;

/**
 * 〈〉
 *
 * @author snow.li
 * @create 2021/12/23
 * @since 1.0.0
 */
public class ObjectRedisTemplate extends RedisTemplate<String, Object> {

    private Jackson2RedisSerializer jackson2RedisSerializer = new Jackson2RedisSerializer();

    private RedisSerializer<String> keySerializer = RedisSerializer.string();

    public ObjectRedisTemplate() {
        this.setKeySerializer(keySerializer);
        this.setValueSerializer(jackson2RedisSerializer);
        this.setHashKeySerializer(RedisSerializer.string());
        this.setHashValueSerializer(keySerializer);
    }

    public <T> T get(String key, Class<T> clss) {
        T result = this.execute((RedisCallback<T>) connection -> {
            byte[] source = connection.get(rawKey(key));
            if (source == null) {
                return null;
            }
            return jackson2RedisSerializer.deserialize(source, clss);
        });
        return result;
    }

    byte[] rawKey(Object key) {

        Assert.notNull(key, "non null key required");

        if (this.getKeySerializer() == null && key instanceof byte[]) {
            return (byte[]) key;
        }
        return keySerializer.serialize(key.toString());
    }


}