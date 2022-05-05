/* 
    Generate table and fill with data.
    This function accesses global 'var data' from js/data.js.
 */
function generate_table() {
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

    function set_tbody(table, regions) {
        let tbody = table.createTBody();
        regions.forEach( region => {
            let row = tbody.insertRow();
            insert_td(row, region);
            Object.values(data[region]).forEach( person => {
                insert_td(row, person);
            });
        });
    }

    const regions = Object.keys(data);
    const people = Object.keys(data[regions[0]]);
    let table = document.getElementById("table");
    set_thead(table, people);
    set_tbody(table, regions);
}

/* 
    Fill body with images.
 */
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
function sortTableByColumn() {
    const table = document.getElementById("table");
    const headers = table.querySelectorAll("th");
    const tableBody = table.querySelector("tbody");
    const rows = tableBody.querySelectorAll("tr");
    
    // Array for tracking sort direction (will flip-flop for each column).
    const directions = Array(headers.length).fill("");
    
    // Returns cell content as Number. Strings return 0 (to preserve original order).
    function transform(index, content) {
        const type = headers[index].getAttribute("data-type");
        return type === "number" ? Number(content) : 0;
    };
    
    function sortColumn(index) {
        // Get the sort direction (defaults to descending on first sort).
        const direction = directions[index] || "desc";
    
        // For use in newRows.sort function.
        const multiplier = direction === "asc" ? 1 : -1;
    
        const newRows = Array.from(rows);
        newRows.sort(function (rowA, rowB) {
            const cellA = rowA.querySelectorAll("td")[index].innerHTML;
            const cellB = rowB.querySelectorAll("td")[index].innerHTML;
    
            const a = transform(index, cellA);
            const b = transform(index, cellB);
    
            return multiplier * (a > b ? 1 : a < b ? -1 : 0);
        });
    
        // Remove old rows.
        rows.forEach( row => {
            tableBody.removeChild(row);
        });
    
        // Reverse column's sort direction.
        directions[index] = direction === "asc" ? "desc" : "asc";
    
        // Append new rows.
        newRows.forEach( newRow => {
            tableBody.appendChild(newRow);
        });
    };
    
    // Add sorting by click to each header.
    headers.forEach( (header, index) => {
        header.addEventListener("click", () => {
            sortColumn(index);
        });
    });
}
sortTableByColumn();


/*
   FUNCTION IN PROGRESS, DO NOT CALL.
   This function works, essentially, but is not compatible with column sorting.
*/
/*
function sortRows() {
    let index = 2;
    const direction = directions[index] || "desc";
    const multiplier = direction === "asc" ? 1 : -1;

    // Numeric data from row to sort by.
    const baseRow = Array.from(rows[index].querySelectorAll("td")).map( x => {
        return Number(x.innerHTML);
    });

    // Ordered indices of baseRow.
    const perm = Array.from(Array(baseRow.length).keys()).sort( (a, b) => {
        return multiplier * (baseRow[a] > baseRow[b] ? 1 : baseRow[a] < baseRow[b] ? -1 : 0);
    });

    let newRows = [];
    rows.forEach( tr => {
        let tds = tr.querySelectorAll("td"); // Node list of tds in current tr.
        let newtds = Array.from(tds).map( (td, idx) => tds[perm[idx]] );
        tableBody.removeChild(tr);

        let newRow = document.createElement("tr");
        newtds.forEach( td => newRow.appendChild(td) );
        newRows.push(newRow);
    });
    console.log(newRows);

    newRows.forEach( tr => {
        tableBody.appendChild(tr);
    });

    console.log(table);
}
*/
