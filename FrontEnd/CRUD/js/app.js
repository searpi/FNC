const url = 'http://localhost:9000/'
const container = document.querySelector('tbody')
const containerProd = document.getElementById('tbodyProds')
const containerAbono = document.getElementById('tbodyAbonos')
let resultCaficultores = ''
let resultProductos = ''
let resultAbonos = ''
let idCaficultor = ''

const modalCaficultor = new bootstrap.Modal(document.getElementById('modalCaficultor'))
const formCaficultor = document.querySelector('form')
const id_caficultor = document.getElementById('id_caficultor')
const nombre = document.getElementById('nombre')
const identificacion = document.getElementById('identificacion')
const ciudad = document.getElementById('ciudad')
let opcion = ''

function validateInput(field) {
    let errorField = field.nextElementSibling
    errorField.style.display = 'none'

    if (field.value.length < field.minLength) {  
        if (field.type == 'number') {          
            errorField.innerHTML = 'el numero debe ser de minimo ' + field.minLength + ' digitos'
        } else {
            errorField.innerHTML = 'el campo debe ser de minimo ' + field.minLength + ' caracteres'
        }
        errorField.style.display = 'block'
        return false
    }
    if (field.type == 'number' && 
         (parseInt(field.value) < parseInt(field.min) || parseInt(field.value) > parseInt(field.max))) {
        errorField.innerHTML = 'el numero debe estar entre ' + field.min + ' y ' + field.max
        errorField.style.display = 'block'
        return false
    }
    return true
}

function filterNumericInput(event, field) {
    let errorField = field.nextElementSibling
    errorField.style.display = 'none'

    // validaciones durante la edición del campo
    if (['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight'].includes(event.code)) {
        return true
    }
    if (event.code != 'Tab' && field.value.length == field.maxLength) {
        return false
    }
    if (event.key >= '0' && event.key <= '9') {
        return true
    }

    // validaciones al abandonar el campo
    if (event.code == 'Tab') {
        return validateInput(field)
    }
    return false
};

function filterTextInput(event, field, allowChars) {
    let errorField = field.nextElementSibling
    errorField.style.display = 'none'

    // validaciones durante la edición del campo
    if (['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight'].includes(event.code)) {
        return true
    }
    if (event.code != 'Tab' && field.value.length == field.maxLength) {
        return false
    }
    if (allowChars.includes('AlphaSym')) {
        return true
    }
    if (allowChars.includes('Alpha') || allowChars.includes('AlphaNum') || allowChars.includes('AlphaLow')) {
        if (' abcdefghijklmnñopqrstuvwxyz'.includes(event.key)) {
            return true
        }
    }
    if (allowChars.includes('Alpha') || allowChars.includes('AlphaNum') || allowChars.includes('AlphaUpp')) {
        if (' ABCDEFGHIJKLMNÑOPQRSTUVWXYZ'.includes(event.key)) {
            return true
        }
    }
    if (allowChars.includes('Numeric') || allowChars.includes('AlphaNum')) {
        if ('0123456789'.includes(event.key)) {
            return true
        }
    }

    // validaciones al abandonar el campo
    if (event.code == 'Tab') {
        return validateInput(field)
    }
    return false
};

// AMD = aaaa-mm-dd     DMA = dd/mm/aaaa
function formatDateAMDToDMA(dateInAMD, separatorDateDMA) {
    let dateInDMA = dateInAMD.substring(8) + separatorDateDMA +
                    dateInAMD.substring(5, 7) + separatorDateDMA +
                    dateInAMD.substring(0, 4)
    return dateInDMA
}

function formatDateDMAToAMD(dateInDMA, separatorDateAMD) {
    let dateInAMD = dateInDMA.substring(6) + separatorDateAMD +
                    dateInDMA.substring(3, 5) + separatorDateAMD +
                    dateInDMA.substring(0, 2)
    return dateInAMD
}

