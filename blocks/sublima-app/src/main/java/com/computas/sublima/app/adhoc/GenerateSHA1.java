package com.computas.sublima.app.adhoc;

import com.computas.sublima.app.service.AdminService;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * @author: mha
 * Date: 18.aug.2008
 */
public class GenerateSHA1 {
  AdminService adminService = new AdminService();

  private static String convertToHex(byte[] data) {
    StringBuilder buf = new StringBuilder();
    for (int i = 0; i < data.length; i++) {
      int halfbyte = (data[i] >>> 4) & 0x0F;
      int two_halfs = 0;
      do {
        if ((0 <= halfbyte) && (halfbyte <= 9))
          buf.append((char) ('0' + halfbyte));
        else
          buf.append((char) ('a' + (halfbyte - 10)));
        halfbyte = data[i] & 0x0F;
      } while (two_halfs++ < 1);
    }
    return buf.toString();
  }

  public static String generateSHA1(String text)
          throws NoSuchAlgorithmException, UnsupportedEncodingException {
    MessageDigest md;
    md = MessageDigest.getInstance("SHA-1");
    byte[] sha1hash = new byte[40];
    md.update(text.getBytes("UTF-8"), 0, text.length());
    sha1hash = md.digest();
    return convertToHex(sha1hash);
  }

  public static void main(String[] args) {

    if (args.length == 0) {
      System.err.println("A text to create the SHA1 sum for must be given.");
      System.out.println("Usage: GenerateSha1 MyText");
    } else {

      String sha1;
      try {
        sha1 = generateSHA1(args[0]);
      } catch (NoSuchAlgorithmException e) {
        e.printStackTrace();
        sha1 = "FAILED";
      } catch (UnsupportedEncodingException e) {
        e.printStackTrace();
        sha1 = "FAILED";
      }
      System.out.println("SHA1 for " + args[0] + ": " + sha1);
    }
  }
}
