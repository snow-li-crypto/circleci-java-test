package cn.support;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.springframework.data.redis.serializer.RedisSerializer;
import org.springframework.data.redis.serializer.SerializationException;
import org.springframework.lang.Nullable;
import org.springframework.util.Assert;

/**
 * Jackson2RedisSerializer
 *
 * @author snow.li
 * @create 2021/12/23
 * @since 1.0.0
 */
public class Jackson2RedisSerializer implements RedisSerializer<Object> {

    private final ObjectMapper mapper;

    public Jackson2RedisSerializer() {
        this(new ObjectMapper());
    }

    /**
     * @param mapper {@link ObjectMapper}
     * @Description init
     * @Author Snow Li
     * @date 2021-12-25 8:22 AM
     */
    public Jackson2RedisSerializer(ObjectMapper mapper) {
        Assert.notNull(mapper, "ObjectMapper must not be null!");
        mapper.setSerializationInclusion(JsonInclude.Include.NON_NULL)
                .disable(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES)
                .disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS)
                .disable(DeserializationFeature.ADJUST_DATES_TO_CONTEXT_TIME_ZONE)
                .registerModule(new JavaTimeModule());
        this.mapper = mapper;
    }

    /**
     * @param source target object
     * @return byte[]
     * @Description serialize object to byte
     * @Author Snow Li
     * @date 2021-12-25 8:23 AM
     */
    public byte[] serialize(@Nullable Object source) throws SerializationException {
        if (source == null) {
            return new byte[0];
        } else {
            try {
                return this.mapper.writeValueAsBytes(source);
            } catch (JsonProcessingException var3) {
                throw new SerializationException("Could not write JSON: " + var3.getMessage(), var3);
            }
        }
    }

    public Object deserialize(@Nullable byte[] source) throws SerializationException {
        return this.deserialize(source, Object.class);
    }

    /**
     * @param source target source
     * @param type   convert target class type
     * @return {@link T}
     * @Description deserialize source to target class object
     * @Author Snow Li
     * @date 2021-12-25 8:25 AM
     */
    @Nullable
    public <T> T deserialize(@Nullable byte[] source, Class<T> type) throws SerializationException {
        Assert.notNull(type,
                       "Deserialization type must not be null! "
                               + "Please provide Object.class to make use of Jackson2 default typing.");
        if (isEmpty(source)) {
            return null;
        } else {
            try {
                return this.mapper.readValue(source, type);
            } catch (Exception var4) {
                throw new SerializationException("Could not read JSON: " + var4.getMessage(), var4);
            }
        }
    }

    static boolean isEmpty(@Nullable byte[] data) {
        return data == null || data.length == 0;
    }
}