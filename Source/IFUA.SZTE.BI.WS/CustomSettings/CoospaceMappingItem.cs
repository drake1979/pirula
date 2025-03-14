using System.Xml.Serialization;

namespace IFUA.SZTE.BI.CustomSettings
{
    [XmlType("MappingItem")]
    public class CoospaceMappingItem
    {
        /// <summary>
        /// [com].[Sources].[Source]
        /// </summary>
        public string SourceName { get; set; }

        /// <summary>
        /// E:\Import mappán belüli mappa útvonala
        /// </summary>
        public string ImportDirectoryPath { get; set; }

        /// <summary>
        /// Szintér URL-t kell itt megadni
        /// </summary>
        public string CoospaceBaseAddress { get; set; }

        /// <summary>
        /// Coospace névtéren létrehozott mappa URL-je
        /// </summary>
        public string CoospaceFolderUrl { get; set; }

        public CoospaceMappingItem()
        {
        }
    }
}