
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

//3
