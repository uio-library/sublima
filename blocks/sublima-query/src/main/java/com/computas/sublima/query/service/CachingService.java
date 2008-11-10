package com.computas.sublima.query.service;

import net.spy.memcached.MemcachedClient;
import net.spy.memcached.AddrUtil;
import net.spy.memcached.OperationTimeoutException;
import org.apache.log4j.Logger;

import java.util.concurrent.TimeoutException;
import java.util.concurrent.TimeUnit;

/**
 * A service to do stuff with the memcached client
 * User: kkj
 * Date: Oct 27, 2008
 * Time: 2:37:58 PM
 */
public class CachingService {

    private static Logger logger = Logger.getLogger(CachingService.class);
    private boolean useMemcached = false;

    public CachingService() {
        // This should really have inherited and extended MencachedClient, but that can't be done in Java.
    }

    /**
     * Connect to the memcached
     * @return an instance of the MemcachedClient
     **/
    public MemcachedClient connect() {
        MemcachedClient memcached = null;
        try {
            memcached = new MemcachedClient(
                    AddrUtil.getAddresses(
                            SettingsService.getProperty("sublima.memcached.servers")
                    )
            );
            useMemcached = true;
        } catch (Exception e) {
            useMemcached = false;
            logger.info("SPARQLdispatcher couldn't find the memcached server and said " + e.getMessage()
                    + ". Have you set sublima.memcached.servers?");
        }
        return memcached;
    }

    /**
     * If we are using memcached
     * @return boolean
     */
    public boolean useMemcached() {
        return useMemcached;
    }

    /**
     * Get whatever from the memcached with a given key
     *
     * @param mc the Memcached Client
     * @param key the String key of the cache entry
     * @return an Object with the cached entry or null if it wasn't found.
     */
    public Object get(MemcachedClient mc, String key) {
        long connecttime = System.currentTimeMillis();
        Object fromCache = null;
        if (useMemcached) {
            try {
                fromCache = mc.get(key);
            } catch (Exception e) {
                useMemcached = false;
                logger.warn("SPARQLdispatcher timed out when contacting memcached: "  + e.getMessage()
                        + ". Have you set sublima.memcached.servers?");
            }
        }
        long requesttime = System.currentTimeMillis() - connecttime;
        logger.trace("Memcached returned within " + requesttime + " ms.");
        return fromCache;
    }

    /**
     * Ask if something with the given key is allready memcached
     *
     * @param mc the Memcached Client
     * @param key the String key of the cache entry
     * @return boolean returns true if the key was found.
     */
    public boolean ask(MemcachedClient mc, String key) {
      return (this.get(mc, key) != null);
    }

    /**
     * Will invalidate the cache when called
     * @param mc The MemcachedClient object
     */

    public void modelChanged(MemcachedClient mc) {
        if (useMemcached) {
          mc.waitForQueues(2, TimeUnit.SECONDS);
          mc.flush();
        }
    }

    public void close(MemcachedClient mc) {
        if (useMemcached) {
            mc.shutdown(2, TimeUnit.SECONDS);
        }
    }
}
