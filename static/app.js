// Retreive shared secret
var secret = "";
var view = document.getElementById("main");

function init() {
    document.getElementById("main").innerHTML = "<h1>whatup?</h1>";

    var params = {
	method: "echo",
	id: 1,
	params: {text: "howdy!"}
    };

    var hash = CryptoJS.HmacSHA256("echo" + JSON.stringify(params.params), "secret");
    var hashInBase64 = CryptoJS.enc.Base64.stringify(hash);
    console.log("client signiture: ", hashInBase64);

    request(params, hashInBase64);

}

function request(params, hash) {
    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/_api");
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.setRequestHeader("signiture", hash);

    xhr.onload = function() {
	if (xhr.status === 200) {

	    var data = JSON.parse(xhr.response);
	    console.log("api response: ", xhr.response);
	} else {
	    console.log(xhr.status);
	}
    };

    xhr.send(JSON.stringify(params));
}
