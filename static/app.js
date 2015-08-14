var view = document.getElementById("main");

// api request function
function request(params, hash) {
    var xhr = new XMLHttpRequest();

    xhr.open("POST", "/_api");
    xhr.setRequestHeader("Content-Type", "application/json");

    xhr.setRequestHeader("signiture", hash);

    xhr.onload = function() {
	if (xhr.status === 200) {
	    var data = JSON.parse(xhr.response);
	    console.log("api response: ", data);
	} else {
	    console.log(xhr.status);
	}
    };
    xhr.send(JSON.stringify(params));
}

function signMessage(method, params, sharedSecret) {
    console.log(method+JSON.stringify(params));
    var hash = CryptoJS.HmacSHA256(method+JSON.stringify(params), "secret");
    var hashInBase64 = CryptoJS.enc.Base64.stringify(hash);
    console.log(hashInBase64);
    return hashInBase64;
}

function init() {
    var params = {method: "table", params: {name: "raw_materials"}, id: 1};

    var a = reqwest({
	url: '/_api'
	, data: JSON.stringify(params)
	, method: 'post'
	, contentType: 'application/json'
	, headers: {
	    'signiture': signMessage(params.method, params.params, "secret")
	}
	, error: function (err) {
	    console.log(err);
	}
	, success: function (resp) {
	    console.log(resp);
	    var table = new Ractive({
		// The `el` option can be a node, an ID, or a CSS selector.
		el: '#main',

		// We could pass in a string, but for the sake of convenience
		// we're passing the ID of the script> tag above.
		template: '#table-template',

		// Here, we're passing in some initial data
		data: resp.result
	    });

	    //qwery('#content').html(resp.content)
	}
    });

}
