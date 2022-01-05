package cn.support;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.support.config.FastJsonConfig;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.SerializationException;

/**
 * 〈〉
 *
 * @author snow.li
 * @create 2021/12/23
 * @since 1.0.0
 */
public class FastJsonRedisSerializer<T> implements RedisSerializer<T> {

    private FastJsonConfig fastJsonConfig = new FastJsonConfig();
    private Class<T> type;

    public FastJsonRedisSerializer(Class<T> type) {
        this.type = type;
    }

    public FastJsonConfig getFastJsonConfig() {
        return this.fastJsonConfig;
    }

    public void setFastJsonConfig(FastJsonConfig fastJsonConfig) {
        this.fastJsonConfig = fastJsonConfig;
    }

    public byte[] serialize(T t) throws SerializationException {
        if (t == null) {
            return new byte[0];
        } else {
            try {
                return JSON.toJSONBytesWithFastJsonConfig(this.fastJsonConfig.getCharset(), t,
                                                          this.fastJsonConfig.getSerializeConfig(),
                                                          this.fastJsonConfig.getSerializeFilters(),
                                                          this.fastJsonConfig.getDateFormat(),
                                                          JSON.DEFAULT_GENERATE_FEATURE,
                                                          this.fastJsonConfig.getSerializerFeatures());
            } catch (Exception var3) {
                throw new SerializationException("Could not serialize: " + var3.getMessage(), var3);
            }
        }
    }

    public T deserialize(byte[] bytes) throws SerializationException {
        if (bytes != null && bytes.length != 0) {
            try {
                return JSON.parseObject(bytes, this.fastJsonConfig.getCharset(), this.type,
                                        this.fastJsonConfig.getParserConfig(), this.fastJsonConfig.getParseProcess(),
                                        JSON.DEFAULT_PARSER_FEATURE, this.fastJsonConfig.getFeatures());
            } catch (Exception var3) {
                throw new SerializationException("Could not deserialize: " + var3.getMessage(), var3);
            }
        } else {
            return null;
        }
    }
}