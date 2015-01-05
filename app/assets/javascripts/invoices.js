var table;
var i;

function addRow() {
    var cloneRow = table.rows[1].cloneNode(true);
    var recordNo = (i-1).toString();
    var e1 = cloneRow.cells[0].getElementsByTagName("select")[0];
    e1.setAttribute("id", "invoice_line_items_attributes_" + recordNo + "_product_id");
    e1.setAttribute("name", "invoice[line_items_attributes][" +  recordNo + "][product_id]");
    var e2 = cloneRow.cells[1].getElementsByTagName("input")[0];
    e2.setAttribute("id", "invoice_line_items_attributes_" + recordNo + "_quantity");
    e2.setAttribute("name", "invoice[line_items_attributes][" +  recordNo + "][quantity]");
    e2.removeAttribute("value");

    var newRow = table.insertRow();
    newRow.innerHTML = cloneRow.innerHTML;
    i++;
}

function deleteRow() {
    if (i != 2) {
        table.deleteRow(i-1);
        i--;
    }
}

function setVars() {
    table = document.getElementById("line_item_form");
    i = table.rows.length;
}
