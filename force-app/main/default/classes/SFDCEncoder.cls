/**
 * OWASP Enterprise Security API (ESAPI)
 * 
 * This file is part of the Open Web Application Security Project (OWASP)
 * Enterprise Security API (ESAPI) project. For details, please see
 * <a href="https://www.owasp.org/index.php/ESAPI">https://www.owasp.org/index.php/ESAPI</a>.
 *
 * Copyright (c) 2010 - Salesforce.com
 * 
 * The Apex ESAPI implementation is published by Salesforce.com under the New BSD license. You should read and accept the
 * LICENSE before you use, modify, and/or redistribute this software.
 * 
 * @author Yoel Gluck (securecloud .at. salesforce.com) <a href="https://www.salesforce.com">Salesforce.com</a>
 * @created 2010
 */

/**
 * This class is a basic encoder/escaper to help prevent some XSS attacks etc.  
 */
global with sharing class SFDCEncoder {
    
    /* TODO Yoel - all these functions should be converted into a white list aproach - I am using blacklist to be consistent with the VISUALFORCE functions */ 
    /* TODO Yoel - Do we need to encode ASCII/Unicode white-space/new-line characters? These used to cause some security issues in some browsers not sure if this is still the case */
        
    /* Note - the order of these encoding strings is very important so we don't end up with double encoding. 
          Each string we search for, must not be found as a result of a previous encoded string replacement */
        
    private static final String[] HTML_DECODED  = new String[]{ '&', '<', '>', '"', '\''};
    private static final String[] HTML_ENCODED  = new String[]{ '&amp;', '&lt;', '&gt;', '&quot;', '&#39;' };
    
    private static final String[] JS_DECODED = new String[] { '\\', '\'', '\n', '\r', '"', '!--', '/', '<', '>' };
    private static final String[] JS_ENCODED = new String[] { '\\\\', '\\\'', '\\n', '\\r', '\\"', '\\!--', '\\/', '\\u003C', '\\u003E' };
    
    private static final String[] JSINHTML_DECODED = new String[] { '&', '\\', '\'', '"', '\r', '\n', '<', '>' };
    private static final String[] JSINHTML_ENCODED = new String[] { '&amp;', '\\\\', '\\\'', '\\&quot;', '\\r', '\\n', '&lt;', '&gt;' };

    /**
     * Similar to the VisualForce HTMLENCODE function. <br><br>
     * 
     * Example:<br>
     * <PRE>
     * //htmlstr is going to be sent to visualforce as html code
     * htmlstr = '&lt;div&gt;' + ESAPI.encoder().SFDC_HTMLENCODE(unsafe_text) + '&lt;/div&gt;';
     * </PRE>
     */
    global static String SFDC_HTMLENCODE(String input) {
        return ENCODE(input, HTML_DECODED, HTML_ENCODED);
    }

    /**
     * Similar to the VisualForce JSENCODE function. <br><br>
     * 
     * Example:<br>
     * <PRE>
     * //htmlstr is going to be sent to visualforce as html code
     * htmlstr = '&lt;script&gt; var str = "' + ESAPI.encoder().SFDC_JSENCODE(unsafe_text) + '";&lt;/script&gt;';
     * </PRE>
     */
    global static String SFDC_JSENCODE(String input) {
        return ENCODE(input, JS_DECODED, JS_ENCODED);
    }
	global static String SFDC_JSDECODE(String input) {
        return ENCODE(input, JS_ENCODED,JS_DECODED);
    }
    global static String SFDC_HTMLDECODE(String input) {
        return ENCODE(input, HTML_ENCODED,HTML_DECODED);
    }

    /**
     * Similar to the VisualForce JSINHTMLENCODE function. <br><br>
     * 
     * Example:<br>
     * <PRE>
     * //htmlstr is going to be sent to visualforce as html code
     * htmlstr = '&lt;div onclick=\'alert("' + ESAPI.encoder().SFDC_JSINHTMLENCODE(unsafe_text) + '");\'&gt;some text&lt;/div&gt;';
     * </PRE>
     */
    global static String SFDC_JSINHTMLENCODE(String input) {
        if(input == null){
            return '';
        }
        return ENCODE(input, JSINHTML_DECODED, JSINHTML_ENCODED);
    }

    /**
     * Similar to the VisualForce URLENCODE function. <br><br>
     * 
     * Note : This function always encodes into UTF-8 URL encoding
     *  - if you need another encoding type,
     *  use the second function which allows to set the encoding. <br><br>
     *  
     * Note : Even when using this function you should still not trust the input as a full 
     *  URL because it may have JS or load data from other domains. this function just makes 
     *  sure the input is encoded as proper URL. <br><br>
     * 
     * Example:<br>
     * <PRE>
     * //htmlstr is going to be sent to visualforce as html code
     * htmlstr = '&lt;img src=\'https://domain/' + ESAPI.encoder().SFDC_URLENCODE(unsafe_text) + '\' /&gt;';
     * </PRE> 
     */
    global static String SFDC_URLENCODE(String input) {
        if(input == null){
            return input;
        }
        return EncodingUtil.urlEncode(input, 'UTF-8');
    }

    /**
     * Similar to {@link #SFDC_URLENCODE(String) SFDC_URLENCODE}(String&nbsp;input) but 
     *  allows to set specific encoding type. <br><br>
     * 
     * Example:<br>
     * <PRE>
     * //htmlstr is going to be sent to visualforce as html code
     * htmlstr = '&lt;img src=\'https://domain/' + ESAPI.encoder().SFDC_URLENCODE(unsafe_text, 'ISO-8859-1') + '\' /&gt;';
     * </PRE>
     * 
     */
    global static String SFDC_URLENCODE(String input, String encoding) {
        return EncodingUtil.urlEncode(input, encoding);
    }

    private static String ENCODE(String input, String[] fromArr, String[] toArr) {
        if (input == null || input.length() == 0)
            return input;

        for (Integer i = 0; i < fromArr.size(); ++i) {
            input = input.replace(fromArr[i], toArr[i]);
        }
        
        return input;
    }
    public static String EncodeRichText(String richTxtSanitizedVal,List<String> str) {
		
		List<String> smallStrings = new List<String>();
		if(richTxtSanitizedVal != null){
            
            if(richTxtSanitizedVal.containsIgnoreCase('<script>')){
				richTxtSanitizedVal= richTxtSanitizedVal.replaceAll('<script>', SFDCEncoder.SFDC_HTMLENCODE('<script>'));
			}
			if(richTxtSanitizedVal.containsIgnoreCase('</script>')){
				richTxtSanitizedVal= richTxtSanitizedVal.replaceAll('</script>', SFDCEncoder.SFDC_HTMLENCODE('</script>'));
			}
			if(richTxtSanitizedVal.containsIgnoreCase('alert(')){
				richTxtSanitizedVal= richTxtSanitizedVal.replaceAll('alert', SFDCEncoder.SFDC_HTMLENCODE('alert\\('));
			}
		}
        string RegPattern = '<([^<>\\s]+)\\s[^<>]*on[^<>="]+=[^<>]*>'; //regex to find event present in string or not example <svg><animate onend=alert(1) attributeName=x dur=1s> 
        Pattern MyPattern = Pattern.compile(RegPattern);
        Matcher MyMatcher = MyPattern.matcher(richTxtSanitizedVal);
        

        string src = richTxtSanitizedVal;
        if(MyMatcher.find()){//SOQL/SOSL Injection False +ve
            string RegPattern1 = '<([^<>\\s]+).+\\son[^<>="]+=[^<>]*>'; // regex to check tag any character space followed by on*(event)=  it will find exact event 
            // and string like <a href="https://test8-internal--frameworkd--c.sandbox.vf.force.com/apex/applicationEdit?id=a1h05000000X5hlAAC" target="_blank">edit</a> will not satisfy this 
            // regex and will display as a hyperlink as expected . Here added 2 regex as if we add only this regex then regexx too complicated error is ouccring 
        Pattern MyPattern1 = Pattern.compile(RegPattern1);
		if(richTxtSanitizedVal.length() > 1000){
			String largeString = richTxtSanitizedVal;
			Integer chunkSize = 999;
			for (Integer i = 0; i < largeString.length(); i += chunkSize) {
				Integer endIndex = i + chunkSize;
				if (endIndex > largeString.length()) {
					endIndex = largeString.length();
				}
				String smallString = largeString.substring(i, endIndex);
				smallStrings.add(smallString);
			}
			String returnStr = '';
			for(String smallString : smallStrings){
				Matcher MyMatcher1 = MyPattern1.matcher(smallString);
				if(MyMatcher1.find()){//SOQL/SOSL Injection False +ve
					returnStr += smallString.escapeHtml4();
				}else{
					returnStr += smallString;
				}
			}
			src = returnStr;
		}else{
			Matcher MyMatcher1 = MyPattern1.matcher(richTxtSanitizedVal);
			if(MyMatcher1.find()){//SOQL/SOSL Injection False +ve
				src = richTxtSanitizedVal.escapeHtml4();
			}
		}
        }else if(src != '' && (src.containsIgnoreCase('<script') || src.containsIgnoreCase('</script>') || src.containsIgnoreCase('referrerpolicy=')
        || src.containsIgnoreCase('referrerpolicy =') || src.containsIgnoreCase('alert(')||src.containsIgnoreCase('prompt(') || src.containsIgnoreCase('download=') || src.containsIgnoreCase('console.')
        ||src.containsIgnoreCase('download =') || src.containsIgnoreCase('/evil?'))){  
            src = String.escapeSingleQuotes(src);
            src = src.escapeHtml3();
            src = src.escapeUnicode();
        }
        richTxtSanitizedVal =  src;
        
        if(str != null){
        	for(String s:str){
				if(richTxtSanitizedVal.containsIgnoreCase(s)){
					richTxtSanitizedVal = richTxtSanitizedVal.replaceAll(s, SFDCEncoder.SFDC_HTMLENCODE(s));
                    richTxtSanitizedVal = String.escapeSingleQuotes(richTxtSanitizedVal);
                    richTxtSanitizedVal = richTxtSanitizedVal.escapeHtml3();
                    richTxtSanitizedVal = richTxtSanitizedVal.escapeUnicode();
				}
			}
		}
		
		return richTxtSanitizedVal;
	}

    public static String encodeRichTextForPageMessage(String richTxtSanitizedVal,List<String> str) {
        if(richTxtSanitizedVal != null){
            if(richTxtSanitizedVal.containsIgnoreCase('<script>')){
                richTxtSanitizedVal= richTxtSanitizedVal.replaceAll('<script>', SFDCEncoder.SFDC_HTMLENCODE('<script>'));
            }
            if(richTxtSanitizedVal.containsIgnoreCase('</script>')){
                richTxtSanitizedVal= richTxtSanitizedVal.replaceAll('</script>', SFDCEncoder.SFDC_HTMLENCODE('</script>'));
            }
            if(richTxtSanitizedVal.containsIgnoreCase('alert(')){
                richTxtSanitizedVal= richTxtSanitizedVal.replaceAll('alert', SFDCEncoder.SFDC_HTMLENCODE('alert\\('));
            }
        }
        string RegPattern = '<([^<>\\s]+).+\\son[^<>="]+=[^<>]*>'; // regex to check tag any character space followed by on
        
        Pattern MyPattern = Pattern.compile(RegPattern);
        Matcher MyMatcher = MyPattern.matcher(richTxtSanitizedVal);
        
        string src = richTxtSanitizedVal;
        if(MyMatcher.find()){//SOQL/SOSL Injection False +ve
            if(richTxtSanitizedVal.containsIgnoreCase('<a ')){
                if(richTxtSanitizedVal.containsIgnoreCase('alert(')){
                    src = richTxtSanitizedVal.replaceAll('alert', SFDCEncoder.SFDC_HTMLENCODE('alert\\('));
                }
                if(richTxtSanitizedVal.containsIgnoreCase('console.log(')){
                    src = richTxtSanitizedVal.replaceAll('console.log', SFDCEncoder.SFDC_HTMLENCODE('console.log\\('));
                }
                if(richTxtSanitizedVal.containsIgnoreCase('download="')){
                    src = richTxtSanitizedVal.replaceAll('download="', SFDCEncoder.SFDC_HTMLENCODE('download="'));
                }
                if(richTxtSanitizedVal.containsIgnoreCase('script>')){
                    src = richTxtSanitizedVal.replaceAll('script>', SFDCEncoder.SFDC_HTMLENCODE('script>'));
                }
                if(richTxtSanitizedVal.containsIgnoreCase('<base ')){
                    src = richTxtSanitizedVal.replaceAll('<base', SFDCEncoder.SFDC_HTMLENCODE('<base '));
                }
            }else{
                src = richTxtSanitizedVal.escapeHtml4();
            }
        }else if(src != '' && (src.containsIgnoreCase('<script') || src.containsIgnoreCase('</script>') || src.containsIgnoreCase('referrerpolicy=')
        || src.containsIgnoreCase('referrerpolicy =') || src.containsIgnoreCase('alert(')||src.containsIgnoreCase('prompt(') || src.containsIgnoreCase('download=') || src.containsIgnoreCase('console.')
        ||src.containsIgnoreCase('download =') || src.containsIgnoreCase('/evil?'))){  
            src = src.replaceAll('<', '&lt;');
            src = src.replaceAll('>', '&gt;');
            src = src.replace('\'', '\\\'');
        }
        richTxtSanitizedVal =  src;
        if(str != null){
            for(String s:str){
                if(richTxtSanitizedVal.containsIgnoreCase(s)){
                    richTxtSanitizedVal= richTxtSanitizedVal.replaceAll(s, SFDCEncoder.SFDC_HTMLENCODE(s));
                }
            }
        }
        return richTxtSanitizedVal;
    }

    public static String sanitizeJSON(String orignalJson){ 
        if(orignalJson == null || orignalJson == 'null' || string.isBlank(orignalJson)|| orignalJson == '\"\"')
            return '';

        if(string.isBlank(orignalJson.replaceAll('\"\"','')))
            return '';
       Map<String, Object> m = (Map<String, Object>)JSON.deserializeUntyped((EncodingUtil.urlDecode(SFDCEncoder.SFDC_HTMLDECODE(orignalJson),'UTF-8')));
        Map<String, Object> sanitizedMap = new Map<String, Object>();
        for(String key : m.keySet()){
            Object obj = m.get(key);
            if(!(obj instanceof Id) && !(obj instanceof Boolean) && !(obj instanceof Date) && !(obj instanceof Datetime) && !(obj instanceof Time) && !(obj instanceof Integer) && !(obj instanceof Long) && !(obj instanceof Decimal) && !(obj instanceof Double)){
                if(obj instanceof String){
                    String tempValue = String.valueOf(obj);
                    sanitizedMap.put(key, SFDCEncoder.SFDC_JSENCODE(tempValue));
                }
                else if(obj instanceof List<Object>){
                    List<Object> tmpList = (List<Object>)obj;
                    if(tmpList.size() > 0){
                        for(Object o : tmpList){
                            populateSanitizedMap(sanitizedMap, key, o);
                        }
                    }else{
                        sanitizedMap.put(key, obj);
                    }
                }else{
                    sanitizedMap.put(key, obj);
                }
            }else{
                sanitizedMap.put(key, obj);
            }
        }
        String serializedJson = JSON.serialize(sanitizedMap);
        return serializedJson;
    }
    
    private static void populateSanitizedMap(Map<String, Object> sanitizedMap, String key, Object o){
        if(!(o instanceof Id) && !(o instanceof Boolean) && !(o instanceof Date) && !(o instanceof Datetime) && !(o instanceof Time) && !(o instanceof Integer) && !(o instanceof Long) && !(o instanceof Decimal) && !(o instanceof Double)){
            if(o instanceof String){
                String tempValue = String.valueOf(o);
                o = SFDCEncoder.SFDC_JSENCODE(tempValue);
            }
        }
        List<Object> objs = (List<Object>)sanitizedMap.get(key);
        if(objs == null){
            objs = new List<Object>();
        }
        objs.add(o);
        sanitizedMap.put(key, objs);
    }
}