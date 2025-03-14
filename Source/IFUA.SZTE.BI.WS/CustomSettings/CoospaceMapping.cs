using System.Collections.Generic;
using System.Xml.Serialization;

namespace IFUA.SZTE.BI.CustomSettings
{
    public class CoospaceMapping
    {
        [XmlArray("MappingItems")]
        public List<CoospaceMappingItem> MappingItems { get; set; } = new List<CoospaceMappingItem>();

        public CoospaceMapping()
        {
        }
    }
}
