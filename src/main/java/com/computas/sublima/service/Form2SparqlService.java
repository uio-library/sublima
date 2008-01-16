package com.computas.sublima.service;

import java.io.IOException;
import com.computas.sublima.model.RDFObject;
import org.apache.log4j.Logger;

import java.util.LinkedList;
import java.util.List;
import java.util.Map;

/**
 * A service class with methods to create a SPARQL DESCRIBE query from a key-value
 * structure.
 * The constructor takes a mandatory array of prefix declarations, on the form
 * <pre>
 * 				prefix: <URI>
 * </pre>
 * e.g., it may be called as
 * myService = new Form2SparqlService(new String[]{"dc: <http://purl.org/dc/elements/1.1/>", "foaf: <http://xmlns.com/foaf/0.1/>"});
 *
 * @author kkj
 * @version 1.0
 * @param: prefixes string array with prefixes for names used.
 */
public class Form2SparqlService {
  private String language;
  private String[] prefixes;
  private List subjectVarList = new LinkedList();
  private int variablecount = 1; // the var below has to be unique across calls
  static Logger logger = Logger.getLogger(Form2SparqlService.class);

  public Form2SparqlService(String[] pr) {
    prefixes = pr;
  }

  /**
   * Can be used to set the language of all content passed to the service.
   *
   * @param lang A ISO 639 string.
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
   * Returns a string of prefixes as used in N3 based on the array set
   * in the constructor.
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

/* TODO: create a method to expand the prefix array
  public void addPrefix(String prefix) {
	  	prefixes.add(prefix);
  }
*/

  /**
   * Takes a key with corresponding values and returns an N3 representation based
   * on certain assumptions about the nature of the data.
   * <p/>
   * The value is always the object of the resulting triple, but often, it doesn't
   * have a direct relationship to its subject. For example, a <tt>dc:subject</tt>
   * may not be string, but is related through a rdfs:label, like
   * <pre>
   * 				?resource	dc:subject 	?var .
   * 				?var		rdfs:label	"Foo" .
   * </pre>
   * <p/>
   * The key for this structure is created by taking the property names and
   * separate them with a /, e.g.
   * <pre>
   * 			dc:subject/rdfs:label
   * </pre>
   * <p/>
   * For this key, you may give "Foo" as the value, which will return the above example.
   *
   * @return N3 with the result.
   * @param  key The key as described above.
   * @param  values  A string array containing values for the key.
   */
  public String convertFormField2N3(String key, String[] values) {
    StringBuffer n3Buffer = new StringBuffer();
    String[] keys = key.split("/");
    Boolean optional = false;
    for (String value : values) { // TODO low-pri: Optimize to comma-separate values.
      String var = "?resource ";  // The first SPARQL variable will always be resource
      int j = 0;
      for (String qname : keys) {
        j++;
        n3Buffer.append("\n" + var + qname + " ");
        if (value == "") { // Then, it is a block we don't know is there, thus OPTIONAL
          optional = true;
        }
        if (!subjectVarList.contains(var)) {
          subjectVarList.add(var);
        }

        if (keys.length == j && value != "") { // Then we are on the actual form input value
          RDFObject myRDFObject = new RDFObject(value, language);
          n3Buffer.append(myRDFObject.toN3());
        } else { // Then we have to connect the object of this statement to the subject of the next
          var = "?var" + variablecount + " "; // Might need more work to ensure uniqueness
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
   * Returns a full SPARQL DESCRIBE query based on a key-value Map.
   * See above for an explanation of the structure of each key-value.
   * In addition to the above described key-value-pairs, it may have a key
   * <tt>interface-language</tt> that holds the language of any literal.
   *
   * @param parameterMap The data structure with the key-value-pairs.
   * @return A full SPARQL DESCRIBE query.
   */
  public String convertForm2Sparql(Map<String, String[]> parameterMap) {

    //Using StringBuffer, since regular String can cause performance issues with large datasets
    StringBuffer sparqlQueryBuffer = new StringBuffer();
    StringBuffer n3Buffer = new StringBuffer();
    sparqlQueryBuffer.append(getPrefixString());
    sparqlQueryBuffer.append("DESCRIBE ");

    if (parameterMap.get("interface-language") != null) {
      setLanguage(parameterMap.get("interface-language")[0]);
      parameterMap.remove("interface-language");
    }

    for (Map.Entry<String, String[]> e : parameterMap.entrySet()) {
      n3Buffer.append(convertFormField2N3(e.getKey(), e.getValue()));
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

  public String convertForm2Sparul(Map<String, String[]> parameterMap) throws IOException {
    //TODO Do this with an proper INSERT/UPDATE/MODIFY
    //Using StringBuffer, since regular String can cause performance issues with large datasets
    StringBuffer sparqlQueryBuffer = new StringBuffer();
    sparqlQueryBuffer.append(getPrefixString());
    sparqlQueryBuffer.append("INSERT {\n");

    String language = new String();
    if (parameterMap.get("interface-language") != null) {
      language = parameterMap.get("interface-language")[0];
      parameterMap.remove("interface-language");
    }
    String subject = new String(); 
    if (parameterMap.get("the-resource") != null) {
        subject = parameterMap.get("the-resource")[0];
        parameterMap.remove("the-resource");
    } 
     //	Is there any way to not be forced to catch the exception in the immediately calling code?
    	else {
    	throw new IOException("The subject is not given in the form of a 'the-resource' parameter.");
    } 

    for (Map.Entry<String, String[]> e : parameterMap.entrySet()) {
    	RDFObject myRDFObject = new RDFObject(e.getValue()[0], language);
    	sparqlQueryBuffer.append("<" + subject + "> " + e.getKey() + " " + myRDFObject.toN3() + "\n");
    }

    sparqlQueryBuffer.append("}");
    String returnString = sparqlQueryBuffer.toString();
    logger.trace("Constructed SPARUL query: " + returnString);
    return returnString;
  }
}
