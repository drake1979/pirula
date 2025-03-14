namespace IFUA.SZTE.BI
{
    /// <summary>
    /// Állomány leíró osztály
    /// </summary>
    public class SourceFile
    {        
        /// <summary>Forrásrendszer</summary>
        public string SourceSystem { get; set; }

        /// <summary>Állomány elérése a Coospace szerveren</summary>
        public string FileUri { get; set; }

        /// <summary>Állomány eredeti neve</summary>
        public string FileName { get; set; }

        /// <summary>Állomány neve kisbetükkel</summary>
        public string FileNameLower { get; set; }

        public SourceFile()
        {
        }
    }
}