/** 
 * @description - The class has the Test methods to test SFDCEncoder class. 
 */
@isTest
private class SFDCEncoderTest {
    
    private class EncodeTest {
        public String inputStr;
        public String expectedOutput;
        public String errText;
        public Boolean expectedResult;
        public String encoding;
        
        public EncodeTest(String inputStr, String expectedOutput, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.expectedOutput = expectedOutput;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
        
        public EncodeTest(String inputStr, String encoding, String expectedOutput, String errText, Boolean expectedResult) {
            this.inputStr = inputStr;
            this.encoding = encoding;
            this.expectedOutput = expectedOutput;
            this.errText = errText;
            this.expectedResult = expectedResult;
        }
    }
    
    private static final EncodeTest [] htmlEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] jsEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] jsInHtmlEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] urlEncodeTests = new EncodeTest[]{};
    private static final EncodeTest [] urlEncodeWithEncodingTests = new EncodeTest[]{};
    
    static {
        htmlEncodeTests.add(new EncodeTest('abc', 'abc', 'Valid #1', true));
        htmlEncodeTests.add(new EncodeTest('abc<b>test</b>def', 'abc&lt;b&gt;test&lt;/b&gt;def', 'Valid #2', true));
        htmlEncodeTests.add(new EncodeTest('abc&lt;def', 'abc&amp;lt;def', 'Valid #3', true));
        htmlEncodeTests.add(new EncodeTest('abc<fghgfh&lt;<sfdg>&amp;def', 'abc&lt;fghgfh&amp;lt;&lt;sfdg&gt;&amp;amp;def', 'Valid #4', true));
        htmlEncodeTests.add(new EncodeTest('abc\'def', 'abc&#39;def', 'Valid #5', true));
        htmlEncodeTests.add(new EncodeTest('abc"def', 'abc&quot;def', 'Valid #6', true));

        jsEncodeTests.add(new EncodeTest('abc', 'abc', 'Valid #1', true));
        jsEncodeTests.add(new EncodeTest('abc<b>test</b>def', 'abc\\u003Cb\\u003Etest\\u003C\\/b\\u003Edef', 'Valid #2', true));
        jsEncodeTests.add(new EncodeTest('abc&lt;def', 'abc&lt;def', 'Valid #3', true));
        jsEncodeTests.add(new EncodeTest('abc<fghgfh&lt;<sfdg>&amp;def', 'abc\\u003Cfghgfh&lt;\\u003Csfdg\\u003E&amp;def', 'Valid #4', true));
        jsEncodeTests.add(new EncodeTest('abc\\def', 'abc\\\\def', 'Valid #5', true));
        jsEncodeTests.add(new EncodeTest('abc\'def', 'abc\\\'def', 'Valid #6', true));
        jsEncodeTests.add(new EncodeTest('abc\rdef', 'abc\\rdef', 'Valid #7', true));
        jsEncodeTests.add(new EncodeTest('abc\ndef', 'abc\\ndef', 'Valid #8', true));
        jsEncodeTests.add(new EncodeTest('abc"def', 'abc\\"def', 'Valid #9', true));
        jsEncodeTests.add(new EncodeTest('abc!--def', 'abc\\!--def', 'Valid #10', true));
        jsEncodeTests.add(new EncodeTest('abc<!--def', 'abc\\u003C\\!--def', 'Valid #11', true));
        jsEncodeTests.add(new EncodeTest('abc/def', 'abc\\/def', 'Valid #12', true));

        jsInHtmlEncodeTests.add(new EncodeTest('abc', 'abc', 'Valid #1', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc<b>test</b>def', 'abc&lt;b&gt;test&lt;/b&gt;def', 'Valid #2', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc&lt;def', 'abc&amp;lt;def', 'Valid #3', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc<fghgfh&lt;<sfdg>&amp;def', 'abc&lt;fghgfh&amp;lt;&lt;sfdg&gt;&amp;amp;def', 'Valid #4', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc\'def', 'abc\\\'def', 'Valid #5', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc"def', 'abc\\&quot;def', 'Valid #6', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc&def', 'abc&amp;def', 'Valid #7', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc\\def', 'abc\\\\def', 'Valid #8', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc\rdef', 'abc\\rdef', 'Valid #9', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc\ndef', 'abc\\ndef', 'Valid #10', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc<def', 'abc&lt;def', 'Valid #11', true));
        jsInHtmlEncodeTests.add(new EncodeTest('abc>def', 'abc&gt;def', 'Valid #12', true));

        urlEncodeTests.add(new EncodeTest('abc', 'abc', 'Valid #1', true));
        urlEncodeTests.add(new EncodeTest('abc<b>test</b>def', 'abc%3Cb%3Etest%3C%2Fb%3Edef', 'Valid #2', true));
        urlEncodeTests.add(new EncodeTest('abc&lt;def', 'abc%26lt%3Bdef', 'Valid #3', true));
        urlEncodeTests.add(new EncodeTest('abc<fghgfh&lt;<sfdg>&amp;def', 'abc%3Cfghgfh%26lt%3B%3Csfdg%3E%26amp%3Bdef', 'Valid #4', true));
        urlEncodeTests.add(new EncodeTest('abc\'def', 'abc%27def', 'Valid #5', true));
        urlEncodeTests.add(new EncodeTest('abc"def', 'abc%22def', 'Valid #6', true));
        urlEncodeTests.add(new EncodeTest('abc\rdef', 'abc%0Ddef', 'Valid #7', true));
        urlEncodeTests.add(new EncodeTest('abc\ndef', 'abc%0Adef', 'Valid #8', true));
        urlEncodeTests.add(new EncodeTest('abc' + EncodingUtil.urlDecode('%D7%A9', 'UTF-8') + 'def', 'abc%D7%A9def', 'Valid #9', true));

        urlEncodeWithEncodingTests.add(new EncodeTest('abc', 'UTF-8', 'abc', 'Valid #1', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc<b>test</b>def', 'UTF-8', 'abc%3Cb%3Etest%3C%2Fb%3Edef', 'Valid #2', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc&lt;def', 'UTF-8', 'abc%26lt%3Bdef', 'Valid #3', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc<fghgfh&lt;<sfdg>&amp;def', 'UTF-8', 'abc%3Cfghgfh%26lt%3B%3Csfdg%3E%26amp%3Bdef', 'Valid #4', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc\'def', 'UTF-8', 'abc%27def', 'Valid #5', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc"def', 'UTF-8', 'abc%22def', 'Valid #6', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc\rdef', 'UTF-8', 'abc%0Ddef', 'Valid #7', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc\ndef', 'UTF-8', 'abc%0Adef', 'Valid #8', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc' + EncodingUtil.urlDecode('%D7%A9', 'UTF-8') + 'def', 'UTF-8', 'abc%D7%A9def', 'Valid #9', true));

        urlEncodeWithEncodingTests.add(new EncodeTest('abc', 'UTF-16', 'abc', 'Valid #1', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc<b>test</b>def', 'UTF-16', 'abc%FE%FF%00%3Cb%FE%FF%00%3Etest%FE%FF%00%3C%00%2Fb%FE%FF%00%3Edef', 'Valid #2', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc&lt;def', 'UTF-16', 'abc%FE%FF%00%26lt%FE%FF%00%3Bdef', 'Valid #3', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc<fghgfh&lt;<sfdg>&amp;def', 'UTF-16', 'abc%FE%FF%00%3Cfghgfh%FE%FF%00%26lt%FE%FF%00%3B%00%3Csfdg%FE%FF%00%3E%00%26amp%FE%FF%00%3Bdef', 'Valid #4', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc\'def', 'UTF-16', 'abc%FE%FF%00%27def', 'Valid #5', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc"def', 'UTF-16', 'abc%FE%FF%00%22def', 'Valid #6', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc\rdef', 'UTF-16', 'abc%FE%FF%00%0Ddef', 'Valid #7', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc\ndef', 'UTF-16', 'abc%FE%FF%00%0Adef', 'Valid #8', true));
        urlEncodeWithEncodingTests.add(new EncodeTest('abc' + EncodingUtil.urlDecode('%D7%A9', 'UTF-8') + 'def', 'UTF-16', 'abc%FE%FF%05%E9def', 'Valid #9', true));
    }

    static testMethod void testEncoderHtmlEncode() {
        for (EncodeTest t : htmlEncodeTests) {
            try {
                String ret = SFDCEncoder.SFDC_HTMLENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                System.assert(t.expectedResult == true, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assert(t.expectedResult == false, t.errText);
            }
        }
    }    

    static testMethod void testEncoderJsEncode() {
        for (EncodeTest t : jsEncodeTests) {
            try {
                String ret = SFDCEncoder.SFDC_JSENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                System.assert(t.expectedResult == true, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assert(t.expectedResult == false, t.errText);
            }
        }
    }    
    
    static testMethod void testEncoderJsInHtmlEncode() {
        for (EncodeTest t : jsInHtmlEncodeTests) {
            try {
                String ret = SFDCEncoder.SFDC_JSINHTMLENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                System.assert(t.expectedResult == true, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assert(t.expectedResult == false, t.errText);
            }
        }
    }    

    static testMethod void testEncoderUrlEncode() {
        for (EncodeTest t : urlEncodeTests) {
            try {
                String ret = SFDCEncoder.SFDC_URLENCODE(t.inputStr);
                // if no exception - check if we are expecting a valid test
                System.assert(t.expectedResult == true, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assert(t.expectedResult == false, t.errText);
            }
        }
    }    

    static testMethod void testEncoderUrlEncodeWithEncoding() {
        for (EncodeTest t : urlEncodeWithEncodingTests) {
            try {
                String ret = SFDCEncoder.SFDC_URLENCODE(t.inputStr, t.encoding);
                // if no exception - check if we are expecting a valid test
                System.assert(t.expectedResult == true, t.errText);
                // also make sure return value is equal to input
                System.assert(ret.equals(t.expectedOutput), t.errText);
            } catch (Exception e) {
                // if exception - check if we are expecting an invalid test
                System.assert(t.expectedResult == false, t.errText);
            }
        }
    }    
    static testMethod void testEncodeRichText1(){
        List<String> xssSanitizeStr = new List<String>();
        List<XSSSanitization__mdt> lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues'];
        if(lstMetadata != null && !lstMetadata.isEmpty())
            xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c)? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();        
        test.startTest();
        string str='<script>alert()</script>';
        string richtest=SFDCEncoder.EncodeRichText(str,xssSanitizeStr);
        test.stopTest();
        system.assertNotEquals('&lt;script&gt;alert((&lt;/script&gt;',richtest);
    }
    static testMethod void testEncodeRichTextOne(){
        List<String> xssSanitizeStr = new List<String>();
        List<XSSSanitization__mdt> lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues'];
        if(lstMetadata != null && !lstMetadata.isEmpty())
            xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c)? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();        
        test.startTest();
        string str='<svg><animate onend=alert(1) attributeName=x dur=1s>';
        string richtest=SFDCEncoder.EncodeRichText(str,xssSanitizeStr);
       	test.stopTest();
        system.assertNotEquals('&lt;script&gt;alert((&lt;/script&gt;',richtest);
     }
     
	  static testMethod void testEncodeRichTexttwo(){
	    List<String> xssSanitizeStr = new List<String>();
	    List<XSSSanitization__mdt> lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues'];
	    if(lstMetadata != null && !lstMetadata.isEmpty())
	        xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c)? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();        
	    test.startTest();
	    string str='W96nqtkkycvoxnkyi0waowzb947f5cpx <xss onafterscriptexecute=alert(1)><script>1</script> zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz W96nqtkkycvoxnkyi0waowzb947f5cpx zxiyzdanvziffxtyyhdkcsuo4etlyape arc9w1x98pbgcr7q02dlwfexcizuqk1n zd4bdqgrzgetg6bwfch5uabrjgip9gg4 lvhruhgmvsbn5gvfwagbfwxpxntphcna gsdwzppeiv2fjkejvmirkdxi7p38mrzf apjzvw3khonmo7zw5qutyqycb22ki4cu cyhoqeqmfpybpbbfp6n7lqzuyrvqigyz sqn8abbrhughmqsjjqraksqodbedhi4g bsfh07tgboot06tuhklbika5dt5gy0rz';
	    string richtest=SFDCEncoder.EncodeRichText(str,xssSanitizeStr);
	    test.stopTest();
	    system.assertNotEquals('&lt;script&gt;alert((&lt;/script&gt;',richtest);
	}
	
    static testMethod void encodeRichTextForPageMessage1(){
        List<String> xssSanitizeStr = new List<String>();
        List<XSSSanitization__mdt> lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues'];
        if(lstMetadata != null && !lstMetadata.isEmpty())
            xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c)? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();        
        test.startTest();
        string str='<script>alert()</script>';
        string richtest=SFDCEncoder.encodeRichTextForPageMessage(str,xssSanitizeStr);
        test.stopTest();
        system.assertNotEquals('&lt;script&gt;alert((&lt;/script&gt;',richtest);
    }
    
    static testMethod void encodeRichTextForPageMessage2(){
        List<String> xssSanitizeStr = new List<String>();
        List<XSSSanitization__mdt> lstMetadata = [SELECT Id,label, XSSSanitizationValues__c FROM XSSSanitization__mdt WHERE DeveloperName = 'XSSSanitizationValues'];
        if(lstMetadata != null && !lstMetadata.isEmpty())
            xssSanitizeStr = string.isNotBlank(lstMetadata[0].XSSSanitizationValues__c)? lstMetadata[0].XSSSanitizationValues__c.split(','): new List<String>();        
        test.startTest();
        string str='<a id=x tabindex=1 onfocus=alert(1)>';
        string richtest=SFDCEncoder.encodeRichTextForPageMessage(str,xssSanitizeStr);
        
        string str2='<a onbeforecut="alert(1)" contenteditable>test</a>';
        string richtest2=SFDCEncoder.encodeRichTextForPageMessage(str2,xssSanitizeStr);
        
        string str3='<base target="alert(1)"><a onclick="https://subdomain1.portswigger-labs.net/xss/xss.php?context=js_string_single&x=%27;eval(name)//">XSS via target in base tag</a>';
        string richtest3 =SFDCEncoder.encodeRichTextForPageMessage(str3,xssSanitizeStr);
        test.stopTest();
        system.assertNotEquals('&lt;script&gt;alert((&lt;/script&gt;',richtest);
    }   
    static testMethod void sanitizeJSONTest(){
        String orignalJson = '{"pageBlockId":"a1W4P00000HX9wEUAT","workspaceId":"0584P000000quM9QAI","hideRecall":" OR Status__c != null","parentId":"a1F4P000007aVHr","SnapshotName":"TestPDFName","accountId":null,"UserId":"0054P00000FWEqzQAH","programid":"a1i4P00000434PlQAI","goalRecordsIdSet":[],"parentRecordIdOfFlexTable":"a1i4P00000434PlQAI","RecordId":"a1i4P00000434PlQAI","recordId":"a1i4P00000434PlQAI","RecordId15":"a1i4P00000434P"}';
        string testJson ='{"KeynameList":["a2f050000002D5e","a2f050000002fQc","<xss onafterscriptexecute=alert(12345)><script>12345</script>","<marquee width=1 loop=1 onbounce=alert(54321)>XSS</marquee>",";alert(12345)"],"keyIds":["a2f0500000096lSAAQ","a2f0500000096lDAAQ"]}';
        test.startTest();
        string emptyJson = SFDCEncoder.sanitizeJSON('');
        string changeJson = SFDCEncoder.sanitizeJSON(orignalJson); 
        testJson = SFDCEncoder.sanitizeJSON(testJson);
        test.stopTest();
        system.assertNotEquals(changeJson,orignalJson);
    }   

    @isTest
    static void testSFDC_JSDECODE() {
        Test.startTest();
        String encodedInput = '\\u003C'; 
        String decodedOutput = SFDCEncoder.SFDC_JSDECODE(encodedInput);
        System.assertEquals('<', decodedOutput);
        Test.stopTest();
    }
}