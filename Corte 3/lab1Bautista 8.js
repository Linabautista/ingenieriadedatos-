use saborya

// PARTE B

// B1
db.pedidos.countDocuments({fecha:{$type:"date"}})
db.pedidos.countDocuments({fecha:{$not:{$type:"date"}}})
db.productos.countDocuments({precio:{$type:"string"}})


// B3
db.createCollection("resenas",{validator:{$jsonSchema:{bsonType:"object",required:["restaurante_id","cliente","calificacion","texto","fecha"],properties:{restaurante_id:{bsonType:"string"},cliente:{bsonType:"object",required:["id","nombre"],properties:{id:{bsonType:"string"},nombre:{bsonType:"string"}}},calificacion:{bsonType:"int",minimum:1,maximum:5},texto:{bsonType:"string",minLength:5},fecha:{bsonType:"date"},fotos:{bsonType:"array",maxItems:4,items:{bsonType:"string"}}}}}})

// B4
db.resenas.insertMany([{restaurante_id:"R02",cliente:{id:"C01",nombre:"Laura Gómez"},calificacion:NumberInt(5),texto:"El ramen llegó caliente y bien empacado",fecha:new Date("2026-10-15T20:10:00-05:00")},{restaurante_id:"R02",cliente:{id:"C08",nombre:"Julián Castro"},calificacion:NumberInt(4),texto:"Buen sushi, pero tardó 50 minutos",fecha:new Date("2026-10-16T21:30:00-05:00")},{restaurante_id:"R10",cliente:{id:"C07",nombre:"Daniela Martínez"},calificacion:NumberInt(5),texto:"La cazuela es abundante",fotos:["https://cdn.saborya.co/r/301.jpg","https://cdn.saborya.co/r/302.jpg"],fecha:new Date("2026-10-17T13:45:00-05:00")},{restaurante_id:"R04",cliente:{id:"C03",nombre:"Valentina Ríos"},calificacion:NumberInt(2),texto:"Las papas llegaron frías",fecha:new Date("2026-10-18T19:05:00-05:00")}])

// B5
try{db.resenas.insertOne({restaurante_id:"R01",cliente:{id:"C01",nombre:"Laura Gómez"},calificacion:NumberInt(6),texto:"Muy buen servicio",fecha:new Date("2026-10-19T12:00:00-05:00")})}catch(e){print(e.message)}

// El error ocurre porque la calificación máxima permitida es 5 y se intentó insertar 6. Por eso MongoDB no acepta la reseña.

// B6
db.resenas.find({"cliente.id":"C01"})
db.resenas.find({"fotos.0":{$exists:true}})

// B7
db.restaurantes.updateOne({_id:"R02"},{$set:{resumen_resenas:{promedio:4.5,total:2}}})

// El promedio se calcula (5+4)/2 = 4.5 y el total es 2 reseñas.

// B8
db.resenas.distinct("restaurante_id")


// PARTE C

// C1
db.productos.find({tipo:"plato",disponible:true,stock:{$lt:20}},{nombre:1,stock:1,_id:0}).sort({stock:1})

// C2
db.pedidos.find({total:{$gte:50000,$lte:80000},metodo_pago:{$in:["efectivo","nequi"]}},{total:1,metodo_pago:1,_id:0})

// C3
db.restaurantes.find({ciudad:"Bogotá"},{nombre:1,calificacion:1,_id:0}).sort({calificacion:-1}).limit(3)

// C4
db.clientes.find({ciudad:"Bogotá",puntos:{$gt:100}},{nombre:1,puntos:1,_id:0})

// C5
db.pedidos.find({fecha:{$gte:new Date("2026-10-12T00:00:00-05:00"),$lt:new Date("2026-10-15T00:00:00-05:00")},estado:{$ne:"entregado"}},{fecha:1,estado:1,_id:0})

// C6
db.pedidos.find({items:{$elemMatch:{precio:{$lt:10000},cantidad:{$gte:2}}}},{_id:1})

db.pedidos.find({"items.precio":{$lt:10000},"items.cantidad":{$gte:2}},{_id:1})

// C7
db.productos.find({},{nombre:1,precio:1,_id:0}).sort({precio:-1,_id:1}).skip(6).limit(6)

// C8
db.restaurantes.find({$or:[{horario:{$exists:true}},{menu_vegano:{$exists:true}}]},{nombre:1,horario:1,menu_vegano:1,_id:0})

//D1
db.productos.updateMany ({restaurante_id: "R07" , tipo: "plato"}, {$inc :{precio:1000}})

//D2

db.pedidos.updateOne({_id:"PD018",estado:"pendiente"},{$set:{estado:"en_camino"}})
db.pedidos.updateOne({_id:"PD018",estado:"pendiente"},{$set:{estado:"en_camino"}})

//D3
db.clientes.updateOne({_id:"C03"},{$addToSet:{preferencias:"japonesa"}})
db.clientes.updateOne({_id:"C03"},{$addToSet:{preferencias:"japonesa"}})

//D4
db.clientes.updateOne ({email: "natalia.suarez@example.com"}, {$setOnInsert: {_id:"C09", nombre:"Natalia Súarez", ciudad:"Medellín , puntos:0", direcciones: []}}, {upsert:true})

//D5
db.productos.updateOne ({_id:"P06"}, {$unset:{volumen_ml:" "}})

//D6
db.resenas.countDocuments({calificacion:{$lt:3}})
db.resenas.deleteMany ({estado:"cancelado", "restaurante.ciudad":"Medellín"})

//D7
db.pedidos.countDocuments ({estado: "cancelado", "resataurante.ciudad": "Medellín"})
db.pedidos.deleteMany({estado:"cancelado","restaurante.ciudad":"Medellín"})

//D8
db.restaurantes.countDocuments()
db.clientes.countDocuments()
db.productos.countDocuments()
db.pedidos.countDocuments()
db.resenas.countDocuments()


