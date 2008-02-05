package com.computas.sublima.transform;

import java.io.IOException;
import java.util.Map;

import org.apache.avalon.framework.parameters.Parameters;
import org.apache.cocoon.ProcessingException;
import org.apache.cocoon.environment.SourceResolver;
import org.apache.cocoon.transformation.AbstractTransformer;
import org.apache.cocoon.xml.IncludeXMLConsumer;
import org.apache.cocoon.xml.StringXMLizable;
import org.xml.sax.Attributes;
import org.xml.sax.SAXException;

import com.computas.sublima.query.SparqlDispatcher;

public class NavigationAndFacetsTransformer extends AbstractTransformer {

	private SparqlDispatcher sparqlDispatcher;
	
	public void setup(SourceResolver resolver, Map objectModel, String src,
			Parameters par) throws ProcessingException, SAXException,
			IOException {

	}

	@Override
	public void startElement(String uri, String loc, String raw, Attributes a)
			throws SAXException {

        if ("navigation".equals(loc)) {
			super.startElement(uri, loc, raw, a);

            //todo Use the existing SPARQL resultset and create a query that returns the navigation elements
            String result = (String) this.sparqlDispatcher.query("DESCRIBE <http://www.the-jet.com/>");
			StringXMLizable stringXMLizable = new StringXMLizable(result);
			stringXMLizable.toSAX(new IncludeXMLConsumer(this.contentHandler));
            return;
		}

        if ("facets".equals(loc)) {
			super.startElement(uri, loc, raw, a);

            //todo Use the existing SPARQL resultset and create a query that returns the facets
            String result = (String) this.sparqlDispatcher.query("DESCRIBE <http://www.the-jet.com/>");
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
