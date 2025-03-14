using System;

namespace IFUA.SZTE.BI.Helpers
{
    public static class DateTimeHelpers
    {
        public static string TimeStamp(string formatString = "yyyyMMddHHmmss")
        {
            return DateTime.Now.ToString(formatString);
        }
    }
}
