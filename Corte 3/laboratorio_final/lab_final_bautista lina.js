use("proyecto_geih")

print ("conteo de colecciones")

db.getCollectionNames().forEach(col => {print(col + ": " + db.getCollection(col).countDocuments());});
   |                                                                                  ^
db.indicador.aggregate([{$project:{ tipoFecha: {$type: "$fechaCalculoIndicador"}, tipoValor : {$type : "$valorIndicador"}}},{ $group: { _id: {fecha:"$tipofecha" , valor: "$tipovalor"}, total:{$sum:1}}}]);


//A3                                                                                  ^
db.indicador.aggregate([{$project:{ tipoFecha: {$type: "$fechaCalculoIndicador"}, tipoValor : {$type : "$valorIndicador"}}},{ $group: { _id: {fecha:"$tipofecha" , valor: "$tipovalor"}, total:{$sum:1}}}]);


db.indicador.countDocuments ({ valorIndicador: {$type: "number"}});

db.indicador .countDocuments({});

db.indicador.find({fechaCalculoIndicador :{ $not: {$type: "number"}}});

db.indicador.find({valorIndicador :{ $not: {$type: "number"}}});


// A4
var regla={bsonType:"object",required:["idIndicador","idTipoIndicador","valorIndicador","fechaCalculoIndicador","estado"],properties:{valorIndicador:{bsonType:["double","int","long","decimal"],minimum:0},fechaCalculoIndicador:{bsonType:"date"},estado:{enum:["pendiente","publicado","rechazado"]},etiquetas:{bsonType:"array",items:{bsonType:"string"}}}};print("Invalidos: "+db.lab_indicador.countDocuments({$nor:[{$jsonSchema:regla}]}));printjson(db.runCommand({collMod:"lab_indicador",validator:{$jsonSchema:regla},validationAction:"error"}));



// A5
try{db.lab_indicador.insertOne({idIndicador:999,idTipoIndicador:1,valorIndicador:-50,fechaCalculoIndicador:new Date(),estado:"pendiente",etiquetas:["GEIH"]});}catch(e){print("Error de validacion: "+e.message);}if(!db.lab_indicador.findOne({idIndicador:991051})){db.lab_indicador.insertOne({idIndicador:991051,idTipoIndicador:1,valorIndicador:45.5,fechaCalculoIndicador:new Date(),estado:"pendiente",etiquetas:["GEIH"],observacionExtra:"Campo nuevo"});}print("El valor negativo se rechaza y el campo extra se acepta.");


// B1
db.lab_indicador.deleteMany({idIndicador:{$in:[201,202,203]}});db.lab_indicador.insertMany([201,202,203].map(i=>({idIndicador:i,idTipoIndicador:1,valorIndicador:20+i-200,fechaCalculoIndicador:new Date(),estado:"pendiente",etiquetas:["GEIH"],detalle:{fuente:"GEIH"},mediciones:[{mes:1,valor:5},{mes:2,valor:25}]})));print("Se insertaron 3 indicadores.");

// B2
db.lab_indicador.find({valorIndicador:{$gte:20},estado:{$in:["pendiente","publicado"]}},{_id:0,idIndicador:1,valorIndicador:1,estado:1}).limit(10).forEach(printjson);

// B3
db.lab_indicador.find({"detalle.fuente":"GEIH"}).limit(3).forEach(printjson);db.lab_indicador.find({mediciones:{$elemMatch:{mes:1,valor:{$gte:20}}}}).limit(3).forEach(printjson);db.lab_indicador.find({"mediciones.mes":1,"mediciones.valor":{$gte:20}}).limit(3).forEach(printjson);print("elemMatch exige las dos condiciones en un mismo elemento; sin elemMatch pueden estar en elementos diferentes.");

// B4
var ultima=db.lab_indicador.find().sort({fechaCalculoIndicador:-1}).limit(1).toArray()[0].fechaCalculoIndicador;var fechaLocal=new Date(ultima.getTime()-18000000);var inicio=new Date(Date.UTC(fechaLocal.getUTCFullYear(),fechaLocal.getUTCMonth(),1,5));var fin=new Date(Date.UTC(fechaLocal.getUTCFullYear(),fechaLocal.getUTCMonth()+1,1,5));db.lab_indicador.find({fechaCalculoIndicador:{$gte:inicio,$lt:fin}}).sort({fechaCalculoIndicador:-1}).limit(10).forEach(printjson);

