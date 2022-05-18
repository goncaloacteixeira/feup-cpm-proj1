import './App.css';
import React from "react";
import axios from "axios";
import {DataGrid} from "@mui/x-data-grid";
import {Button} from "@mui/material";
var JsBarcode = require('jsbarcode');
// Canvas v2
var { createCanvas } = require("canvas");

const columns = [
  { field: 'name', headerName: 'Name', minWidth: 300},
  { field: 'description', headerName: 'Description', minWidth: 650 },
  { field: 'price', headerName: 'Price', minWidth: 100,
    renderCell: (params) => params.value + "€"},
  { field: 'make', headerName: 'Make', minWidth: 250},
  {
    field: "barcode",
    headerName: "Barcode",
    sortable: false,
    renderCell: (params) => {
      const onClick = (e) => {
        e.stopPropagation(); // don't select this row after clicking

        createCanvas(200, 200);

        JsBarcode("#barcode", params.value, {format: 'UPC', flat: true})
      };

      return <Button onClick={onClick}>Show</Button>;
    }
  },
];

function App() {
  const [items, setItems] = React.useState(null)

  React.useEffect(() => {
    axios.get("/items")
      .then(res => {
        const data = res.data.map((row) => {
          return {
            id: row.uuid,
            name: row.name,
            description: row.description,
            price: row.price,
            barcode: row.barcode,
            make: row.make,
          };
        })
        setItems(data)
      })

  }, [])


  return (
    <>
      <div style={{width: '100vw', height: '80vh'}}>
        {!items ? null : <DataGrid rowHeight={35} rows={items} columns={columns} />}
      </div>
      <div align="center">
        <canvas id="barcode"></canvas>
      </div>
    </>
  );
}

export default App;