const on = (element, event, selector, handler) => {
    element.addEventListener(event, e => {
        if (e.target.closest(selector)) {
            handler(e)
        }
    })
}

// Tabla de Caficultores

const lista_caficultores = (caficultores) => {
    console.log(caficultores)
    const btnProd = '<a class="btnProd btn btn-primary cus-style-1" title="Productos"><i class="bi bi-credit-card-2-front"></i></a>'
    const btnAbonos = '<a class="btnAbonos btn btn-primary cus-style-2" title="Abonos"><i class="bi bi-cash-coin"></i></a>'
    const btnEditar = '<a class="btnEditar btn btn-primary" title="Modificar Caficultor"><i class="bi bi-pencil-square"></i></a>'
    const btnBorrar = '<a class="btnBorrarCaficultor btn btn-primary" title="Borrar Caficultor"><i class="bi bi-trash"></i></a>'
    caficultores.forEach(caficultor => {
        resultCaficultores += `<tr>
                            <td>${caficultor.id_caficultor}</td>
                            <td>${caficultor.nombre}</td>
                            <td>${caficultor.identificacion}</td>
                            <td>${caficultor.ciudad}</td>
                            <td class="text-center">${btnProd} ${btnAbonos} ${btnEditar} ${btnBorrar}</td>
                       </tr>
                      `
    })
    container.innerHTML = resultCaficultores
}

fetch(url + 'caficultores')
    .then( response => response.json() )
    .then( data => {
        console.log(data)
        lista_caficultores(data) 
    })
    .catch( error => alertify.alert(error) )

function filterByText() {
    var txtValue
    const input = document.getElementById("buscar")
    const filter = input.value.toUpperCase()
    tableBody = document.getElementById("tbodyCaficultores")
    const tr = tableBody.getElementsByTagName("tr")

    for (let rowText of tr) {
        txtValue = rowText.textContent || rowText.innerText
        if (txtValue.toUpperCase().indexOf(filter) > -1) {
            rowText.style.display = ""
        } else {
            rowText.style.display = "none"
        }
    }
}

btnCrear.addEventListener('click', () => {
    id_caficultor.value = ''
    nombre.value = ''
    identificacion.value = ''
    ciudad.value = ''
    id_caficultor.disabled = false
    modalCaficultor.show()
    opcion = 'crear'
})

formCaficultor.addEventListener('submit', (e) => {
    e.preventDefault()
    let caficultor = {
            id_caficultor:id_caficultor.value,
            nombre:nombre.value,
            identificacion:identificacion.value,
            ciudad:ciudad.value
        }
    //console.log(JSON.stringify(caficultor))
    
    if (opcion == 'crear') {    
        fetch(url + 'crear-caficultor', {
            method: 'POST',
            headers: {
                'Content-Type':'application/json'
            },
            body: JSON.stringify({
                id_caficultor:id_caficultor.value,
                nombre:nombre.value,
                identificacion:identificacion.value,
                ciudad:ciudad.value
            })
            //body: nombre.value  --> el backend devuelve un error
        })
        .then( response => response.json() )
        .then( data => {
            //console.log(data)
            alertify.alert(data.ErrCode + " - " + data.ErrMsg)
            if (data.ErrCode == 0) {
                const nuevoCaficultor = []
                nuevoCaficultor.push(caficultor)
                lista_caficultores(nuevoCaficultor)
            }
        })
    }

    if (opcion == 'editar') {    
        fetch(url + 'editar-caficultor', {
            method: 'PUT',
            headers: {
                'Content-Type':'application/json'
            },
            body: JSON.stringify({
                id_caficultor:id_caficultor.value,
                nombre:nombre.value,
                identificacion:identificacion.value,
                ciudad:ciudad.value
            })
            //body: nombre.value  --> el backend devuelve un error
        })
        .then( response => response.json() )
        .then( response => location.reload() )
    }

    modalCaficultor.hide()
})


