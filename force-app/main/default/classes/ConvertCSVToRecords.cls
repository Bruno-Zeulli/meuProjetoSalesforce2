public without sharing class ConvertCSVToRecords {
    @InvocableMethod(label='Convert CSV File to Records from single or multiple ContentDocumentIds')
    public static Response[] convert(Request[] inputs){
        Response[] responseList = new List<Response>{};

        for(Request curInput : inputs){
            Response output = new Response();
            output.convertedCSVRows = new List<SObject>{};
            if(curInput.contentDocumentId == null && curInput.contentDocumentIdList == null){
                throw new FlowCustomException(
                'You need to provide either a single ContentDocument Id OR a list of ContentDocumentIds as inputs to this Flow action.'
                );
            }else{
                // Easiest to just combine the inputs for processing
                if(curInput.contentDocumentId != null){
                    if(curInput.contentDocumentIdList == null){
                        curInput.contentDocumentIdList = new List<String>();
                    }
                    curInput.contentDocumentIdList.add(curInput.contentDocumentId);
                }
            }
            SObjectType sObjType = ((SObject) Type.forName(curInput.objectApiName).newInstance()).getSObjectType();
            Map<String, SObjectField> fieldMap = sObjType.getDescribe().fields.getMap();
            for(String curContentDocumentId : curInput.contentDocumentIdList){
                List<SObject> curFileConvertedCSVRows = new List<SObject>();
                Blob csvBlobContent = getCsvContent(curContentDocumentId);
                String csvStringContent = blobToString(csvBlobContent, 'UTF-8');
                String fSepRepl = '~`~';
                String newlineRepl = '-`-';
                csvStringContent = csvStringContent.replaceAll('(\r\n|\r)', '\n');
                csvStringContent = removeFSeps(csvStringContent, 0, curInput.FSep, fSepRepl, newlineRepl);
                String[] csvRows = csvStringContent.split('\n');
                String[] fields = csvRows[0].split(curInput.FSep); //Gives all the API names of the fields from the 1st CSV row
                csvRows.remove(0);
                Map<String, Schema.DisplayType> fieldToFieldTypeMap = new Map<String, Schema.DisplayType>();
                Map<String, String> fieldName = new Map<String, String>();
                for(String field : fields){
                    String fieldApiName = field.trim().replaceAll('[^a-zA-Z0-9_]', '');
                    if(fieldMap.get(fieldApiName.toLowerCase()) == null){
                        fieldApiName = fieldApiName.replaceAll('/', '_');
                        fieldApiName = fieldApiName.replaceAll(' ', '_').replaceAll('[^a-zA-Z0-9_]', ''); // Convert to alphanumeric and underscore
                        fieldApiName = fieldApiName.replaceAll('__', '_') + '__c'; // Remove extra _s and add __c to end
                    }
                    fieldToFieldTypeMap.put(field, getFieldType(fieldMap, fieldApiName));
                    fieldName.put(field, fieldApiName);
                }

                for(String row : csvRows){
                    row = replaceNewline(row, newlineRepl);
                    SObject obj = sObjType.newSObject();
                    //row = row.replace(curInput.Fsep + '"',curInput.Fsep).replace('"' + curInput.Fsep,curInput.Fsep);
                    String[] fieldInputValues = row.split(curInput.FSep, -1);
                    for(Integer i = 0; i < fields.size() && i < fieldInputValues.size(); i++){
                        String fieldValue = fieldInputValues[i]
                        .replace(curInput.Fsep + '"', curInput.Fsep)
                        .replace('"' + curInput.Fsep, curInput.Fsep);
                        fieldValue = replaceFSep(fieldValue, curInput.Fsep, fSepRepl);
                        fieldValue = removeQuotes(fieldValue); // Remove " characters if they bracket the field value
                        String Tsep = curInput.Tsep;
                        String Dsep = curInput.Dsep;
                        String vCur = curInput.vCur;
                        String dateFormat = curInput.dateFormat;
                        if(curInput.isTrim){
                            fieldValue = fieldValue.trim();
                        }
                        Schema.DisplayType fieldType = fieldToFieldTypeMap.get(fields[i]);
                         try{
                            obj.put(
                            fieldName.get(fields[i]),
                            getConvertedFieldValue(fieldType, fieldValue, Tsep, Dsep, vCur, dateFormat)
                            );
                        } catch (exception e){
                            obj.put(fieldName.get(fields[i]), null);
                        }
                    }
                    curFileConvertedCSVRows.add(obj);
                }
                output.convertedCSVRows.addAll(curFileConvertedCSVRows);
            }
            responseList.add(output);
        }
        return responseList;
    }

    private static Blob getCsvContent(String contentDocumentId){
        System.debug('contentDocumentId is: ' + contentDocumentId);
        ContentVersion csvFile = [
                                    SELECT VersionData
                                    FROM ContentVersion
                                    WHERE ContentDocumentId = :contentDocumentId AND IsLatest = TRUE
        ];
        System.debug('csvFile is: ' + csvFile);
        return csvFile.VersionData;
    }

    /* Converting the CSV file input(BLOB format) to a string */
    private static String blobToString(Blob input, String inCharset){
        String hex = EncodingUtil.convertToHex(input);
        System.assertEquals(0, hex.length() & 1);
        final Integer bytesCount = hex.length() >> 1;
        String[] bytes = new List<String>(bytesCount);
        for(Integer i = 0; i < bytesCount; ++i)
        bytes[i] = hex.mid(i << 1, 2);
        return EncodingUtil.urlDecode('%' + String.join(bytes, '%'), inCharset);
    }

    @TestVisible
    private static Object getConvertedFieldValue(
        Schema.DisplayType fieldType,
        String fieldValue,
        String Tsep,
        String Dsep,
        String vCur,
        String dateFormat
    ){
        Object convertedFieldValue;

        switch on
        fieldType { //Setting Field value based on the field data type
            when BOOLEAN {
                if(String.isEmpty(fieldValue)){
                    convertedFieldValue = false;
                }else{
                    String strFieldValue = String.valueOf(fieldValue).toLowerCase();
                    convertedfieldValue = strFieldValue == '1' || strFieldValue == 'true';
                }
            }
            when DOUBLE, CURRENCY, PERCENT,INTEGER {
                String fValue = fieldValue.replaceAll('[^0-9,;.\\-]', ''); //'-' added for handling negative numbers
                if(fValue.indexOf(Tsep) > -1){
                    String regexSep = Tsep;
                    if(Tsep == '.'){
                        regexSep = '\\.';
                    }
                    fValue = fValue.replaceAll(regexSep, '');
                }
                if(fValue.indexOf(Dsep) > -1){
                    fValue = fValue.replace(Dsep, '.');
                }
                if(fieldType == DisplayType.INTEGER){
                    convertedfieldValue = String.isEmpty(fValue) ? null : Integer.valueOf(fValue);
                }
                else{
                    convertedfieldValue = String.isEmpty(fValue) ? null : Decimal.valueOf(fValue);
                }
            }
            when DATE {
                /* replace / and : and . in fieldvalue by -  like in 2021.12.31 or 2021/12/31 or 2021:12:31 or 1.1.2021 or 31/12/2021 or 31:12:2021 */
                String fValue = fieldValue.replaceAll('[^0-9]', '-');
                List<String> lstSplit = fValue.split('-');
                if(fValue.indexOf('-') > 2){
                    /* Format found like YYYY-MM-DD */
                    Integer Year = Integer.valueOf(lstSplit[0]);
                    Integer Month = Integer.valueOf(lstSplit[1]);
                    Integer Day = Integer.valueOf(lstSplit[2]);
                    convertedfieldValue = String.isEmpty(fieldValue)
                    ? null
                    : date.valueOf(Year + '-' + ('0' + Month).Right(2) + '-' + ('0' + Day).Right(2));
                }else{
                    /* Format found like dd-MM-yyyy, convert to yyyy-MM-dd */
                    if(String.isBlank(dateFormat)){
                        lstSplit[0] = ('0' + lstSplit[0]).right(2);
                        lstSplit[1] = ('0' + lstSplit[1]).right(2);
                        fValue = String.join(lstSplit, '/');
                        convertedFieldValue = Date.parse(fValue); // use local date format if date format is not specified
                    }else if(dateFormat.toLowerCase().startsWith('dd')){
                        Integer Day = Integer.valueOf(lstSplit[0]);
                        Integer Month = Integer.valueOf(lstSplit[1]);
                        Integer Year = Integer.valueOf(lstSplit[2]);
                        convertedfieldValue = String.isEmpty(fieldValue)
                        ? null
                        : date.valueOf(Year + '-' + ('0' + Month).Right(2) + '-' + ('0' + Day).Right(2));
                    }else if(dateFormat.toLowerCase().startsWith('mm')){
                        Integer Month = Integer.valueOf(lstSplit[0]);
                        Integer Day = Integer.valueOf(lstSplit[1]);
                        Integer Year = Integer.valueOf(lstSplit[2]);
                        convertedfieldValue = String.isEmpty(fieldValue)
                        ? null
                        : date.valueOf(Year + '-' + ('0' + Month).Right(2) + '-' + ('0' + Day).Right(2));
                    }
                }
            }
            when else{
                convertedfieldValue = fieldValue;
            }
        }

        return convertedFieldValue;
    }

    private static String removeFSeps(String text, Integer eloc, String fSep, String fSepRepl, String newlineRepl){
        Integer sloc = -1;
        if(eloc == 0 && text.substring(eloc, 1) == '"'){
            sloc = 0;
        }else{
            sloc = getNextQuoteIndex(text, eloc, false);
        }
        if(sloc == -1){
            return text;
        }
        eloc = getNextQuoteIndex(text, sloc, true);
        if(eloc == -1){
            if(text.substring(text.length() - 1) == '"'){
                eloc = text.length() - 1;
            }else{
                return text;
            }
        }
        String subText = text.substring(sloc + 1, eloc).replace(fSep, fSepRepl).replace('\n', newlineRepl);
        String replText = text.substring(0, sloc + 1) + subText + text.substring(eloc);
        return removeFSeps(replText, eloc, fSep, fSepRepl, newlineRepl);
    }

    private static Integer getNextQuoteIndex(String text, Integer startingFrom, Boolean isClosing){
        Integer midRowQuote = text.indexOf(isClosing ? '",' : ',"', startingFrom);
        Integer startEndRowQuote = text.indexOf(isClosing ? '"\n' : '\n"', startingFrom);
        if(midRowQuote > -1){
            if(startEndRowQuote == -1){
                return midRowQuote;
            }else{
                return Math.min(startEndRowQuote, midRowQuote);
            }
        }else if(startEndRowQuote > -1){
            return startEndRowQuote;
        }
        return -1;
    }

    private static String replaceFSep(String text, String fSep, String fSepRepl){
        return text.replace(fSepRepl, fSep);
    }

    private static String replaceNewline(String text, String newlineRepl){
        return text.replace(newlineRepl, '\n');
    }

    private static String removeQuotes(String text){
        return text.removeStart('\"').removeEnd('\"').replace('""', '"'); //according to spec "" stands for a single " within a column.
    }

    @TestVisible
    private static Schema.DisplayType getFieldType(Map<String, SObjectField> fieldMap, String fieldApiName){
        if(fieldMap.get(fieldApiName) == null){
                throw new FlowCustomException(
                'Invalid Field Error: ' +
                fieldApiName +
                '. Please double check the API name of the field.'
            );
        }
        return fieldMap.get(fieldApiName).getDescribe().getType();
    }

    public class FlowCustomException extends Exception {}

    public class Request {
        public Request(){}

        @InvocableVariable(label='Object API Name' required=true)
        public String objectApiName;

        @InvocableVariable(
            label='Separator 1: Fields'
            description='Choose comma (input: , ) or semicolon (input: ; )'
            required=true
        )
        public String FSep;

        @InvocableVariable(
            label='Separator 2: Decimals'
            description='Choose decimal (input: .) or comma (input: , ) or semicolon (input: ; )'
            required=true
        )
        public String DSep;

        @InvocableVariable(
            label='Separator 3: Thousands'
            description='Choose comma (input: , ) or semicolon (input: ; )'
            required=true
        )
        public String TSep;

        @InvocableVariable(label='Symbol of Currency' description='Like $, €, £' required=true)
        public String vCur;

        @InvocableVariable(
            label='Date format'
            description='Date format used in the file. Default is yyyy-MM-dd or the local date format. Other supported formats are dd-MM-yyyy and MM-dd-yyyy'
        )
        public String dateFormat;

        @InvocableVariable(label='CSV (single) File ID')
        public string contentDocumentId;

        @InvocableVariable(label='CSV List of File IDs')
        public List<String> contentDocumentIdList;

        @InvocableVariable(label='Trim leading and trailing spaces')
        public Boolean isTrim = false;
    }

    public class Response {
        @InvocableVariable(label='List(collection) of Records')
        public List<SObject> convertedCSVRows;
    }
}