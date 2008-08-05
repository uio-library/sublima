package com.computas.sublima.query.service;

import com.computas.sublima.query.exceptions.UnsupportedCQLFeatureException;
import org.z3950.zing.cql.CQLNode;
import org.z3950.zing.cql.CQLParser;
import org.z3950.zing.cql.CQLParseException;
import org.z3950.zing.cql.CQLTermNode;

import java.io.IOException;

/**
 * 
 * User: kkj
 * Date: Aug 5, 2008
 * Time: 9:05:11 AM
 */
public class CQL2SPARQL {

    private static CQLNode cqlRootNode;

    public CQL2SPARQL(String cqlQuery) throws IOException, CQLParseException {
        CQLParser parser = new CQLParser();
        cqlRootNode = parser.parse(cqlQuery);
    }

    public CQL2SPARQL(CQLNode root) throws IOException, CQLParseException {
        cqlRootNode = root;
    }

    public String Level0() throws UnsupportedCQLFeatureException {
        // Check what we don't need to do for Level 0 and throw an exception if those conditions occur.
        if (! (cqlRootNode instanceof CQLTermNode)) {
            throw new UnsupportedCQLFeatureException("Only Level 0 queries are supported. Not a Term");
        }
        CQLTermNode thisNode = (CQLTermNode) cqlRootNode;
        if (! thisNode.getIndex().equalsIgnoreCase("cql.serverChoice")) {
            throw new UnsupportedCQLFeatureException("Only Level 0 queries are supported. Index specified.");
        }
        if (! thisNode.getRelation().getBase().equals("=")) {
            throw new UnsupportedCQLFeatureException("Only Level 0 queries are supported. Relation not equals.");
        }
        
        return null;
    }

}
