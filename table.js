function extendTable (rowObject) {
    var table = document.getElementById("a");

    // arg is the table index where new row will be
    var row = table.insertRow(table.length);

    // add cells and then place text in them
    var firstnameCell = row.insertCell(0).innerHTML = rowObject.firstname;
    var lastnameCell = row.insertCell(1).innerHTML = rowObject.lastname;
    var ageCell = row.insertCell(2).innerHTML = rowObject.age;
};

window.onload = (function () {
    extendTable({
        firstname:"Ralph",
        lastname:"Dickbag",
        age:42
    })
});
