
db

show collections 

db.restaurantes.countDocuments ()

db.clientes.countDocuments()

db.pedidos.countDocuments()

db.pedidos.countDocuments()


db.restaurantes.insertOne({_id:"R13",nombre:"suchi nz",categoria:"Comida asiatica",ciudad:"Bogotá",barrio:"Chapinero",calificacion:4.3,domicilio:true,ubicacion:{type:"Point",coordinates:[-78.925,4.7856]},etiquetas:["suchi","almuerzo","económico"]})

db.productos.insertMany([{_id:"P25",restaurante_id:"R13",nombre:"Bibimbap coreano",tipo:"plato",precio:32000,stock:30,disponible:true},{_id:"P26",restaurante_id:"R13",nombre:"Pad Thai tailandés",tipo:"plato",precio:35000,stock:20,disponible:true},{_id:"P27",restaurante_id:"R13",nombre:"Shawarma árabe",tipo:"plato",precio:28000,stock:35,disponible:true},{_id:"P28",restaurante_id:"R13",nombre:"Kibbeh libanés",tipo:"plato",precio:30000,stock:25,disponible:true}])

db.restaurantes.find({ciudad:"Medellín"})

db.productos.countDocuments({restaurante_id:"R13"})



b/

db.pedidos.countDocuments({fecha:{$type:"date"}})

db.pedidos.countDocuments({fecha:{$not:{$type:"date"}}})

db.productos.countDocuments({precio:{$type:"string"}})


db.createCollection("resenas",{validator:{$jsonSchema:{bsonType:"object",required:["restaurante_id","cliente","calificacion","texto","fecha"],properties:{restaurante_id:{bsonType:"string"},cliente:{bsonType:"object",required:["id","nombre"],properties:{id:{bsonType:"string"},nombre:{bsonType:"string"}}},calificacion:{bsonType:"int",minimum:1,maximum:5},texto:{bsonType:"string",minLength:5},fecha:{bsonType:"date"},fotos:{bsonType:"array",maxItems:4,items:{bsonType:"string"}}}}}})



