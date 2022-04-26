function generate_table() {
    const data = {
        "England & NW Europe":{
            "Michele Noonan":39,
            "Gregory Feron":40,
            "David Feron":66,
            "Marilyn Feron":4,
            "Kathy Mortenson":3,
            "Eileen Shanley":0,
            "Emily Mortenson":13,
            "Michael Feron":40,
            "Josie Feron":31,
            "Heather Paul":19,
            "Colton Paul":47,
            "Cody Paul":34
        },
        "Ireland":{
            "Michele Noonan":3,
            "Gregory Feron":8,
            "David Feron":7,
            "Marilyn Feron":72,
            "Kathy Mortenson":82,
            "Eileen Shanley":71,
            "Emily Mortenson":39,
            "Michael Feron":30,
            "Josie Feron":43,
            "Heather Paul":5,
            "Colton Paul":6,
            "Cody Paul":2
        },
        "Scotland":{
            "Michele Noonan":8,
            "Gregory Feron":11,
            "David Feron":6,
            "Marilyn Feron":21,
            "Kathy Mortenson":8,
            "Eileen Shanley":20,
            "Emily Mortenson":38,
            "Michael Feron":22,
            "Josie Feron":12,
            "Heather Paul":38,
            "Colton Paul":4,
            "Cody Paul":35
        },
        "Wales":{
            "Michele Noonan":4,
            "Gregory Feron":2,
            "David Feron":0,
            "Marilyn Feron":2,
            "Kathy Mortenson":4,
            "Eileen Shanley":7,
            "Emily Mortenson":0,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":1,
            "Colton Paul":0,
            "Cody Paul":0
        },
        "Germanic Europe":{
            "Michele Noonan":9,
            "Gregory Feron":8,
            "David Feron":6,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":2,
            "Emily Mortenson":0,
            "Michael Feron":3,
            "Josie Feron":6,
            "Heather Paul":22,
            "Colton Paul":11,
            "Cody Paul":11
        },
        "Norway":{
            "Michele Noonan":13,
            "Gregory Feron":16,
            "David Feron":2,
            "Marilyn Feron":0,
            "Kathy Mortenson":3,
            "Eileen Shanley":0,
            "Emily Mortenson":1,
            "Michael Feron":2,
            "Josie Feron":6,
            "Heather Paul":0,
            "Colton Paul":6,
            "Cody Paul":3
        },
        "Sweden & Denmark":{
            "Michele Noonan":7,
            "Gregory Feron":5,
            "David Feron":4,
            "Marilyn Feron":1,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":8,
            "Michael Feron":0,
            "Josie Feron":2,
            "Heather Paul":9,
            "Colton Paul":11,
            "Cody Paul":4
        },
        "Finland":{
            "Michele Noonan":0,
            "Gregory Feron":0,
            "David Feron":0,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":1,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":0,
            "Colton Paul":0,
            "Cody Paul":0
        },
        "Eastern Europe & Russia":{
            "Michele Noonan":15,
            "Gregory Feron":7,
            "David Feron":9,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":0,
            "Michael Feron":3,
            "Josie Feron":0,
            "Heather Paul":5,
            "Colton Paul":3,
            "Cody Paul":2
        },
        "European Jewish":{
            "Michele Noonan":0,
            "Gregory Feron":0,
            "David Feron":0,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":0,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":0,
            "Colton Paul":8,
            "Cody Paul":5
        },
        "Baltics":{
            "Michele Noonan":2,
            "Gregory Feron":2,
            "David Feron":0,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":0,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":1,
            "Colton Paul":0,
            "Cody Paul":1
        },
        "Sardinia":{
            "Michele Noonan":0,
            "Gregory Feron":1,
            "David Feron":0,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":0,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":0,
            "Colton Paul":0,
            "Cody Paul":0
        },
        "Indigenous North America":{
            "Michele Noonan":0,
            "Gregory Feron":0,
            "David Feron":0,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":0,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":0,
            "Colton Paul":2,
            "Cody Paul":2
        },
        "Northern Philippines":{
            "Michele Noonan":0,
            "Gregory Feron":0,
            "David Feron":0,
            "Marilyn Feron":0,
            "Kathy Mortenson":0,
            "Eileen Shanley":0,
            "Emily Mortenson":0,
            "Michael Feron":0,
            "Josie Feron":0,
            "Heather Paul":0,
            "Colton Paul":2,
            "Cody Paul":1
        }
    };

    function set_th(label) {
        let th = document.createElement("th");
        th.setAttribute("data-type", "number");
        if (label === "Region") {
            th.setAttribute("class", "first");
        }

        let btn = document.createElement("button");
        btn.setAttribute("class", "table__header");
        let txt = document.createTextNode(label);

        btn.appendChild(txt);
        th.appendChild(btn);
        return th;
    }

    function set_thead(table, people) {
        let thead = table.createTHead();
        let row = thead.insertRow();

        let th = set_th("Region");
        row.appendChild(th);

        people.forEach( person => {
            let th = set_th(person);
            row.appendChild(th);
        });
    }

    function insert_td(row, label) {
        let cell = row.insertCell();
        let text = document.createTextNode(label);
        cell.appendChild(text);
    }

    function set_tbody(table, regions, people) {
        let tbody = table.createTBody();
        for (region of regions) {
            let row = tbody.insertRow();
            insert_td(row, region);
            Object.values(data[region]).forEach( person => {
                insert_td(row, person);
            });
        }
    }

    const regions = Object.keys(data);
    const people = Object.keys(data[regions[0]]);
    let table = document.getElementById("table");
    set_thead(table, people);
    set_tbody(table, regions, people);
}


