using Dates


import win32com_.client
function DumpDB(db, bDeep = 1)
DumpTables(db, bDeep)
DumpRelations(db, bDeep)
DumpAllContainers(db, bDeep)
end

function DumpTables(db, bDeep = 1)
for tab in db.TableDefs
tab = TableDefs(db, tab.Name)
println("$(tab.Name)$(length(tab.Fields))$(tab.Attributes)")
if bDeep
DumpFields(tab.Fields)
end
end
end

function DumpFields(fields)
for field in fields
println("$(field.Name)$(field.Size)$(field.Required)$(field.Type)$(string(field.DefaultValue))")
end
end

function DumpRelations(db, bDeep = 1)
for relation in db.Relations
println("$(relation.Name)$(relation.Table)$(relation.ForeignTable)")
end
end

function DumpAllContainers(db, bDeep = 1)
for cont in db.Containers
println("$(cont.Name)$(length(cont.Documents)) documents")
if bDeep
DumpContainerDocuments(cont)
end
end
end

function DumpContainerDocuments(container)
for doc in container.Documents
timeStr = Dates.format(Dates.epochms2datetime(parse(Int, doc.LastUpdated)), Dates.RFC1123Format)
print("$(doc.Name)$(timeStr) (" )
println("$(doc.LastUpdated))")
end
end

function TestEngine(engine)
if length(append!([PROGRAM_FILE], ARGS)) > 1
dbName = append!([PROGRAM_FILE], ARGS)[2]
else
dbName = "e:\\temp\\TestPython.mdb"
end
db = OpenDatabase(engine, dbName)
DumpDB(db)
end

function test()
for progid in ("DAO.DBEngine.36", "DAO.DBEngine.35", "DAO.DBEngine.30")
try
ob = EnsureDispatch(win32com_.client.gencache, progid)
catch exn
if exn isa pythoncom.com_error
println("$(progid)does not seem to be installed")
end
end
end
end

if abspath(PROGRAM_FILE) == @__FILE__
test()
end