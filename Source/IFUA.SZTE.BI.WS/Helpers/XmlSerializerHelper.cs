using System;
using System.IO;
using System.Xml;
using System.Xml.Serialization;

namespace IFUA.SZTE.BI.Helpers
{
    public static class XmlSerializerHelper
    {
        public static string Serialize<T>(T obj)
        {
            XmlSerializer xsSubmit = new XmlSerializer(typeof(T));
            using (var sww = new StringWriter())
            {
                using (XmlTextWriter writer = new XmlTextWriter(sww) { Formatting = Formatting.Indented })
                {
                    xsSubmit.Serialize(writer, obj);
                    return sww.ToString();
                }
            }
        }

        public static T DeserializeFromFile<T>(string coospaceMappingFilepath)
            where T : new()
        {
            if (!File.Exists(coospaceMappingFilepath))
                throw new ApplicationException($"File not found: {coospaceMappingFilepath}");

            var deserializedObject = new T();

            if (File.Exists(coospaceMappingFilepath))
            {
                using (var ms = new MemoryStream(File.ReadAllBytes(coospaceMappingFilepath)))
                {
                    var serializer = new XmlSerializer(typeof(T));
                    var genericObject = serializer.Deserialize(ms);
                    deserializedObject = (T)Convert.ChangeType(genericObject, typeof(T));
                }
            }

            if (deserializedObject == null)
                throw new Exception("Unable to deserialize CoospaceMapping");
            return deserializedObject;
        }
    }
}