function set_images() {
    class Image {
        constructor(src, title, include_header = true) {
            this.src = src;
            this.title = title;
            this.include_header = include_header;
        }
    };

    let images = [
        new Image("img/pie.png", "Feron Family", include_header = false),
        new Image("img/ethnic-similarity.png", "Ethnic Similarity Scores"),
        new Image("img/pca-biplots.png", "Principal Component Analysis"),
        new Image("img/phylo.png", "Complete Linkage Hierarchical Clustering")
    ];

    let body = document.body;
    images.forEach( image => {
        for (let i = 0; i < 2; i++) {
            let br = document.createElement("br");
            body.appendChild(br);
        }

        if (image.include_header) {
            let header = document.createElement("h2");
            header.innerHTML = image.title;
            body.appendChild(header);
        }

        let div = document.createElement("div");
        let center = document.createElement("center");
        let img = document.createElement("img");
        img.setAttribute("src", image.src);
        img.setAttribute("alt", image.title)

        center.appendChild(img);
        div.appendChild(center);
        body.appendChild(div);
    });
}

generate_table();
set_images();



/* 
    Sort table by clicking column headers.
    See https://htmldom.dev/sort-a-table-by-clicking-its-headers/
 */
const table = document.getElementById('table');
const headers = table.querySelectorAll('th');
const tableBody = table.querySelector('tbody');
const rows = tableBody.querySelectorAll('tr');

// Track sort directions
const directions = Array.from(headers).map(function (header) {
    return '';
});

// Transform the content of given cell in given column
const transform = function (index, content) {
    // Get the data type of column
    const type = headers[index].getAttribute('data-type');
    switch (type) {
        case 'number':
            return parseInt(content);
        case 'string':
        default:
            return content;
    }
};

const sortColumn = function (index) {
    // Get the current direction
    const direction = directions[index] || 'desc';

    // A factor based on the direction
    const multiplier = direction === 'asc' ? 1 : -1;

    const newRows = Array.from(rows);

    newRows.sort(function (rowA, rowB) {
        const cellA = rowA.querySelectorAll('td')[index].innerHTML;
        const cellB = rowB.querySelectorAll('td')[index].innerHTML;

        const a = transform(index, cellA);
        const b = transform(index, cellB);

        switch (true) {
            case a > b:
                return 1 * multiplier;
            case a < b:
                return -1 * multiplier;
            case a === b:
                return 0;
        }
    });

    // Remove old rows
    [].forEach.call(rows, function (row) {
        tableBody.removeChild(row);
    });

    // Reverse the direction
    directions[index] = direction === 'asc' ? 'desc' : 'asc';

    // Append new row
    newRows.forEach(function (newRow) {
        tableBody.appendChild(newRow);
    });
};

[].forEach.call(headers, function (header, index) {
    header.addEventListener('click', function () {
        sortColumn(index);
    });
});
