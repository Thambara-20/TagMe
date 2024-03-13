import * as React from "react";
import { useState } from "react";
import { useDemoData } from "@mui/x-data-grid-generator";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";
import Title from "./Title";

export default function Table() {
  const { data, loading } = useDemoData({
    dataSet: "Commodity",
    rowLength: 14,
    maxColumns: 6,
  });

  const [selectedRow, setSelectedRow] = useState(null);

  const handleRowClick = (params) => {
    setSelectedRow(params.row);
  };

  const handleCloseDialog = () => {
    setSelectedRow(null);
  };

  return (
    <div style={{ height: 400, width: "90%" }}>
      <DataGrid
        {...data}
        loading={loading}
        slots={{ toolbar: GridToolbar }}
        onRowClick={handleRowClick}
      />
      <Dialog
        open={!!selectedRow}
        onClose={handleCloseDialog}
        fullWidth
        maxWidth="lg"
      >
        <DialogContent >
          <Title text={"Event Attendance Sheet"} />
          <div style={{ height: 400, width: "100%", overflow: "auto"}}>
            <DataGrid
              slots={{ toolbar: GridToolbar }}
              rows={data.rows}
              columns={data.columns}
              loading={loading}
              disableColumnMenu
              disableColumnSelector
              disableSelectionOnClick
            />
          </div>
        </DialogContent>
      </Dialog>
    </div>
  );
}
