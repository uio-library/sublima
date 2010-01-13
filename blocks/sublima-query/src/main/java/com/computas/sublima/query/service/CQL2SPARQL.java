package com.computas.sublima.query.service;

import com.computas.sublima.query.exceptions.UnsupportedCQLFeatureException;
import com.hp.hpl.jena.sparql.util.StringUtils;
import org.z3950.zing.cql.CQLNode;
import org.z3950.zing.cql.CQLParser;
import org.z3950.zing.cql.CQLParseException;
import org.z3950.zing.cql.CQLTermNode;
import org.apache.log4j.Logger;                              

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.net.URLDecoder;

/**
 * 
 * User: kkj
 * Date: Aug 5, 2008
 * Time: 9:05:11 AM
 */
public class CQL2SPARQL {

    private static CQLNode cqlRootNode;
    static Logger logger = Logger.getLogger(CQL2SPARQL.class);

    public CQL2SPARQL(String cqlQuery) throws IOException, CQLParseException {
        CQLParser parser = new CQLParser();
        cqlRootNode = parser.parse(cqlQuery);
    }

    public CQL2SPARQL(CQLNode root) throws IOException, CQLParseException {
        cqlRootNode = root;
    }

    public String Level0() throws UnsupportedCQLFeatureException, UnsupportedEncodingException {
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
        SearchService searchService = new SearchService("AND");

        String searchString = URLDecoder.decode(thisNode.getTerm(), "UTF-8");
        searchString = searchService.buildSearchString(searchString, true, false); // This is the freetext we will search for.
        logger.debug("CQL2SPARQL: Search String is: " + searchString);
        return  "PREFIX sub: <http://xmlns.computas.com/sublima#>\n" +
                "PREFIX wdr: <http://www.w3.org/2007/05/powder#>\n" +
                "DESCRIBE ?resource WHERE {\n" +
                "?resource sub:literals ?lit .\n" +
                "?lit <bif:contains> \"" + searchString + "\" .\n" +
                "?resource wdr:describedBy <http://sublima.computas.com/status/godkjent_av_administrator> .\n" +
                "} LIMIT 50";

    }

}
