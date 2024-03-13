import React, { useState } from "react";
import { Grid } from "@mui/material";
import Selecter from "./Dropdowns";
import { useEffect } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import Dialog from "@mui/material/Dialog";
import DialogContent from "@mui/material/DialogContent";
import Title from "./Title";
import { fetchEvents } from "../utilities";

const Content = () => {
  const [district, setDistricts] = useState("");
  const [year, setYear] = useState("");
  const [month, setMonth] = useState("");

  const handleDistrictChange = (event) => {
    setDistricts(event.target.value);
  };

  const handleYearChange = (event) => {
    setYear(event.target.value);
  };

  const handleMonthChange = (event) => {
    setMonth(event.target.value);
  };

  const [eventsList, setEventsList] = useState([]);
  const [loading, setLoading] = useState(true);
  const [selectedRow, setSelectedRow] = useState(null);

  useEffect(() => {
    const fetchEventsData = async () => {
      setLoading(true);
      try {
        const allEvents = await fetchEvents();
        console.log("Fetching events for district: ", district);
        const filteredEvents = allEvents.filter(
          (event) =>
            event.district.toLowerCase() === String(district).toLowerCase() &&
            event.startTime.getFullYear() === Number(year) &&
            (!month || getMonthName(new Date(event.startTime)) === month)
        );

        for (let i = 0; i < filteredEvents.length; i++) {}
        setEventsList(filteredEvents);
        setLoading(false);
      } catch (error) {
        console.error("Error fetching events: ", error);
      }
    };

    fetchEventsData();
  }, [district, year, month]);

  const handleRowClick = (params) => {
    setSelectedRow(params.row);
  };

  const handleCloseDialog = () => {
    setSelectedRow(null);
  };

  const getMonthName = (date) => {
    return date.toLocaleString("default", { month: "long" });
  };

  return (
    <Grid
      container
      spacing={0}
      sx={{
        display: "flex",
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "center",
        py: 5,
        px: 2,
      }}
    >
      <Selecter text="District" onChange={handleDistrictChange} />
      <Selecter text="Year" onChange={handleYearChange} />
      <Selecter text="Month" onChange={handleMonthChange} />
      <div style={{ height: 500, width: "90%" }}>
        <DataGrid
          rows={eventsList}
          slots={{ toolbar: GridToolbar }}
          columns={[
            { field: "id", headerName: "ID", width: 100 },
            { field: "district", headerName: "District", width: 150 },
            { field: "location", headerName: "Location", width: 200 },
            { field: "name", headerName: "Name", width: 200 },
            { field: "participants", headerName: "Participants", width: 200 },
            { field: "startTime", headerName: "Start Time", width: 200 },
            { field: "endTime", headerName: "End Time", width: 200 },
          ]}
          loading={loading}
          disableColumnMenu
          disableColumnSelector
          disableSelectionOnClick
          onRowClick={handleRowClick}
        />
        <Dialog
          open={!!selectedRow}
          onClose={handleCloseDialog}
          fullWidth
          maxWidth="lg"
        >
          <DialogContent>
            <Title text={"Event Attendance Sheet"} />
            <div style={{ height: 500, width: "100%", overflow: "auto" }}>
              <DataGrid
                slots={{ toolbar: GridToolbar }}
                rows={[selectedRow]}
                columns={[
                  { field: "id", headerName: "ID", width: 150 },
                  { field: "district", headerName: "District", width: 150 },
                  { field: "endTime", headerName: "End Time", width: 200 },
                  { field: "location", headerName: "Location", width: 150 },
                  { field: "name", headerName: "Name", width: 150 },
                  {
                    field: "participants",
                    headerName: "Participants",
                    width: 200,
                  },
                  { field: "startTime", headerName: "Start Time", width: 200 },
                ]}
                loading={loading}
                autoHeight
                disableColumnMenu
                disableColumnSelector
                disableSelectionOnClick
              />
            </div>
          </DialogContent>
        </Dialog>
      </div>
    </Grid>
  );
};

export default Content;
