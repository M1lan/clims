var secret = "secret";

function signRequest(params, sharedSecret) {
    var hash = CryptoJS.HmacSHA256(params.method + JSON.stringify(params.params), sharedSecret);
    var hashInBase64 = CryptoJS.enc.Base64.stringify(hash);
    return hashInBase64;
}

function api(params) {
    var hash = signRequest(params, secret);    
    return reqwest({
	url: "/_api"
	, method: "POST"
	, type: "json"
	, headers: {
	    signiture: hash
	}
	, data: JSON.stringify(params)
    });
}

function init() {
    console.log("init()");
}


