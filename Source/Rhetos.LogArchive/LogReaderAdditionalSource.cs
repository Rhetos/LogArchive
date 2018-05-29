using Rhetos.Compiler;
using Rhetos.DatabaseGenerator;
using Rhetos.Dsl;
using Rhetos.Dsl.DefaultConcepts;
using Rhetos.DatabaseGenerator.DefaultConcepts;
using Rhetos.Extensibility;
using System;
using System.Collections.Generic;
using System.ComponentModel.Composition;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Rhetos.LogArchive
{
    /// <summary>
    /// A low-level concept that inserts the SQL code snippet to the log reader SqlQueryable at the place of the given tag (an SQL comment).
    /// </summary>
    [Export(typeof(IConceptInfo))]
    [ConceptKeyword("LogReaderAdditionalSource")]
    public class LogReaderAdditionalSourceInfo : IConceptInfo
    {
        [ConceptKey]
        public SqlQueryableInfo SqlQueryable { get; set; }

        /// <summary>A description of the business rule or a purpose of the snippet.</summary>
        [ConceptKey]
        public string Name { get; set; }

        public DataStructureInfo DependendsOn { get; set; }

        public string Snippet { get; set; }

        public string GetTag() => $"/*{SqlQueryable.Module.Name}.{SqlQueryable.Name} AdditionalSource*/";
    }

    [Export(typeof(IConceptMacro))]
    public class LogReaderAdditionalSourceMacro : IConceptMacro<LogReaderAdditionalSourceInfo>
    {
        public IEnumerable<IConceptInfo> CreateNewConcepts(LogReaderAdditionalSourceInfo conceptInfo, IDslModel existingConcepts)
        {
            return new[]
            {
                new SqlDependsOnDataStructureInfo
                {
                    Dependent = conceptInfo.SqlQueryable,
                    DependsOn = conceptInfo.DependendsOn
                }
            };
        }
    }

    [Export(typeof(IConceptDatabaseDefinition))]
    [ExportMetadata(MefProvider.Implements, typeof(LogReaderAdditionalSourceInfo))]
    public class LogReaderAdditionalSourceDatabase : IConceptDatabaseDefinitionExtension
    {
        public string CreateDatabaseStructure(IConceptInfo conceptInfo)
        {
            return null;
        }

        public string RemoveDatabaseStructure(IConceptInfo conceptInfo)
        {
            return null;
        }

        public void ExtendDatabaseStructure(IConceptInfo conceptInfo, ICodeBuilder codeBuilder, out IEnumerable<Tuple<IConceptInfo, IConceptInfo>> createdDependencies)
        {
            var info = (LogReaderAdditionalSourceInfo)conceptInfo;
            codeBuilder.InsertCode(info.Snippet, info.GetTag());
            createdDependencies = null;
        }
    }
}
