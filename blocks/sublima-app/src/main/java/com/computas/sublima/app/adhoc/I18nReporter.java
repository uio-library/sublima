package com.computas.sublima.app.adhoc;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
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

  private static SortedSet<String> codetags = new TreeSet<String>();
  private static SortedSet<String> translatedtags_no = new TreeSet<String>();
  private static SortedSet<String> translatedtags_sv = new TreeSet<String>();
  private static SortedSet<String> translatedtags_nn = new TreeSet<String>();
  private static SortedSet<String> translatedtags = new TreeSet<String>();

  private static SortedSet<String> sortedtranslatedtags_no = new TreeSet<String>();
  private static SortedSet<String> sortedtranslatedtags_sv = new TreeSet<String>();
  private static SortedSet<String> sortedtranslatedtags_nn = new TreeSet<String>();
  private static SortedSet<String> sortedtranslatedtags = new TreeSet<String>();

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
      //getCodeTags(file);
      //getTranslatedTags(file);
      if (file.isFile()) { // process as file

        if (!file.getName().equals("conversions") && !file.getName().equals("rdf-data") && !file.getName().equals(".svn")) {

          if (file.getName().endsWith("java") ||
                  file.getName().endsWith("xml") ||
                  file.getName().endsWith("xsl") ||
                  file.getName().endsWith("xslt")) {

            if (file.length() < 2388608 && !file.getName().startsWith("messages")) {
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
                    patterns.add("i18n:text key=.?\"(.*?)?\"");
                    //patterns.add("i18n:attr=.?\"(.*?)?\"");

                    for (String pattern : patterns) {

                      Pattern p = Pattern.compile(pattern);
                      Matcher m = p.matcher(line);

                      while (m.find()) {
                        codetags.add(m.group(1).replace("\\", ""));
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
            } else if (file.length() < 2388608 && file.getName().startsWith("messages")) {
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
                    patterns.add("key=.?\"(.*?)?\"");
                    //patterns.add("i18n:attr=.?\"(.*?)?\"");

                    for (String pattern : patterns) {

                      Pattern p = Pattern.compile(pattern);
                      Matcher m = p.matcher(line);

                      while (m.find()) {
                        if (file.getName().endsWith("_no.xml")) {
                          translatedtags_no.add(m.group(1).replace("\\", ""));
                          sortedtranslatedtags_no.add(m.group(1).replace("\\", ""));
                        } else if (file.getName().endsWith("_sv.xml")) {
                          translatedtags_sv.add(m.group(1).replace("\\", ""));
                          sortedtranslatedtags_sv.add(m.group(1).replace("\\", ""));
                        } else if (file.getName().endsWith("_nn.xml")) {
                          translatedtags_nn.add(m.group(1).replace("\\", ""));
                          sortedtranslatedtags_nn.add(m.group(1).replace("\\", ""));
                        } else if (file.getName().endsWith("es.xml")) {
                          translatedtags.add(m.group(1).replace("\\", ""));
                          sortedtranslatedtags.add(m.group(1).replace("\\", ""));
                        }
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
            }

          }

        }


      } else { // dir.isDirectory()

        traverse(file);
      }
    }
  }

  public static void main
          (String[] args) {
    traverse(new File("C:\\prosjekter\\SUBLIMA\\Kode\\Sublima"));

    SortedSet<String> temptags = new TreeSet<String>(codetags);

    System.out.println("\n\n\nMESSAGES.XML\nNot translated tags:\n");
    temptags.removeAll(translatedtags);

    for (String match : temptags) {
      System.out.println("<message key=\"" + match + "\"></message> <!-- MÅ OVERSETTES -->");
    }

    temptags = new TreeSet<String>(codetags);

    System.out.println("\n\n\nMESSAGES_NO.XML\nNot translated tags:\n");
    temptags.removeAll(translatedtags_no);

    for (String match : temptags) {
      System.out.println("<message key=\"" + match + "\"></message> <!-- MÅ OVERSETTES -->");
    }

    temptags = new TreeSet<String>(codetags);

    System.out.println("\n\n\nMESSAGES_SV.XML\nNot translated tags:\n");
    temptags.removeAll(translatedtags_sv);

    for (String match : temptags) {
      System.out.println("<message key=\"" + match + "\"></message> <!-- MÅ OVERSETTES -->");
    }

    temptags = new TreeSet<String>(codetags);

    System.out.println("\n\n\nMESSAGES_NN.XML\nNot translated tags:\n");
    temptags.removeAll(translatedtags_nn);

    for (String match : temptags) {
      System.out.println("<message key=\"" + match + "\"></message> <!-- MÅ OVERSETTES -->");
    }

    temptags = new TreeSet<String>(codetags);

    System.out.println("\n\n\nTRANSLATED NOT IN CODE\n");
    translatedtags.removeAll(temptags);

    for (String match : translatedtags) {
      System.out.println(match);
    }

    /*

    System.out.println("\n\n\nMESSAGES_NN.XML\n");
    for (String match : sortedtranslatedtags_nn) {
      System.out.println(match);
    }

    System.out.println("\n\n\nMESSAGES_NO.XML\n");
    for (String match : sortedtranslatedtags_no) {
      System.out.println(match);
    }

    System.out.println("\n\n\nMESSAGES_SV.XML\n");
    for (String match : sortedtranslatedtags_sv) {
      System.out.println(match);
    }

    System.out.println("\n\n\nMESSAGES.XML\n");
    for (String match : sortedtranslatedtags) {
      System.out.println(match);
    }
    */

    temptags = new TreeSet<String>(sortedtranslatedtags);

    System.out.println("\n\n\nIN MESSAGES BUT NOT IN NO:\n");
    temptags.removeAll(sortedtranslatedtags_no);

    for (String match : temptags) {
      System.out.println(match);
    }

    temptags = new TreeSet<String>(sortedtranslatedtags);

    System.out.println("\n\n\nIN MESSAGES BUT NOT IN SV:\n");
    temptags.removeAll(sortedtranslatedtags_sv);

    for (String match : temptags) {
      System.out.println(match);
    }

    temptags = new TreeSet<String>(sortedtranslatedtags);

    System.out.println("\n\n\nIN MESSAGES BUT NOT IN NN:\n");
    temptags.removeAll(sortedtranslatedtags_nn);

    for (String match : temptags) {
      System.out.println(match);
    }

  }
}
