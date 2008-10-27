package com.computas.sublima.query.service;

import net.spy.memcached.MemcachedClient;
import net.spy.memcached.AddrUtil;
import net.spy.memcached.OperationTimeoutException;
import org.apache.log4j.Logger;

import java.io.IOException;

/**
 * A service to invalidate the memcached
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

    public boolean useMemcached() {
        return useMemcached;
    }

    public Object get(MemcachedClient mc, String key) {
        Object fromCache = null;
        if (useMemcached) {
            try {
                fromCache = mc.get(key);
            } catch (OperationTimeoutException e) {
                useMemcached = false;
                logger.warn("SPARQLdispatcher timed out when contacting memcached: "  + e.getMessage()
                        + ". Have you set sublima.memcached.servers?");
            }
        }
        return fromCache;
    }


    /**
     * Will invalidate the cache when called
     */

    public void modelChanged(MemcachedClient mc) {
        mc.flush();
    }
}
