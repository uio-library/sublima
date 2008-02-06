package com.computas.sublima.app;

import java.io.IOException;
import com.computas.sublima.query.RDFObject;

import org.apache.log4j.Logger;

import java.util.LinkedList;
import java.util.List;
import java.util.Enumeration;
import java.util.Map;

import org.apache.cocoon.environment.Request;

/**
 * A service class with methods to create a SPARQL DESCRIBE query from a
 * Request object. The constructor takes a mandatory array of prefix
 * declarations, on the form
 * 
 * <pre>
 * 				prefix: &lt;URI&gt;
 * </pre>
 * 
 * e.g., it may be called as myService = new Form2SparqlService(new
 * String[]{"dct: <http://purl.org/dc/terms/>", "foaf:
 * <http://xmlns.com/foaf/0.1/>"});
 * 
 * @author kkj
 * @version 1.0
 * @param: prefixes string array with prefixes for names used.
 */
public class Form2SparqlService {
	
	private static Logger logger = Logger.getLogger(Form2SparqlService.class);
	
	private String language;

	private String[] prefixes;

	private List subjectVarList = new LinkedList();

	private int variablecount = 1; // the var below has to be unique across

	// calls


	public Form2SparqlService(String[] pr) {
		prefixes = pr;
	}

	/**
	 * Can be used to set the language of all content passed to the service.
	 * 
	 * @param lang
	 *            A ISO 639 string.
	 */
	public void setLanguage(String lang) {
		language = lang;
	}

	/**
	 * Returns the language set for all strings.
	 * 
	 * @return A ISO 639 string.
	 */
	public String getLanguage() {
		return language;
	}

	/**
	 * Returns a string of prefixes as used in N3 based on the array set in the
	 * constructor.
	 * 
	 * @return a string of prefixes as used in N3.
	 */
	public String getPrefixString() {
		StringBuffer res = new StringBuffer();
		for (String prefix : prefixes) {
			res.append("PREFIX " + prefix + "\n");
		}
		return res.toString();
	}

	/*
	 * TODO: create a method to expand the prefix array public void
	 * addPrefix(String prefix) { prefixes.add(prefix); }
	 */

	/**
	 * Takes a key with corresponding values and returns an N3 representation
	 * based on certain assumptions about the nature of the data. <p/> The value
	 * is always the object of the resulting triple, but often, it doesn't have
	 * a direct relationship to its subject. For example, a <tt>dc:subject</tt>
	 * may not be string, but is related through a rdfs:label, like
	 * 
	 * <pre>
	 * 				?resource	dc:subject 	?var .
	 * 				?var		rdfs:label	&quot;Foo&quot; .
	 * </pre>
	 * 
	 * <p/> The key for this structure is created by taking the property names
	 * and separate them with a /, e.g.
	 * 
	 * <pre>
	 * 			dc:subject/rdfs:label
	 * </pre>
	 * 
	 * <p/> For this key, you may give "Foo" as the value, which will return the
	 * above example.
	 * 
	 * @return N3 with the result.
	 * @param key
	 *            The key as described above.
	 * @param values
	 *            A string array containing values for the key.
	 */
	public String convertFormField2N3(String key, String[] values) {
		StringBuffer n3Buffer = new StringBuffer();
		String[] keys = key.split("/");
		Boolean optional = false;
		for (String value : values) { // TODO low-pri: Optimize to comma-separate values.
			String var = "?resource "; // The first SPARQL variable will always be resource
			int j = 0;
			for (String qname : keys) {
				j++;
				n3Buffer.append("\n" + var + qname + " ");
				System.out.println("Value: " + value);
				if (value == "") { // Then, it is a block we don't know is
					// there, thus OPTIONAL
				    System.out.println("Value is empty");
					optional = true;
				}
				if (value == null) {
				    System.out.println("Value is null");
				}
				if (value == " ") {
				    System.out.println("Value is space");
				}
				if (!subjectVarList.contains(var)) {
					subjectVarList.add(var);
				}

				if (keys.length == j && value != "") { // Then we are on the
					// actual form input
					// value
					RDFObject myRDFObject = new RDFObject(value, language);
					n3Buffer.append(myRDFObject.toN3());
				} else { // Then we have to connect the object of this
					// statement to the subject of the next
					var = "?var" + variablecount + " "; // Might need more work
					// to ensure uniqueness
					logger.debug("Using unique N3 variable " + var);
					n3Buffer.append(var + ".");
					variablecount++;
				}
			}
		}
		if (optional) {
			n3Buffer.insert(0, "\nOPTIONAL {");
			n3Buffer.append(" }");
		}
		logger.trace("Returning N3: " + n3Buffer.toString());
		return n3Buffer.toString();
	}