on(document, 'click', '.btnEditar', e => {
    let fila = e.target
    while (fila.nodeName != 'TR') {
        fila = fila.parentNode
    }
    const idCaficultor = fila.children[0].innerHTML

    id_caficultor.value = fila.children[0].innerHTML
    nombre.value = fila.children[1].innerHTML
    identificacion.value = fila.children[2].innerHTML
    ciudad.value = fila.children[3].innerHTML
    id_caficultor.disabled = true
    modalCaficultor.show()
    opcion = 'editar'
})

on(document, 'click', '.btnBorrarCaficultor', e => {
    let fila = e.target
    while (fila.nodeName != 'TR') {
        fila = fila.parentNode
    }
    const idCaficultor = fila.children[0].innerHTML

    alertify.confirm('Está seguro que desea borrar el registro del caficultor con Id ' + idCaficultor + '?',
        function(){
            fetch(url + 'borrar-caficultor', {
                method: 'DELETE',
                headers: {
                    'Content-Type':'application/json'
                },
                body: JSON.stringify({
                    id_caficultor:idCaficultor
                })
            })
            .then( response => response.json() )
            .then( data => {
                //console.log(data)
                alertify.alert(data.ErrCode + " - " + data.ErrMsg)
                location.reload()
            })
        },
        function(){
            //alertify.error('Cancel');
        }
    )
})

function mostrarDiv(id) {
    if (id == 'prod') {
        document.getElementById('divCaficultores').style.display = 'none'
        document.getElementById('divProductos').style.display = 'block'
    }
    if (id == 'abono') {
        document.getElementById('divCaficultores').style.display = 'none'
        document.getElementById('divAbonos').style.display = 'block'
    }
}

function ocultarDiv(id) {
    if (id == 'prod') {
        document.getElementById('divProductos').style.display = 'none'
        document.getElementById('divCaficultores').style.display = 'block'
    }
    if (id == 'abono') {
        document.getElementById('divAbonos').style.display = 'none'
        document.getElementById('divCaficultores').style.display = 'block'
    }
}

// Tabla de Productos

const lista_productos = (productos) => {
    //console.log(productos)
    productos.forEach(producto => {
        //console.log(producto.id_caficultor)
        resultProductos += `<tr>
                            <td>${producto.id}</td>
                            <td>${producto.tipo_producto}</td>
                            <td>${producto.numero_cuenta}</td>
                            <td class="text-center"><a class="btnBorrarProd btn btn-primary cus-style-1" title="Borrar Producto"><i class="bi bi-trash"></i></a></td>
                       </tr>
                      `
    })
    containerProd.innerHTML = resultProductos
}

const cargar_productos = (idCaficultor) => {
    fetch(url + 'productos/' + idCaficultor.toString())
    .then( response => response.json() )
    .then( data => {
        //console.log(data)
        lista_productos(data) 
    })
    .catch( error => alertify.alert(error) )
}

on(document, 'click', '.btnProd', e => {
    let fila = e.target
    while (fila.nodeName != 'TR') {
        fila = fila.parentNode
    }
    idCaficultor = fila.children[0].innerHTML
    //console.log(idCaficultor)
    document.getElementById('labelIdCaficultor').innerHTML = idCaficultor + ' - ' + fila.children[1].innerHTML

    cargar_productos(idCaficultor)

    mostrarDiv('prod')
})

on(document, 'click', '.btnCerrarProds', e => {
    ocultarDiv('prod')
    resultProductos = ''
    idCaficultor = ''
})


// Operaciones con productos

const modalProducto = new bootstrap.Modal(document.getElementById('modalProducto'))
const formProducto = document.getElementById('formProducto')
const id_producto = document.getElementById('id_producto')
const tipo_producto = document.getElementById('tipo_producto')
const numero_cuenta = document.getElementById('numero_cuenta')
const labelIdCaficultor = document.getElementById('labelIdCaficultor')
let id_caficultor_prod = ''


