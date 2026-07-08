// ───────────────────────────────
// CONFIGURACION
// ───────────────────────────────

const API = "http://localhost:8000";


// ───────────────────────────────
// FUNCIONES GENERALES
// ───────────────────────────────

async function fetchJSON(url, options = {}) {
    const res = await fetch(url, options);
    if (!res.ok) {
        const error = await res.json();
        alert("Error: " + error.detail);
        return null;
    }
    return res.json();
}

function jsonHeaders() {
    return { "Content-Type": "application/json" };
}


// ───────────────────────────────
// CATEGORIAS
// ───────────────────────────────

async function cargarCategorias() {
    const categorias = await fetchJSON(`${API}/categorias`);
    if (!categorias) return;

    const tbody = document.querySelector("#tabla-categorias tbody");
    tbody.innerHTML = "";

    for (const c of categorias) {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${c.id}</td>
            <td>${c.nombre}</td>
            <td>
                <button onclick="editarCategoria(${c.id}, '${c.nombre}')">Editar</button>
                <button onclick="eliminarCategoria(${c.id})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(row);
    }
}

async function crearCategoria(e) {
    e.preventDefault();
    const nombre = document.getElementById("cat-nombre").value;
    const resultado = await fetchJSON(`${API}/categorias`, {
        method: "POST",
        headers: jsonHeaders(),
        body: JSON.stringify({ nombre })
    });
    if (!resultado) return;
    document.getElementById("cat-nombre").value = "";
    cargarCategorias();
}

async function editarCategoria(id, nombreActual) {
    const nuevoNombre = prompt("Nuevo nombre:", nombreActual);
    if (!nuevoNombre) return;
    await fetchJSON(`${API}/categorias/${id}`, {
        method: "PUT",
        headers: jsonHeaders(),
        body: JSON.stringify({ nombre: nuevoNombre })
    });
    cargarCategorias();
}

async function eliminarCategoria(id) {
    if (!confirm("¿Eliminar esta categoría?")) return;
    await fetchJSON(`${API}/categorias/${id}`, { method: "DELETE" });
    cargarCategorias();
}


// ───────────────────────────────
// PROVEEDORES
// ───────────────────────────────

async function cargarProveedores() {
    const proveedores = await fetchJSON(`${API}/proveedores`);
    if (!proveedores) return;

    const tbody = document.querySelector("#tabla-proveedores tbody");
    tbody.innerHTML = "";

    for (const p of proveedores) {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${p.id}</td>
            <td>${p.nombre}</td>
            <td>${p.correo ?? "-"}</td>
            <td>${p.telefono ?? "-"}</td>
            <td>${p.direccion ?? "-"}</td>
            <td>
                <button onclick="editarProveedor(${p.id})">Editar</button>
                <button onclick="eliminarProveedor(${p.id})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(row);
    }
}

async function crearProveedor(e) {
    e.preventDefault();
    const data = {
        nombre:    document.getElementById("prov-nombre").value,
        correo:    document.getElementById("prov-correo").value   || null,
        telefono:  document.getElementById("prov-telefono").value || null,
        direccion: document.getElementById("prov-direccion").value || null
    };
    const resultado = await fetchJSON(`${API}/proveedores`, {
        method: "POST",
        headers: jsonHeaders(),
        body: JSON.stringify(data)
    });
    if (!resultado) return;
    document.getElementById("form-proveedor").reset();
    cargarProveedores();
}

async function editarProveedor(id) {
    const nombre    = prompt("Nuevo nombre:");
    const correo    = prompt("Nuevo correo:");
    const telefono  = prompt("Nuevo teléfono:");
    const direccion = prompt("Nueva dirección:");
    if (!nombre) return;
    await fetchJSON(`${API}/proveedores/${id}`, {
        method: "PUT",
        headers: jsonHeaders(),
        body: JSON.stringify({ nombre, correo, telefono, direccion })
    });
    cargarProveedores();
}

async function eliminarProveedor(id) {
    if (!confirm("¿Eliminar este proveedor?")) return;
    await fetchJSON(`${API}/proveedores/${id}`, { method: "DELETE" });
    cargarProveedores();
}


// ───────────────────────────────
// PRODUCTOS
// ───────────────────────────────

async function cargarProductos() {
    const productos = await fetchJSON(`${API}/productos`);
    if (!productos) return;

    const tbody = document.querySelector("#tabla-productos tbody");
    tbody.innerHTML = "";

    for (const p of productos) {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${p.id}</td>
            <td>${p.nombre}</td>
            <td>${p.descripcion ?? "-"}</td>
            <td>$${p.precio}</td>
            <td>${p.categoria_id ?? "-"}</td>
            <td>${p.proveedor_id ?? "-"}</td>
            <td>
                <button onclick="editarProducto(${p.id}, '${p.nombre}', ${p.precio})">Editar</button>
                <button onclick="eliminarProducto(${p.id})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(row);
    }
}

