public with sharing class HttpFormBuilder {
    //  The boundary is alligned so it doesn't produce padding characters when base64 encoded.
    private final static String Boundary = '1ff13444ed8140c7a32fc4e6451aa76d';

    /**
     *  Returns the request's content type for multipart/form-data requests.
     */
    public static String getContentType(){
        return 'multipart/form-data; charset="UTF-8"; boundary="' + Boundary + '"';
    }

    /**
     *  Pad the value with spaces until the base64 encoding is no longer padded.
     */
    public static String safelyPad(String value, String valueCrLf64, String lineBreaks){
        String valueCrLf = '';
        blob valueCrLfBlob = null;

        while (valueCrLf64.endsWith('=')){
            value += ' ';
            valueCrLf = value + lineBreaks;
            valueCrLfBlob = blob.valueOf(valueCrLf);
            valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
            System.debug('@@@ Atributo  passando pelo safelyPad ' + value + '==> ' + valueCrLf64);
        }

        return valueCrLf64;
    }

    /**
     *  Write a boundary between parameters to the form's body.
     */
    public static string WriteBoundary(){
        string value = '--' + Boundary + '\r\n';
        blob valueBlob = blob.valueOf(value);

        return EncodingUtil.base64Encode(valueBlob);
    }

    public static string WriteStrBoundary(){
        string value = '--' + Boundary + '\r\n';

        return value;
    }

    /**
     *  Write a boundary at the end of the form's body.
     */
    public static string WriteBoundary(EndingType ending){
        string value = '';

        if(ending == EndingType.Cr){
            //  The file's base64 was padded with a single '=',
            //  so it was replaced with '\r'. Now we have to
            //  prepend the boundary with '\n' to complete
            //  the line break.
            value += '\n';
        }else if(ending == EndingType.None){
            //  The file's base64 was not padded at all,
            //  so we have to prepend the boundary with
            //  '\r\n' to create the line break.
            value += '\r\n';
        }
        //  Else:
        //  The file's base64 was padded with a double '=',
        //  so they were replaced with '\r\n'. We don't have to
        //  do anything to the boundary because there's a complete
        //  line break before it.

        value += '--' + Boundary + '--';

        blob valueBlob = blob.valueOf(value);

        return EncodingUtil.base64Encode(valueBlob);
    }

    public static string WriteStrBoundaryEnd(){
        return '--' + Boundary + '--';
    }


    /**
     *  Write a key-value pair to the form's body.
     */
    public static String writeBodyParameter(String key, String value){
        String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
        String contentDispositionCrLf = contentDisposition + '\r\n\r\n';
        blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
        String contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
        String content = safelyPad(contentDisposition, contentDispositionCrLf64, '\r\n\r\n');
        String valueCrLf = value + '\r\n';
        blob valueCrLfBlob = blob.valueOf(valueCrLf);
        String valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);
        content += safelyPad(value, valueCrLf64, '\r\n');

        System.debug('@@@ Atributo content sem o = ' + key + '==> ' + content);

        return content;
    }

    public static String writeBodyParameterFile(String key, String value){
        String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
        String contentDispositionCrLf = contentDisposition + '\r\n\r\n';
        blob contentDispositionCrLfBlob = blob.valueOf(contentDispositionCrLf);
        String contentDispositionCrLf64 = EncodingUtil.base64Encode(contentDispositionCrLfBlob);
        String content = safelyPad(contentDisposition, contentDispositionCrLf64, '\r\n\r\n');
        String valueCrLf = value + '\r\n';
        blob valueCrLfBlob = blob.valueOf(valueCrLf);
        String valueCrLf64 = EncodingUtil.base64Encode(valueCrLfBlob);

        content += safelyPad(value, valueCrLf64, '\r\n');

        return content;
    }


    public static String writeStrBodyParameter(String key, String value){
        String contentDisposition = 'Content-Disposition: form-data; name="' + key + '"';
        String content = contentDisposition + '\r\n\r\n';
        System.debug('@@@ Atributo contentDisposition sem o = ' + key + '==> ' + content);
        content += value;
        System.debug('@@@ Value Data ' + key + '==> ' + value);
        return content;
    }


    /**
     *  Helper enum indicating how a file's base64 padding was replaced.
     */
    public enum EndingType {
        Cr,
        CrLf,
        None
    }
}