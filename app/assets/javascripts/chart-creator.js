var charts = (function () {

    // init the google charts api
    function publicInit() {

        // Load the Visualization API and the corechart package.
        google.charts.load('current', {
            'packages': ['corechart', 'table']
        });
    }

    function publicDrawFacebookFansTableFor(name, fbData, block) {
        var allValues = fbData;

        var data = new google.visualization.DataTable();
        data.addColumn('string', name);
        data.addColumn('number', 'Fans');

        for (var row in allValues) {
            data.addRow([(function () {
                    switch (name) {
                    case 'Country':
                        return getCountryName(row);
                    case 'Language':
                        return getLanguage(row.toLowerCase());
                    default:
                        return row;
                    }
                })(),
                     allValues[row]
            ]);
        }
        var options = {
            title: "Fans by " + name,
            height: 500,
            sortAscending: false,
            sortColumn: 1,
            allowHTML: true
        };
        var table = new google.visualization.Table(block);
        table.draw(data, options);

    }

    return {
        init: publicInit,
        drawFacebookFansTableFor: publicDrawFacebookFansTableFor
    }

})();
