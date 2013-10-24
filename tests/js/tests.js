var init = function() {
	var article = document.getItems("http://schema.org/ScholarlyArticle")[0];
	console.log(article);
	var citations = article.properties["citation"];
	console.log(article.properties);

	var fetchData = function(doi, citation) {
		console.log(doi);

		asyncTest("reference", 1, function() {
			$.ajax({
				url: "http://data.crossref.org/" + encodeURIComponent(doi),
				dataType: "json",
				success: function(response) {
					console.log(response);
					var item = response.feed.entry["pam:message"]["pam:article"];

					var existing = citation.properties.name;
					if (existing && item["dc:title"]) {
						var existingTitle = existing.getValues()[0].toLowerCase().replace(/\.$/, "");
						var title = item["dc:title"].toLowerCase().replace(/\.$/, "");

						equal(existingTitle, title, "title does not match for " + doi);
						start();
					} else {
						ok(false, "no title");
						start();
					}
				},
				error: function(response) {
					ok(false, "Unknown DOI: " + doi);
					start();
				}
			});
		});
	};

	for (var i = 0; i < citations.length; i++) {
		var citation = citations[i];

		if (citation.properties.url) {
			var url = citation.properties.url.getValues()[0];

			var matches = url.match(/http:\/\/dx\.doi\.org\/(.+)/);

			if (!matches) {
				continue; // TODO: log
			}

			fetchData(decodeURIComponent(matches[1]), citation);
		}
	}
}

$(init);

