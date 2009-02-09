package com.computas.sublima.app.adhoc;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * This class reads all i18n-tags from the source code files (.java, .xml, .xsl*)
 * and reports discrepancies between source code tags and actual translations
 * <p/>
 * Created by IntelliJ IDEA.
 * User: Magnus
 * Date: 09.feb.2009
 * Time: 20:53:41
 */
public class I18nReporter {

  private static Set<String> terms = new HashSet<String>();

  /**
   * Traverse over files in a directory and all sub-directories adding files that
   * match the provided name to the results list.
   *
   * @param dir The directory to start searching in.
   */
  private static void traverse(File dir) {

    // get all the files and directories
    File[] children = dir.listFiles();
    // loop over the file/directory listing
    for (File file : children) {
      // is the current item a file?

      if (!file.getName().equals("conversions") && !file.getName().equals("rdf-data") && !file.getName().equals(".svn")) {
        if (file.isFile()) { // process as file

          if (file.getName().endsWith("java") ||
              file.getName().endsWith("xml") ||
              file.getName().endsWith("xsl") ||
              file.getName().endsWith("xslt") &&
                  file.length() < 2388608 &&
                  !file.getName().startsWith("messages")) {

            try {
              //use buffering, reading one line at a time
              //FileReader always assumes default encoding is OK!
              BufferedReader input = new BufferedReader(new FileReader(file));
              try {
                String line = null; //not declared within while loop
                /*
                * readLine is a bit quirky :
                * it returns the content of a line MINUS the newline.
                * it returns null only for the END of the stream.
                * it returns an empty String if two newlines appear in a row.
                */
                while ((line = input.readLine()) != null) {

                  List<String> patterns = new ArrayList<String>();
                  patterns.add("i18n:key=.?(.*?)?.\"");
                  patterns.add("i18n:attr=.?(.*?)?.\"");

                  for (String pattern : patterns) {
                                                           
                    Pattern p = Pattern.compile(pattern);
                    Matcher m = p.matcher(line);

                    while (m.find()) {
                      terms.add(m.group());
                    }
                  }
                }
              }
              finally {
                input.close();
              }
            }
            catch (IOException ex) {
              ex.printStackTrace();
            }

            // Read file and search for pattern match
          }

        } else { // dir.isDirectory()

          traverse(file);

        }
      }
    }


  }

  public static void main(String[] args) {
    traverse(new File("C:\\prosjekter\\SUBLIMA\\code\\Sublima"));

    for (String match : terms) {
      System.out.println(match);
    }
  }


}
