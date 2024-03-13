import * as React from "react";
import { useState, useEffect } from "react";
import { DataGrid, GridToolbar } from "@mui/x-data-grid";
import { memberData, prospectData } from "../utilities";

const EventDataGrid = ({ participants = [] }) => {
  const [data, setData] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchMemberData = async () => {
      setLoading(true);
      console.log("Fetching Member Data for:", participants);
      try {
        await Promise.all(
          participants.map(async (participant) => {
            const member = await memberData(participant);
            if (member.length > 0) {
              setData((prevData) => [...prevData, ...member]);
            } else {
              const prospect = await prospectData(participant);
              if (prospect.length > 0) {
                setData((prevData) => [...prevData, ...prospect]);
              }
            }
          })
        );
      } catch (error) {
        console.error("Error fetching data: ", error);
      } finally {
        setLoading(false);
      }
    };

    fetchMemberData();
  }, [participants]);

  const columns = [
    { field: "id", headerName: "ID", width: 200 },
    { field: "designation", headerName: "Designation", width: 200 },
    { field: "district", headerName: "District", width: 200 },
    { field: "name", headerName: "Name", width: 200 },
    { field: "userClub", headerName: "User Club", width: 200 },
  ];

  return (
    <div style={{ height: 500, width: "100%" }}>
      <DataGrid
        rows={data}
        columns={columns}
        loading={loading}
        disableColumnMenu
        disableColumnSelector
        disableSelectionOnClick
        components={{
          Toolbar: GridToolbar,
        }}
      />
    </div>
  );
};

export default EventDataGrid;
