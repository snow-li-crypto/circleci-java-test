package cn.support;

/**
 * 〈class type thread local〉
 *
 * @author snow.li
 * @create 2021/12/25
 * @since 1.0.0
 */
public class RedisThreadLocal {

    private static ThreadLocal<Class> threadLocal = new ThreadLocal<Class>();

    public static <T> Class<T> getAndRemove() {
        Class aClass = threadLocal.get();
        threadLocal.remove();
        return aClass;
    }

    public static <T> void set(Class<T> clss) {
        threadLocal.set(clss);
    }

}