async function crearProducto(e) {
    e.preventDefault();
    const data = {
        nombre:       document.getElementById("prod-nombre").value,
        descripcion:  document.getElementById("prod-descripcion").value || null,
        precio:       parseFloat(document.getElementById("prod-precio").value),
        categoria_id: parseInt(document.getElementById("prod-categoria").value) || null,
        proveedor_id: parseInt(document.getElementById("prod-proveedor").value) || null
    };
    const resultado = await fetchJSON(`${API}/productos`, {
        method: "POST",
        headers: jsonHeaders(),
        body: JSON.stringify(data)
    });
    if (!resultado) return;
    document.getElementById("form-producto").reset();
    cargarProductos();
}

async function editarProducto(id, nombreActual, precioActual) {
    const nombre = prompt("Nuevo nombre:", nombreActual);
    const precio = prompt("Nuevo precio:", precioActual);
    if (!nombre || !precio) return;
    await fetchJSON(`${API}/productos/${id}`, {
        method: "PUT",
        headers: jsonHeaders(),
        body: JSON.stringify({ nombre, precio: parseFloat(precio) })
    });
    cargarProductos();
}

async function eliminarProducto(id) {
    if (!confirm("¿Eliminar este producto?")) return;
    await fetchJSON(`${API}/productos/${id}`, { method: "DELETE" });
    cargarProductos();
}


// ───────────────────────────────
// MOVIMIENTOS STOCK
// ───────────────────────────────

async function cargarMovimientos() {
    const movimientos = await fetchJSON(`${API}/movimientos`);
    if (!movimientos) return;

    const tbody = document.querySelector("#tabla-movimientos tbody");
    tbody.innerHTML = "";

    for (const m of movimientos) {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${m.id}</td>
            <td>${m.producto_id}</td>
            <td>${m.cantidad}</td>
            <td>${m.tipo}</td>
            <td>${new Date(m.fecha).toLocaleString("es-MX")}</td>
            <td>${m.notas ?? "-"}</td>
            <td>
                <button onclick="eliminarMovimiento(${m.id})">Eliminar</button>
            </td>
        `;
        tbody.appendChild(row);
    }
}

async function crearMovimiento(e) {
    e.preventDefault();
    const data = {
        producto_id: parseInt(document.getElementById("mov-producto").value),
        cantidad:    parseInt(document.getElementById("mov-cantidad").value),
        tipo:        document.getElementById("mov-tipo").value,
        notas:       document.getElementById("mov-notas").value || null
    };
    const resultado = await fetchJSON(`${API}/movimientos`, {
        method: "POST",
        headers: jsonHeaders(),
        body: JSON.stringify(data)
    });
    if (!resultado) return;
    document.getElementById("form-movimiento").reset();
    cargarMovimientos();
}

async function eliminarMovimiento(id) {
    if (!confirm("¿Eliminar este movimiento?")) return;
    await fetchJSON(`${API}/movimientos/${id}`, { method: "DELETE" });
    cargarMovimientos();
}

// ───────────────────────────────
// HISTORIAL
// ───────────────────────────────

// Maps table names and operations to readable Spanish labels
const TABLA_LABELS = {
    categorias:       "Categoría",
    proveedores:      "Proveedor",
    productos:        "Producto",
    movimientos_stock: "Movimiento de Stock"
};

const OPERACION_LABELS = {
    INSERT: "➕ Creado",
    UPDATE: "✏️ Editado",
    DELETE: "🗑️ Eliminado"
};

async function cargarHistorial() {
    const historial = await fetchJSON(`${API}/historial`);
    if (!historial) return;

    const tbody = document.querySelector("#tabla-historial tbody");
    tbody.innerHTML = "";

    for (const h of historial) {
        const row = document.createElement("tr");

        // Color code rows by operation type
        const colores = { INSERT: "#e6f9e6", UPDATE: "#fff8e1", DELETE: "#fde8e8" };
        row.style.backgroundColor = colores[h.operacion] ?? "";

        row.innerHTML = `
            <td>${h.id}</td>
            <td>${TABLA_LABELS[h.tabla] ?? h.tabla}</td>
            <td>${OPERACION_LABELS[h.operacion] ?? h.operacion}</td>
            <td>${h.registro_id ?? "-"}</td>
            <td>${h.descripcion ?? "-"}</td>
            <td>${new Date(h.fecha).toLocaleString("es-MX")}</td>
        `;
        tbody.appendChild(row);
    }
}