btnCrearProducto.addEventListener('click', () => {
    console.log(labelIdCaficultor.innerHTML)
    // obtiene el id del caficultor del label de la pantalla
    id_caficultor_prod = labelIdCaficultor.innerHTML.substring(0, labelIdCaficultor.innerHTML.indexOf(' - '))
    console.log('<' + id_caficultor_prod + '>')
    id_producto.value = ''
    tipo_producto.value = ''
    numero_cuenta.value = ''
    modalProducto.show()
    opcion = 'crearProd'
})

formProducto.addEventListener('submit', (e) => {
    e.preventDefault()
    let producto = {
            id:id_producto.value,
            id_caficultor:id_caficultor_prod,
            tipo_producto:tipo_producto.value,
            numero_cuenta:numero_cuenta.value
        }
    console.log(JSON.stringify(producto))
         
    fetch(url + 'crear-producto', {
        method: 'POST',
        headers: {
            'Content-Type':'application/json'
        },
        body: JSON.stringify({
            id_producto:id_producto.value,
            id_caficultor:id_caficultor_prod,
            tipo_producto:tipo_producto.value,
            numero_cuenta:numero_cuenta.value
        })
        //body: nombre.value  --> el backend devuelve un error
    })
    .then( response => response.json() )
    .then( data => {
        //console.log(data)
        alertify.alert(data.ErrCode + " - " + data.ErrMsg)
        if (data.ErrCode == 0) {
            const nuevoProducto = []
            nuevoProducto.push(producto)
            lista_productos(nuevoProducto)
        }
    })
    modalProducto.hide()
})

on(document, 'click', '.btnBorrarProd', e => {
    let fila = e.target
    while (fila.nodeName != 'TR') {
        fila = fila.parentNode
    }
    const idProducto = fila.children[0].innerHTML

    alertify.confirm('Está seguro que desea borrar el registro del producto con Id ' + idProducto + '?',
        function(){
            fetch(url + 'borrar-producto', {
                method: 'DELETE',
                headers: {
                    'Content-Type':'application/json'
                },
                body: JSON.stringify({
                    id_producto:idProducto
                })
            })
            .then( response => response.json() )
            .then( data => {
                //console.log(data)
                alertify.alert(data.ErrCode + " - " + data.ErrMsg)
                resultProductos = ''
                cargar_productos(idCaficultor)
            })
        },
        function(){
            //alertify.error('Cancel');
        }
    )
})

// Tabla de Abonos

const lista_abonos = (abonos) => {
    //console.log(abonos)
    abonos.forEach(abono => {
        //console.log(abono.id_caficultor)
        if (abono.id.substring(0, 1) == '-') {
            resultAbonos += '<tr class="table-warning">'
        } else {
            resultAbonos += '<tr>'
        }
        resultAbonos += `   <td>${abono.id}</td>
                            <td>${abono.valor_abono}</td>
                            <td>${abono.fecha_abono}</td>
                            <td class="text-center"><a class="btnReversarAbono btn btn-primary cus-style-2" title="Reversar Abono"><i class="bi bi-arrow-counterclockwise"></i></a></td>
                       </tr>
                      `
    })
    containerAbono.innerHTML = resultAbonos
}

const cargar_abonos = (idCaficultor) => {
    fetch(url + 'abonos/' + idCaficultor.toString())
    .then( response => response.json() )
    .then( data => {
        //console.log(data)
        lista_abonos(data) 
    })
    .catch( error => alertify.alert(error) )
}

on(document, 'click', '.btnAbonos', e => {
    let fila = e.target
    while (fila.nodeName != 'TR') {
        fila = fila.parentNode
    }
    idCaficultor = fila.children[0].innerHTML
    //console.log(idCaficultor)
    document.getElementById('labelIdCaficultorEnAbono').innerHTML = idCaficultor + ' - ' + fila.children[1].innerHTML

    obtener_saldo_monedero(idCaficultor)
    cargar_abonos(idCaficultor)

    mostrarDiv('abono')
})

on(document, 'click', '.btnCerrarAbonos', e => {
    ocultarDiv('abono')
    resultAbonos = ''
    idCaficultor = ''
})

