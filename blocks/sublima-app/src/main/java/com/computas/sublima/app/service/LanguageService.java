package com.computas.sublima.app.service;

import static com.computas.sublima.query.service.SettingsService.getProperty;
import org.apache.cocoon.components.flow.apples.AppleRequest;
import org.apache.cocoon.components.flow.apples.AppleResponse;
import org.apache.log4j.Logger;

import javax.servlet.http.Cookie;
import java.util.Arrays;
import java.util.List;

/**
 * User: kkj
 * Date: Jan 27, 2009
 * Time: 3:32:24 PM
 */
public class LanguageService {
  private static Logger logger = Logger.getLogger(LanguageService.class);

  /**
   * This will set the check the URL, the language cookie and the config to find the appropriate language.
   * It will set the cookie, and
   *
   * @param req The AppleRequest
   * @param res The AppleRespone
   * @return String language  the ISO 639-1 language code
   */
  public String checkLanguage(AppleRequest req, AppleResponse res) {
    String setLang;
    String paramLang = null;
    if (req.getCocoonRequest().getParameterValues("locale") != null) {
      paramLang = req.getCocoonRequest().getParameterValues("locale")[0];
    }
    logger.trace("The query parameter language was " + paramLang);
    Cookie[] cookies = req.getCocoonRequest().getCookies();
    // cookieLang is what is in the language cookie
    String cookieLang = null;
    Cookie langCookie = null;

    if (cookies != null) {
      for (Cookie cookie : cookies) {
        if ("locale".equals(cookie.getName())) {
          cookieLang = cookie.getValue();
          langCookie = cookie;
        }
      }
    }
    logger.trace("The cookie language was " + cookieLang);
    if (cookieLang == null) {
      if (paramLang == null) {
        setLang = getProperty("sublima.default.locale");
      } else {
        List defaultLangs = Arrays.asList(getProperty("sublima.supported.locales").split(","));
        if (defaultLangs.contains(paramLang)) {
          setLang = paramLang;
          logger.debug("Cookie was not set, but the query param contained valid language: " + paramLang);
        } else {
          setLang = getProperty("sublima.default.locale");
          logger.info("Cookie was not set, and the query param contained invalid language: " + paramLang + ". Using default instead.");
        }
      }
      if (langCookie == null) {
        langCookie = res.getCocoonResponse().createCookie("locale", setLang);
      } else {
        langCookie.setValue(setLang);
      }
    } else {
      if (!cookieLang.equals(paramLang)) {
        List defaultLangs = Arrays.asList(getProperty("sublima.supported.locales").split(","));
        if (defaultLangs.contains(paramLang)) {
          setLang = paramLang;
          logger.debug("Cookie was set and the query param differed and contained valid language: " + paramLang);
        } else {
          setLang = cookieLang;
          logger.warn("Cookie was set and the query param differed, but contained invalid language: " + paramLang + ". Keeping.");
        }
      } else {
        /* TODO: This will not set the language to default if the locale parameter
        *  is missing and there is a cookie. Is that OK?
        */
        logger.trace("Cookie was set, and not changed, Keeping.");
        setLang = cookieLang;
      }
      langCookie.setValue(setLang);
    }
    res.getCocoonResponse().addCookie(langCookie);
    return setLang;
  }
}