// B5
db.lab_persona.find().sort({edad:1,_id:1}).skip(10).limit(10).forEach(printjson);

// B6
var a=db.lab_indicador.updateOne({idIndicador:201,estado:"pendiente"},{$set:{estado:"publicado"}});var b=db.lab_indicador.updateOne({idIndicador:201},{$inc:{valorIndicador:2}});var c=db.lab_indicador.updateOne({idIndicador:201},{$addToSet:{etiquetas:"revisado"}});var d=db.lab_indicador.updateOne({idIndicador:991051},{$unset:{observacionExtra:""}});[a,b,c,d].forEach((r,i)=>print("Cambio "+(i+1)+": matched="+r.matchedCount+", modified="+r.modifiedCount));

// B7
for(var i=0;i<2;i++){printjson(db.lab_indicador.updateOne({idIndicador:299},{$setOnInsert:{idIndicador:299,idTipoIndicador:1,valorIndicador:15,fechaCalculoIndicador:new Date(),estado:"pendiente"}},{upsert:true}));}print("Antes: "+db.lab_indicador.countDocuments({idIndicador:299}));printjson(db.lab_indicador.deleteMany({idIndicador:299}));

// C1
db.lab_indicador.aggregate([{$match:{valorIndicador:{$gte:0}}},{$group:{_id:"$idTipoIndicador",cantidad:{$sum:1},promedio:{$avg:"$valorIndicador"},minimo:{$min:"$valorIndicador"},maximo:{$max:"$valorIndicador"}}},{$project:{tipo:"$_id",cantidad:1,promedio:{$round:["$promedio",2]},minimo:1,maximo:1,_id:0}},{$sort:{promedio:-1}}]).forEach(printjson);

// C2
db.lab_indicador.aggregate([{$group:{_id:{$dateToString:{format:"%Y-%m",date:"$fechaCalculoIndicador",timezone:"America/Bogota"}},cantidad:{$sum:1},promedio:{$avg:"$valorIndicador"}}},{$sort:{_id:1}}]).forEach(printjson);



// C3
db.lab_indicador.aggregate([{$unwind:"$etiquetas"},{$group:{_id:"$etiquetas",cantidad:{$sum:1}}},{$sort:{cantidad:-1}},{$limit:5}]).forEach(printjson);

// C4
db.lab_indicador.aggregate([{$lookup:{from:"lab_tipo",localField:"idTipoIndicador",foreignField:"idTipoIndicador",as:"tipo"}},{$unwind:"$tipo"},{$project:{_id:0,idIndicador:1,nombre:"$tipo.nombre",valorIndicador:1}},{$limit:10}]).forEach(printjson);print("Esta consulta es frecuente en el tablero. Podria copiar el nombre, pero tendria que actualizarlo si cambia.");

// C5
db.lab_indicador.aggregate([{$group:{_id:"$idTipoIndicador",cantidad:{$sum:1}}},{$match:{cantidad:{$gt:5}}}]).forEach(printjson);

// C6
db.lab_indicador.aggregate([{$match:{idTipoIndicador:1,valorIndicador:{$gt:20}}},{$count:"indicadoresParaRevision"}]).forEach(printjson);print("Conviene revisar indicadores de desocupacion altos antes de publicarlos. Esto ayuda a detectar situaciones que necesitan analisis.");

// parte D 

db.lab_volumen.drop();var base=db.lab_indicador.find({},{_id:0}).toArray();for(var i=0;i<50000;i+=1000){var lote=Array.from({length:1000},(_,j)=>({...base[(i+j)%base.length],idIndicador:100000+i+j,fechaCalculoIndicador:new Date(Date.UTC(2026,(i+j)%12,15))}));db.lab_volumen.insertMany(lote);}print("Total volumen: "+db.lab_volumen.countDocuments({}));

// D1
var filtro={idTipoIndicador:1,valorIndicador:{$gte:20}};var antes=db.lab_volumen.find(filtro).sort({fechaCalculoIndicador:-1}).limit(10).explain("executionStats");var resumen=x=>({etapas:JSON.stringify(x.queryPlanner.winningPlan).match(/"stage"\s*:\s*"[A-Z_]+"/g),devueltos:x.executionStats.nReturned,claves:x.executionStats.totalKeysExamined,documentos:x.executionStats.totalDocsExamined,ms:x.executionStats.executionTimeMillis});print("ANTES:");printjson(resumen(antes));

