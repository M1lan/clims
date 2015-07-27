var httpRequest;

function request() {
    httpRequest = new XMLHttpRequest();
    var url = "/p";

    if (!httpRequest) {
        alert('Giving up :( Cannot create an XMLHTTP instance');
        return false;
    }

    httpRequest.onreadystatechange = alertContents;
    httpRequest.open('GET', url);
    httpRequest.send();
}

function alertContents() {
    if (httpRequest.readyState === 4) {
        if (httpRequest.status === 200) {
            var j = httpRequest.responseText;
            document.getElementById('json').innerHTML = j;
            //alert(httpRequest.responseText);
        } else {
            alert('There was a problem with the request.');
        }
    }
}
