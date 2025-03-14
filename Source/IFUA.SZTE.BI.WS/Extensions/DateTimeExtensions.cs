using System;

namespace IFUA.SZTE.BI.Extensions
{
    public static class DateTimeExtensions
    {
        public static string TimeStamp(this DateTime dateTime, string formatString = "yyyyMMddHHmmss")
        {
            return dateTime.ToString(formatString);
        }
    }
}