function filterByDate() {
    var fecha
    const fechaInicial = document.getElementById("fechaInicial").value
    const fechaFinal = document.getElementById("fechaFinal").value
    tableBody = document.getElementById("tbodyAbonos")
    const tr = tableBody.getElementsByTagName("tr")

    for (let rowText of tr) {
        fecha = formatDateDMAToAMD(rowText.getElementsByTagName("td")[2].innerText, '-') 
        if (fechaInicial && fechaFinal) {
            if (fecha >= fechaInicial && fecha <= fechaFinal) {
                rowText.style.display = ""
            } else {
                rowText.style.display = "none"
            }
        } else {
                rowText.style.display = ""
        }
    }
}

const obtener_saldo_monedero = (idCaficultor) => {
    fetch(url + 'saldo-monedero/' + idCaficultor.toString())
    .then( response => response.json() )
    .then( data => {
        console.log(data)
        document.getElementById('labelSaldoMonedero').innerHTML = 'Saldo = ' + data.saldo_monedero
    })
    .catch( error => alertify.alert(error) )
}


// Operaciones con abonos

const modalAbono = new bootstrap.Modal(document.getElementById('modalAbono'))
const formAbono = document.getElementById('formAbono')
const id_abono = document.getElementById('id_abono')
const valor_abono = document.getElementById('valor_abono')
const fecha_abono = document.getElementById('fecha_abono')
const labelIdCaficultorEnAbono = document.getElementById('labelIdCaficultorEnAbono')
let id_caficultor_abono = ''


btnCrearAbono.addEventListener('click', () => {
    console.log(labelIdCaficultorEnAbono.innerHTML)
    console.log('<' + id_caficultor_prod + '>')
    id_abono.value = ''
    valor_abono.value = ''
    fecha_abono.value = ''
    modalAbono.show()
})

const crearAbono = () => {
    // obtiene el id del caficultor del label de la pantalla
    id_caficultor_abono = labelIdCaficultorEnAbono.innerHTML.substring(0, labelIdCaficultorEnAbono.innerHTML.indexOf(' - '))
    let abono = {
            id:id_abono.value,
            id_caficultor:id_caficultor_abono,
            valor_abono:valor_abono.value,
            fecha_abono:formatDateAMDToDMA(fecha_abono.value, '/')
        }
    console.log(JSON.stringify(abono))
         
    fetch(url + 'crear-abono', {
        method: 'POST',
        headers: {
            'Content-Type':'application/json'
        },
        body: JSON.stringify({
            id_abono:id_abono.value,
            id_caficultor:id_caficultor_abono,
            valor:valor_abono.value,
            fecha:fecha_abono.value
        })
        //body: nombre.value  --> el backend devuelve un error
    })
    .then( response => response.json() )
    .then( data => {
        //console.log(data)
        alertify.alert(data.ErrCode + " - " + data.ErrMsg)
        if (data.ErrCode == 0) {
            const nuevoAbono = []
            nuevoAbono.push(abono)
            lista_abonos(nuevoAbono)
            obtener_saldo_monedero(idCaficultor)
        }
    })
}

formAbono.addEventListener('submit', (e) => {
    e.preventDefault()
    crearAbono()
    modalAbono.hide()
})

on(document, 'click', '.btnReversarAbono', e => {
    let fila = e.target
    while (fila.nodeName != 'TR') {
        fila = fila.parentNode
    }
    const idAbono = fila.children[0].innerHTML
    id_abono.value = '-' + fila.children[0].innerHTML
    valor_abono.value = '-' + fila.children[1].innerHTML
    fecha_abono.value = formatDateDMAToAMD(fila.children[2].innerHTML, '-')

    alertify.confirm('Está seguro que desea reversar el registro del abono con Id ' + idAbono + '?',
       function(){
            crearAbono()
       },
       function(){
           //alertify.error('Cancel');
       }
    )
})