// D2
db.lab_volumen.createIndex({idTipoIndicador:1,fechaCalculoIndicador:-1,valorIndicador:1},{name:"indiceESR"});var despues=db.lab_volumen.find(filtro).sort({fechaCalculoIndicador:-1}).limit(10).explain("executionStats");print("DESPUES:");printjson(resumen(despues));print("Igualdad: tipo; orden: fecha; rango: valor.");printjson([{caso:"Antes",...resumen(antes)},{caso:"Despues",...resumen(despues)}]);


// D3
db.lab_persona.createIndex({idPersona:1},{unique:true});try{db.lab_persona.insertOne({idPersona:1,edad:25,sexo:"Mujer"});}catch(e){print("Duplicado rechazado: "+e.message);}

// D4
db.lab_volumen.createIndex({campoTemporal:1},{name:"indiceSinUso"});printjson(db.lab_volumen.stats().indexSizes);db.lab_volumen.aggregate([{$indexStats:{}}]).forEach(printjson);db.lab_volumen.dropIndex("indiceSinUso");print("Los indices ocupan espacio y hacen que las escrituras necesiten mas trabajo. Elimine el indice sin uso.");

// E1
print("Publicar un indicador y registrar su auditoria requiere una transaccion porque ambas operaciones deben completarse. Agregar una etiqueta solo necesita updateOne porque modifica un documento.");

// E2
function publicar(id,aprobar){var s=db.getMongo().startSession();var x=s.getDatabase("proyecto_geih");try{s.startTransaction();var r=x.lab_indicador.updateOne({idIndicador:id,estado:"pendiente"},{$set:{estado:"publicado"}});if(r.modifiedCount!==1)throw Error("No esta pendiente");if(!aprobar)throw Error("No aprobado");x.lab_auditoria.insertOne({idIndicador:id,accion:"PUBLICAR",fecha:new Date()});s.commitTransaction();print("Confirmada "+id);}catch(e){try{s.abortTransaction();}catch(_){}print("Abortada "+id+": "+e.message);}finally{s.endSession();}}if(db.adminCommand({hello:1}).setName){db.lab_indicador.updateMany({idIndicador:{$in:[202,203]}},{$set:{estado:"pendiente"}});print("ANTES");printjson(db.lab_indicador.find({idIndicador:{$in:[202,203]}}).toArray());publicar(202,true);publicar(203,false);print("DESPUES");printjson(db.lab_indicador.find({idIndicador:{$in:[202,203]}}).toArray());print("Auditoria confirmada: "+db.lab_auditoria.countDocuments({idIndicador:202}));print("Auditoria abortada: "+db.lab_auditoria.countDocuments({idIndicador:203}));}else{print("E2 necesita un replica set para ejecutar transacciones.");}



// E3
try{printjson(rs.status().members.map(m=>m.name+" "+m.stateStr));print("Primario: "+db.hello().isWritablePrimary);db.lab_auditoria.insertOne({idIndicador:400,accion:"PRUEBA",fecha:new Date()},{writeConcern:{w:"majority"}});db.getSiblingDB("local").getCollection("oplog.rs").find({ns:"proyecto_geih.lab_auditoria",op:"i","o.idIndicador":400}).sort({$natural:-1}).limit(1).forEach(printjson);}catch(e){print("E3 requiere replica set o permisos: "+e.message);}print("Usaria tres nodos para mantener disponibilidad. Un borrado accidental se replica y solo un respaldo anterior permitiria recuperar esos datos.");

// E4

print("Fecha: cardinalidad alta, escrituras recientes frecuentes, monotonica y consultas por fecha. Estado: cardinalidad baja, frecuencia desigual, no monotonica y consultas por estado. idIndicador hashed: cardinalidad alta, escrituras distribuidas, no monotonica y consultas dirigidas por ID. Elegiria idIndicador hashed para distribuir escrituras, aunque las consultas por periodo podrian recorrer varios shards. Con el volumen actual no necesito sharding; lo evaluaria con millones de documentos y problemas de rendimiento. No usaria zonas.");

// FINAL
print("LABORATORIO FINALIZADO");
