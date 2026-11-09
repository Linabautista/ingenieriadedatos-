
lunes 8 am el gerente de sabor ya escribe : 'necesito para las 8:05las ventas de los pedidos entregados por restaurante de mayor a menor con lo que sabemos hasta hoy solo tenemos find 
 db.pedidos.find({estado:"entregado"}, {_id:0,"restaurante.nombre":1, total:1})

db.pedidos.find({}, {estado:1, _id:0})

db.pedidos.find({},{total:1,_id:0})


db.pedidos.find({},{"restaurante.nombre":1,_id:0})

db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$restaurante.nombre",ventas:{$sum:"$total"}}},{$sort:{ventas:-1}}])

db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$restaurante.nombre",ventas:{$sum:"$total"}}},{$sort:{ventas:-1}}])
db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$restaurante.nombre",ventas:{$avg:"$total"}}},{$sort:{ventas:-1}}])
db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$restaurante.nombre",ventas:{$min:"$total"}}},{$sort:{ventas:-1}}])
db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$restaurante.nombre",ventas:{$max:"$total"}}},{$sort:{ventas:-1}}])

//1
db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$metodo_pago", ventas:{$sum:"$total"}}}])

//2
db.pedidos.aggregate([{$match:{estado:"cancelado"}},{$count:"cancelados"}])

// 3
db.restaurantes.aggregate([{$lookup:{from:"productos",localField:"_id",foreignField:"restaurante_id",as:"menu"}},{$unwind:"$menu"},{$match:{"menu.disponible":true}},{$group:{_id:"$_id",platos:{$push:"$menu.nombre"},precio_maximo:{$max:"$menu.precio"}}},{$sort:{_id:1}},{$limit:3}])

// 4
db.productos.aggregate([{$group:{_id:"$tipo",promedio:{$avg:"$precio"}}}])

// 5
db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$cliente.nombre",gasto:{$sum:"$total"}}},{$sort:{gasto:-1}},{$limit:3}])

// 6
db.pedidos.aggregate([{$match:{estado:"entregado"}},{$group:{_id:"$restaurante.nombre",ventas:{$sum:"$total"}}},{$match:{ventas:{$gt:70000}}}])

// 7
db.pedidos.aggregate([{$match:{estado:{$in:["pendiente","en_camino"]}}},{$lookup:{from:"clientes",localField:"cliente.id",foreignField:"_id",as:"cliente_info"}},{$unwind:"$cliente_info"},{$project:{estado:1,email:"$cliente_info.email"}}])