	/**
	 * Returns a full SPARQL DESCRIBE query based on a key-value Map. See above
	 * for an explanation of the structure of each key-value. In addition to the
	 * above described key-value-pairs, it may have a key
	 * <tt>interface-language</tt> that holds the language of any literal.
	 * 
	 * @param request
	 *            The request parameter data as a Request object.
	 * @return A full SPARQL DESCRIBE query.
	 */
	public String convertForm2Sparql(Request request) {

		// Using StringBuffer, since regular String can cause performance issues
		// with large datasets
		StringBuffer sparqlQueryBuffer = new StringBuffer();
		StringBuffer n3Buffer = new StringBuffer();
		sparqlQueryBuffer.append(getPrefixString());
		sparqlQueryBuffer.append("DESCRIBE ");

		if (request.getParameterValues("interface-language") != null) {
			setLanguage(request.getParameterValues("interface-language")[0]);
			request.removeAttribute("interface-language");
		}

		Enumeration enumeration = request.getParameterNames();		
		while (enumeration.hasMoreElements()) {
			String key = (String) enumeration.nextElement();
			String tmpn3 = convertFormField2N3(key, request.getParameterValues(key));
			if (tmpn3.startsWith("\nOPTIONAL")) {
				n3Buffer.append(tmpn3); // OPTIONALs have to go after
			} else {
				n3Buffer.insert(0, tmpn3);
			}
		}

		// Add the variables to the query
		for (Object element : subjectVarList) {
			sparqlQueryBuffer.append((String) element);
		}

		sparqlQueryBuffer.append("WHERE {");
		sparqlQueryBuffer.append(n3Buffer);
		sparqlQueryBuffer.append("\n}");
		String returnString = sparqlQueryBuffer.toString();
		logger.trace("Constructed SPARQL query: " + returnString);
		return returnString;
	}

	/**
	 * Returns a full SPARQL Update INSERT query based on a key-value Map. Only
	 * triples can be inserted, it does not support the path-like notation of
	 * the DESCRIBE methods. The subject resource must be sent as a key named
	 * <tt>the-resource</tt> Like the DESCRIBE method, it may have a key
	 * <tt>interface-language</tt> that holds the language of any literal.
	 * 
	 * @param request
	 *            The request parameter data as a Request object.
	 * @return A full SPARQL INSERT query.
	 * @throws IOException
	 */

	public String convertForm2Sparul(Request request)
			throws IOException {
		// TODO Do this with an proper INSERT/UPDATE/MODIFY
		// Using StringBuffer, since regular String can cause performance issues
		// with large datasets
		StringBuffer sparqlQueryBuffer = new StringBuffer();
		sparqlQueryBuffer.append(getPrefixString());
		sparqlQueryBuffer.append("INSERT {\n");

		String language = new String();
		if (request.getParameterValues("interface-language") != null) {
			language = request.getParameterValues("interface-language")[0];
			request.removeAttribute("interface-language");
		}
		String subject = new String();
		if (request.getParameterValues("the-resource") != null) {
			subject = request.getParameterValues("the-resource")[0];
			request.removeAttribute("the-resource");
		} else {
			throw new IOException(
					"The subject is not given in the form of a 'the-resource' parameter.");
		}

		Enumeration enumeration = request.getParameterNames();
		while(enumeration.hasMoreElements()) {
			String key = (String) enumeration.nextElement();
			String[] values = request.getParameterValues(key);
			if ((values != null) && (values[0] != "")) {
				RDFObject myRDFObject = new RDFObject(values[0], language);
				sparqlQueryBuffer.append("<" + subject + "> " + key
						+ " " + myRDFObject.toN3() + "\n");
			}
		}

		sparqlQueryBuffer.append("}");
		String returnString = sparqlQueryBuffer.toString();
		logger.trace("Constructed SPARUL query: " + returnString);
		return returnString;
	}
}
