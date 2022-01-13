public without sharing class DateTimeHelper {
  public static final String CENTRAL_TIME_ZONE = 'America/Chicago';

  /**
   * @param dtStr datetime string in format yyyy-MM-dd HH:mm:ss
   * @param zone timezone name e.g. 'America/Chicago'
   *
   * take dtStr as local datetime and zone as local timezone
   * construct DateTime with proper timezone calculation (Apex Datetime does not store
   * zone information, it always saves UTC in the backend).
   * @return Datetime
   */
  public static Datetime stringToDateTime(String dtStr, String zone) {
    if (dtStr == null || dtStr == '') {
      return null;
    }

    TimeZone z = TimeZone.getTimeZone(zone);
    TimeZone userTimezone = UserInfo.getTimeZone();

    Datetime dt = Datetime.valueOf(dtStr.replace('T', ' '));

    Integer diffInMin = (userTimezone.getOffset(dt) - z.getOffset(dt)) / (1000 * 60);

    return dt.addMinutes(diffInMin);
  }
  public static Datetime stringToDateTime(String dtStr) {
    return stringToDateTime(dtStr, DataTypeUtils.CENTRAL_TIME_ZONE);
  }

  /**
   * @param dt apex Datetime
   * @param zone timezone name e.g. 'America/Chicago'
   *
   * convert datetime to ISO8601 format string with timezone conversion.
   * Treat datetime as UTC time and return ISO string in the timezone specified.
   * e.g. dateTimeToIsoString(Datetime.valueOf('2020-10-09 05:39:00'), 'America/Chicago')
   * returns '2020-10-09T00:39:00-05:00'
   *
   * @return String
   */
  public static String dateTimeToIsoString(Datetime dt, String zone) {
    if (dt == null) {
      return null;
    }
    TimeZone z = TimeZone.getTimeZone(zone);
    Integer offsetInMin = z.getOffset(dt) / (1000 * 60);

    List<String> parts = String.valueOfGmt(dt.addMinutes(offsetInMin)).split('\\D');

    return parts[0] +
      '-' +
      parts[1].leftPad(2, '0') +
      '-' +
      parts[2].leftPad(2, '0') +
      'T' +
      parts[3].leftPad(2, '0') +
      ':' +
      parts[4].leftPad(2, '0') +
      ':' +
      parts[5].leftPad(2, '0') +
      (offsetInMin >= 0 ? '+' : '-') +
      String.valueOf(Math.abs(offsetInMin) / 60).leftPad(2, '0') +
      ':' +
      String.valueOf(Math.mod(offsetInMin, 60)).leftPad(2, '0');
  }
  public static String dateTimeToIsoString(Datetime dt) {
    return dateTimeToIsoString(dt, CENTRAL_TIME_ZONE);
  }
}
