package com.computas.sublima.transform;

import com.computas.sublima.query.SparqlDispatcher;
import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.apache.cocoon.xml.IncludeXMLConsumer;
import org.apache.cocoon.xml.StringXMLizable;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import java.io.IOException;
import java.util.Map;

public class NavigationAndFacetsTransformer extends AbstractTransformer {

  private SparqlDispatcher sparqlDispatcher;
  String subject;

  public void setup(SourceResolver resolver, Map objectModel, String src,
                    Parameters par) throws ProcessingException, SAXException,
          IOException {
  }

  @Override
  public void startElement(String uri, String loc, String raw, Attributes a)
          throws SAXException {

    /**
     * This checks that if the element starts with topic: then the subject is found at rdf:about
     *
     * ie.
     *
     * Search for Jet and the topic in the result set is defined by topic:Jet, since this will change we have to only
     * look for "topic:".
     *
     * This can be done with SPARQL also. 
     */

    if (raw.startsWith("topic:")) { //("dct:subject".equals(raw)) {
      subject = "<" + a.getValue("rdf:about") + ">";
    }

    if ("navigation".equals(loc)) {
      super.startElement(uri, loc, raw, a);

      //todo Use the existing SPARQL resultset and create a query that returns the navigation elements

      String sparqlConstructQuery =
              "prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n" +
              "prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>\n" +
              "prefix owl: <http://www.w3.org/2002/07/owl#>\n" +
              "prefix foaf: <http://xmlns.com/foaf/0.1/>\n" +
              "prefix lingvoj: <http://www.lingvoj.org/ontology#>\n" +
              "prefix dcmitype: <http://purl.org/dc/dcmitype/>\n" +
              "prefix dct: <http://purl.org/dc/terms/>\n" +
              "prefix sub: <http://xmlns.computas.com/sublima#>\n" +
              "prefix wdr: <http://www.w3.org/2007/05/powder#>\n" +
              "prefix sioc: <http://rdfs.org/sioc/ns#>\n" +
              "prefix skos: <http://www.w3.org/2004/02/skos/core#>\n" +
              "CONSTRUCT {\n" +
                      subject + " skos:prefLabel ?label ; \n" +
                      " skos:altLabel ?synLabel ;\n" +
                      " skos:related ?relSub ;\n" +
                      " skos:broader ?btSub ;\n" +
                      " skos:narrower ?ntSub .\n" +
                      " ?relSub skos:prefLabel ?relLabel .\n" +
                      " ?btSub skos:prefLabel ?btLabel .\n" +
                      " ?ntSub skos:prefLabel ?ntLabel .\n" +
                      " }\n" +
                      " WHERE {\n" +
                      subject + " rdfs:label ?label .\n" +
                      subject + " a ?class .\n" +
                      " OPTIONAL { " + subject + " <http://xmlns.computas.com/sublima#synonym> ?synLabel  . }\n" +
                      " OPTIONAL { " + subject + " ?prop ?relSub .\n" +
                      " ?relSub rdfs:label ?relLabel . }\n" +
                      " OPTIONAL { ?class rdfs:subClassOf ?btClass .\n" +
                      " ?btSub a ?btClass ;\n" +
                      " rdfs:label ?btLabel . }\n" +
                      " OPTIONAL { ?ntClass rdfs:subClassOf ?class .\n" +
                      " ?ntSub a ?ntClass .\n" +
                      " ?ntClass rdfs:label ?ntLabel . } }";

      String result = (String) this.sparqlDispatcher.query(sparqlConstructQuery);
      StringXMLizable stringXMLizable = new StringXMLizable(result);
      stringXMLizable.toSAX(new IncludeXMLConsumer(this.contentHandler));
      return;
    }

    if ("facets".equals(loc)) {
      super.startElement(uri, loc, raw, a);

      //todo Use the existing SPARQL resultset and create a query that returns the facets
      String result = (String) this.sparqlDispatcher.query("DESCRIBE <http://the-jet.com/>");
      StringXMLizable stringXMLizable = new StringXMLizable(result);
      stringXMLizable.toSAX(new IncludeXMLConsumer(this.contentHandler));
      return;
    }

    super.startElement(uri, loc, raw, a);
  }

  @Override
  public void endElement(String uri, String loc, String raw) throws SAXException {

    super.endElement(uri, loc, raw);
  }

  public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
    this.sparqlDispatcher = sparqlDispatcher;
  }

}
