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
		if ("foo".equals(loc)) {
			super.startElement(uri, "bar", "bar", a);
			return;
		}
		super.startElement(uri, loc, raw, a);
	}
	
	@Override
	public void endElement(String uri, String loc, String raw) throws SAXException {
		if ("foo".equals(loc)) {
			super.endElement(uri, "bar", "bar");
			
			// demonstrate how a string can be streamed as SAX events
			String result = "<abc/>";
			// result = (String) this.sparqlDispatcher.query("foo");
			StringXMLizable stringXMLizable = new StringXMLizable(result);			
			stringXMLizable.toSAX(new IncludeXMLConsumer(this.contentHandler));
			return;
		}
		super.endElement(uri, loc, raw);
	}

	public void setSparqlDispatcher(SparqlDispatcher sparqlDispatcher) {
		this.sparqlDispatcher = sparqlDispatcher;
	}

}
