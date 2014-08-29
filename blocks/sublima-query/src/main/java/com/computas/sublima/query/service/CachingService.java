package com.computas.sublima.query.service;

import net.spy.memcached.MemcachedClient;
import net.spy.memcached.AddrUtil;

import org.apache.log4j.Logger;

import java.util.concurrent.TimeUnit;

/**
 * A service to do stuff with the memcached client
 * User: kkj
 * Date: Oct 27, 2008
 * Time: 2:37:58 PM
 */
public class CachingService implements AutoCloseable {

    private static Logger logger = Logger.getLogger(CachingService.class);
    private MemcachedClient memcached;

    public CachingService() {
        // This should really have inherited and extended MencachedClient, but that can't be done in Java.
    	memcached = connect();
    }

    /**
     * Connect to the memcached
     * @return an instance of the MemcachedClient
     **/
    private MemcachedClient connect() {
        MemcachedClient mc = null;
        try {
            mc = new MemcachedClient(
                    AddrUtil.getAddresses(
                            SettingsService.getProperty("sublima.memcached.servers")
                    )
            );
        } catch (Exception e) {
            logger.info("SPARQLdispatcher couldn't find the memcached server and said " + e.getMessage()
                    + ". Have you set sublima.memcached.servers?");
        }
        return mc;
    }

    /**
     * Get whatever from the memcached with a given key
     * @param key the String key of the cache entry
     *
     * @return an Object with the cached entry or null if it wasn't found.
     */
    public Object get(String key) {
        long connecttime = System.currentTimeMillis();
        Object fromCache = null;
        if (memcached != null) {
            try {
                fromCache = memcached.get(key);
            } catch (Exception e) {
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
     * @param key the String key of the cache entry
     *
     * @return boolean returns true if the key was found.
     */
    public boolean ask(String key) {
      return (this.get(key) != null);
    }

    /**
     * Will invalidate the cache when called
     */
    public void modelChanged() {
        if (memcached != null) {
          memcached.waitForQueues(2, TimeUnit.SECONDS);
          memcached.flush();
        }
    }

    public void close() {
        if (memcached != null) {
            memcached.shutdown(2, TimeUnit.SECONDS);
            memcached = null;
        }
    }

	public void set(String cacheKey, int i, String result) {
		if (memcached != null) {
			memcached.set(cacheKey, 60 * 60 * 24 * 30, result);
		}
	}
}
