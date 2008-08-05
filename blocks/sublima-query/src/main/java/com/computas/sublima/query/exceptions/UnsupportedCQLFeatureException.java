package com.computas.sublima.query.exceptions;

/**
 * This exception is thrown when the CQL Feature is not supported.
 * To be compliant with the different CQL levels, the server only needs to
 * tell when a feature is unsupported, and this is the Exception that will
 * be thrown when that is the case.
 * User: kkj
 * Date: Aug 5, 2008
 * Time: 9:23:11 AM
 */
public class UnsupportedCQLFeatureException extends Exception {
}
