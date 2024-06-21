/**
 * @description       :
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             :
 * @last modified on  : 03-02-2021
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * Modifications Log
 * Ver   Date         Author                               Modification
 * 1.0   03-02-2021   ChangeMeIn@UserSettingsUnder.SFDoc   Initial Version
 * 1.1   03-02-2021   windson santos                       PMD
 **/
public class MeetingInvitationFileFactory {
  public static Blob getFile(
    Datetime startDate,
    Datetime endDate,
    String subject,
    String description,
    String location,
    List<String> attendee
  ){
    return generateFile(generateFileContent(startDate, endDate, subject, description, location, attendee));
  }

  private static String generateFileContent(
    Datetime startDate,
    Datetime endDate,
    String subject,
    String description,
    String location,
    List<String> attendees
  ){
    String fileContent = '';
    fileContent += 'BEGIN:VCALENDAR\r\n';
    fileContent += 'METHOD:REQUEST\r\n';
    fileContent += 'PRODID:Salesforce\r\n';
    fileContent += 'VERSION:2.0\r\n';
    fileContent += 'BEGIN:VTIMEZONE\r\n';
    fileContent += 'TZID:America/Sao_Paulo\r\n';
    fileContent += 'BEGIN:STANDARD\r\n';
    fileContent += 'DTSTART:16010101T235959\r\n';
    fileContent += 'TZOFFSETFROM:-0200\r\n';
    fileContent += 'TZOFFSETTO:-0300\r\n';
    fileContent += 'RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=3SA;BYMONTH=2\r\n';
    fileContent += 'END:STANDARD\r\n';
    fileContent += 'BEGIN:DAYLIGHT\r\n';
    fileContent += 'DTSTART:16010101T235959\r\n';
    fileContent += 'TZOFFSETFROM:-0300\r\n';
    fileContent += 'TZOFFSETTO:-0200\r\n';
    fileContent += 'RRULE:FREQ=YEARLY;INTERVAL=1;BYDAY=1SA;BYMONTH=11\r\n';
    fileContent += 'END:DAYLIGHT\r\n';
    fileContent += 'END:VTIMEZONE\r\n';
    fileContent += 'BEGIN:VEVENT\r\n';
    fileContent += 'ORGANIZER;CN=' + UserInfo.getName() + ':MAILTO:' + UserInfo.getUserEmail() + '\r\n';
    for(String attendee : attendees){
      fileContent +=
        'ATTENDEE;ROLE=REQ-PARTICIPANT;PARTSTAT=NEEDS-ACTION;RSVP=TRUE;CN=' +
        attendee +
        ':MAILTO:' +
        attendee +
        '\r\n';
    }
    fileContent += 'DTSTAMP:' + DateUtil.unformattedDatetime(System.now()) + 'Z\r\n';
    fileContent += 'UID:' + DateUtil.unformattedDatetime(System.now()).remove('T') + '\r\n';
    fileContent += 'DTSTART;TZID=America/Sao_Paulo:' + DateUtil.unformattedDatetime(startDate) + '\r\n';
    fileContent += 'DTEND;TZID=America/Sao_Paulo:' + DateUtil.unformattedDatetime(endDate) + '\r\n';
    if(String.isNotBlank(subject)){
      fileContent += 'SUMMARY;LANGUAGE=pt-BR:' + subject + '\r\n';
    }
    if(String.isNotBlank(description)){
      fileContent += 'DESCRIPTION;LANGUAGE=pt-BR: ' + description + '\r\n';
    }
    if(String.isNotBlank(location)){
      fileContent += 'LOCATION:' + location + '\r\n';
      fileContent += 'CLASS:PUBLIC\r\n';
      fileContent += 'PRIORITY:5\r\n';
      fileContent += 'TRANSP:OPAQUE\r\n';
      fileContent += 'STATUS:CONFIRMED\r\n';
      fileContent += 'SEQUENCE:0\r\n';
      fileContent += 'X-MICROSOFT-CDO-APPT-SEQUENCE:0\r\n';
      fileContent += 'X-MICROSOFT-CDO-OWNERAPPTID:' + DateUtil.unformattedDatetime(System.now()).remove('T') + '\r\n';
      fileContent += 'X-MICROSOFT-CDO-BUSYSTATUS:TENTATIVE\r\n';
      fileContent += 'X-MICROSOFT-CDO-INTENDEDSTATUS:BUSY\r\n';
      fileContent += 'X-MICROSOFT-CDO-ALLDAYEVENT:FALSE\r\n';
      fileContent += 'X-MICROSOFT-CDO-IMPORTANCE:1\r\n';
      fileContent += 'X-MICROSOFT-CDO-INSTTYPE:0\r\n';
      fileContent += 'X-MICROSOFT-DONOTFORWARDMEETING:FALSE\r\n';
      fileContent += 'X-MICROSOFT-DISALLOW-COUNTER:FALSE\r\n';
      fileContent += 'X-MICROSOFT-LOCATIONS:[]\r\n';
      fileContent += 'BEGIN:VALARM\r\n';
      fileContent += 'DESCRIPTION:REMINDER\r\n';
      fileContent += 'TRIGGER;RELATED=START:-PT15M\r\n';
      fileContent += 'ACTION:DISPLAY\r\n';
      fileContent += 'END:VALARM\r\n';
      fileContent += 'END:VEVENT\r\n';
      fileContent += 'END:VCALENDAR';
    }
    return fileContent;
  }

  private static Blob generateFile(String fileContent){
    Blob file;
    if(fileContent != null){
      file = Blob.valueOf(fileContent);
    }
    return file;
  }
}